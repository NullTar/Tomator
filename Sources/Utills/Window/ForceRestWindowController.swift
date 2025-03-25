import Carbon.HIToolbox
import Combine
import SwiftUI

// 全屏强制休息窗口管理器
class ForceRestWindowController: ObservableObject {
    static let shared = ForceRestWindowController()
    private var window: NSWindow?
    private var extraWindows: [NSWindow] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var timeRemaining: String = ""
    @Published var isLongBreak: Bool = false
    private var keyboardMonitor: Any?

    private init() {}

    // 显示强制休息窗口
    func showForceRestWindow(timeRemaining: String, isLongBreak: Bool) {
        self.timeRemaining = timeRemaining
        self.isLongBreak = isLongBreak

        // 如果已有窗口，仅更新状态
        if window != nil {
            return
        }

        // 创建新窗口
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1000, height: 800),
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        // 配置窗口属性
        window.isReleasedWhenClosed = false
        window.center()
        window.isOpaque = false
        window.hasShadow = false
        window.canHide = false
        window.isMovable = false
        window.setIsZoomed(false)

        // 清理背景
        if AppSetter.shared.appearance.background != .gradation {
            window.backgroundColor = NSColor.clear
        }

        // 必须接收鼠标事件才能阻止穿透
        window.ignoresMouseEvents = false
        // 设置最高窗口层级，确保覆盖所有内容 screenSaver 是非常高的窗口级别
        window.level = .screenSaver
        // 确保窗口在所有工作区都显示，并且在全屏模式下也能显示
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        // 设置SwiftUI内容视图
        let contentView = ForceRest()
            .environmentObject(AppSetter.shared)
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        self.window = window

        // 安装键盘监听器，拦截组合键
        installKeyboardMonitor()
        // 确保窗口始终在最前面
        setupWindowMonitoring()
        // 全屏显示
        makeWindowFullScreen()
        // 获取所有显示器并在每个显示器上显示窗口
        coverAllScreens()
    }

    // 关闭强制休息窗口
    func closeForceRestWindow() {
        // 移除键盘监听器
        uninstallKeyboardMonitor()

        // 关闭主窗口
        if let window = self.window {
            window.close()
            self.window = nil
        }

        // 关闭所有额外的窗口
        for window in extraWindows {
            window.close()
        }
        extraWindows.removeAll()

        cancellables.removeAll()
    }

    // 安装监听器
    private func installKeyboardMonitor() {
        keyboardMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            event in
            if event.modifierFlags.contains(.command) {
                return nil
            }
            if event.modifierFlags.contains(.option) {
                return nil
            }
            if event.modifierFlags.contains(.control) {
                return nil
            }
            if event.modifierFlags.contains(.shift) {
                return nil
            }
            return event
        }
    }

    // 移除监听器
    private func uninstallKeyboardMonitor() {
        if let keyboardMonitor = keyboardMonitor {
            NSEvent.removeMonitor(keyboardMonitor)
            self.keyboardMonitor = nil
        }
    }

    // 确保窗口始终在最前面
    private func setupWindowMonitoring() {
        NotificationCenter.default.publisher(
            for: NSWindow.didResignKeyNotification
        )
        .sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.window?.makeKeyAndOrderFront(nil)
            }
        }
        .store(in: &cancellables)

        // 定期检查窗口是否最前，防止被其他应用覆盖
        Timer.publish(every: 0.3, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.window?.makeKeyAndOrderFront(nil)
                self?.makeWindowFullScreen()

                // 重新设置窗口级别，确保始终在最上层
                self?.window?.level = .screenSaver

                // 确保所有额外的窗口也在最上层
                for window in self?.extraWindows ?? [] {
                    window.makeKeyAndOrderFront(nil)
                    window.level = .screenSaver
                }

                // 阻止应用程序被隐藏
                NSApp.unhide(nil)
            }
            .store(in: &cancellables)

        // 监听应用程序将要终止的通知
        NotificationCenter.default.publisher(
            for: NSApplication.willTerminateNotification
        )
        .sink { [weak self] _ in
            // 如果强制休息窗口正在显示，则阻止应用程序终止
            if self?.window != nil {
                // 通过创建一个新的运行循环事件来中断终止过程
                // 这是一个激进的方法，但在强制休息的上下文中是合理的
                DispatchQueue.main.async {
                    NSApp.activate(ignoringOtherApps: true)
                }
            }
        }
        .store(in: &cancellables)
    }

    // 使窗口全屏
    private func makeWindowFullScreen() {
        guard let window = self.window else { return }

        // 获取当前显示器的框架
        if let screen = NSScreen.main {
            window.setFrame(screen.frame, display: true)
        }
    }

    // 覆盖所有屏幕（多显示器支持）
    private func coverAllScreens() {
        // 主窗口已经创建，现在检查其他显示器
        let screens = NSScreen.screens
        if screens.count > 1 {
            // 有多个显示器，为每个非主显示器创建额外窗口
            for (index, screen) in screens.enumerated() {
                if index > 0 || screen != NSScreen.main {  // 跳过主显示器
                    let extraWindow = NSWindow(
                        contentRect: screen.frame,
                        styleMask: [.borderless],
                        backing: .buffered,
                        defer: false
                    )
                    extraWindow.level = .screenSaver
                    extraWindow.backgroundColor = NSColor.black
                        .withAlphaComponent(0.7)
                    extraWindow.isOpaque = false
                    extraWindow.hasShadow = false
                    extraWindow.ignoresMouseEvents = false
                    extraWindow.collectionBehavior = [
                        .canJoinAllSpaces, .fullScreenAuxiliary,
                    ]

                    // 设置与主窗口相同的大小和位置
                    extraWindow.setFrame(screen.frame, display: true)
                    extraWindow.makeKeyAndOrderFront(nil)
                    extraWindows.append(extraWindow)
                }
            }
        }
    }

    // 更新剩余时间
    func updateTimeRemaining(_ timeString: String) {
        self.timeRemaining = timeString
    }
}

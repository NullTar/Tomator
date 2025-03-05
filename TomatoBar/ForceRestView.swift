import SwiftUI
import Combine

// 全屏强制休息窗口管理器
class ForceRestWindowManager: ObservableObject {
    static let shared = ForceRestWindowManager()
    private var window: NSWindow?
    private var cancellables = Set<AnyCancellable>()
    @Published var timeRemaining: String = ""
    @Published var isLongBreak: Bool = false
    
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
            contentRect: NSRect(x: 0, y: 0, width: 1000, height: 700),
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // 配置窗口属性
        window.isReleasedWhenClosed = false
        window.center()
        window.backgroundColor = NSColor.clear
        window.isOpaque = false
        window.hasShadow = false
        window.level = .floating // 窗口层级高于普通窗口
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        // 设置SwiftUI内容视图
        let contentView = ForceRestView()
            .environmentObject(self)
        window.contentView = NSHostingView(rootView: contentView)
        
        self.window = window
        window.makeKeyAndOrderFront(nil)
        
        // 确保窗口始终在最前面
        setupWindowMonitoring()
        
        // 全屏显示
        makeWindowFullScreen()
    }
    
    // 关闭强制休息窗口
    func closeForceRestWindow() {
        if let window = self.window {
            window.close()
            self.window = nil
            cancellables.removeAll()
        }
    }
    
    // 确保窗口始终在最前面
    private func setupWindowMonitoring() {
        NotificationCenter.default.publisher(for: NSWindow.didResignKeyNotification)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.window?.makeKeyAndOrderFront(nil)
                }
            }
            .store(in: &cancellables)
        
        // 定期检查窗口是否最前
        Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.window?.makeKeyAndOrderFront(nil)
                self?.makeWindowFullScreen()
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
    
    // 更新剩余时间
    func updateTimeRemaining(_ timeString: String) {
        self.timeRemaining = timeString
    }
}

// 强制休息视图
struct ForceRestView: View {
    @EnvironmentObject var manager: ForceRestWindowManager
    
    var body: some View {
        ZStack {
            // 半透明背景
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // 休息图标
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                // 休息提示文本
                Text(manager.isLongBreak ? 
                     NSLocalizedString("ForceRestView.longBreak.title", comment: "Long break title") :
                     NSLocalizedString("ForceRestView.shortBreak.title", comment: "Short break title"))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                // 详细提示
                Text(NSLocalizedString("ForceRestView.description", comment: "Rest description"))
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // 计时器
                Text(manager.timeRemaining)
                    .font(.system(size: 60, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                // 底部提示
                Text(NSLocalizedString("ForceRestView.cannot_skip", comment: "Cannot skip"))
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 40)
            }
            .padding(50)
        }
        // 禁用所有交互
        .allowsHitTesting(true)
    }
} 
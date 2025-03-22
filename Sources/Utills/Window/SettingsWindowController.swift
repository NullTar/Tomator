import Cocoa
import SwiftUI

// 统计窗口控制器 - 负责显示统计窗口作为单独窗口
@available(macOS 13.0, *)
class SettingsWindowController: NSWindowController {
    static let shared = SettingsWindowController()
    @ObservedObject var windowProperties = WindowProperties(width: 600, height: 440)
    
    private override init(window: NSWindow?) {
        // 创建窗口
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 440),
            styleMask: [.titled, .closable,.miniaturizable],
            backing: .buffered,
            defer: false
        )

        // 设置窗口属性
        window.title = NSLocalizedString("SettingWindow.title", comment: "设置窗口")
        window.center()
        window.isReleasedWhenClosed = false
        // 先 super.init
        super.init(window: window)
        // 创建 SwiftUI 主机视图
        let settingsView = AppSettings()
            .environmentObject(self.windowProperties)
        window.contentView = NSHostingView(rootView: settingsView)
        logger.append(event: Init(object: "SettinsWindowController"))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showSettingWindow() {
        if window?.isVisible == false {
            window?.center()
            showWindow(nil)
        }
        NSApp.activate(ignoringOtherApps: true)
        window?.makeKeyAndOrderFront(nil)
    }
    
    func updateFrame(width:CGFloat,height:CGFloat) {
        windowProperties.setUpFrame(width: width,height: height)
        if let contentView = window?.contentView {
            var contentFrame = contentView.frame
            contentFrame.size.width = windowProperties.width
            contentFrame.size.height = windowProperties.height
            contentView.frame = contentFrame
        }
    }
    
}


import Cocoa
import SwiftUI

// 统计窗口控制器 - 负责显示统计窗口作为单独窗口
@available(macOS 13.0, *)
class StatsWindowController: NSWindowController {
    static let shared = StatsWindowController()
    
    private override init(window: NSWindow?) {
        // 创建窗口
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 600),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )

        // 设置窗口属性
        window.title = NSLocalizedString("StatsWindow.title", comment: "统计窗口")
        window.center()
        window.isReleasedWhenClosed = false
        window.setIsZoomed(false)

        // 创建 SwiftUI 主机视图
        let statsView = StatsView()
        window.contentView = NSHostingView(rootView: statsView)

        super.init(window: window)
        logger.append(event: Init(object: "StatsWindowController"))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 显示统计窗口
    func showStatsWindow() {
        if window?.isVisible == false{
            window?.center()
        }
        showWindow(nil)
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

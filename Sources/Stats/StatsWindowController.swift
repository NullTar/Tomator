import Cocoa
import SwiftUI

// 统计窗口控制器 - 负责显示统计窗口作为单独窗口
@available(macOS 13.0, *)
class StatsWindowController: NSWindowController {
    static let shared = StatsWindowController()
    
    private override init(window: NSWindow?) {
        // 创建窗口
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 380, height: 600),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        // 设置窗口属性
        window.title = NSLocalizedString("StatsWindow.title", comment: "Statistics")
        window.center()
        window.isReleasedWhenClosed = false
        window.minSize = NSSize(width: 320, height: 400)
        
        // 创建 SwiftUI 主机视图
        let statsView = StatsView()
        window.contentView = NSHostingView(rootView: statsView)
        
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 显示统计窗口
    func showStatsWindow() {
        if window?.isVisible == false {
            window?.center()
            showWindow(nil)
        }
        
        // 确保窗口在前端并获得焦点
        NSApp.activate(ignoringOtherApps: true)
        window?.makeKeyAndOrderFront(nil)
    }
} 
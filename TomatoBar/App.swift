import SwiftUI

// 定义状态栏图标的名称常量
extension NSImage.Name {
    static let idle = Self("BarIconIdle")          // 空闲状态图标
    static let work = Self("BarIconWork")          // 工作状态图标
    static let shortRest = Self("BarIconShortRest") // 短休息状态图标
    static let longRest = Self("BarIconLongRest")   // 长休息状态图标
}

// 定义等宽数字字体，用于状态栏显示
private let digitFont = NSFont.monospacedDigitSystemFont(ofSize: 0, weight: .regular)

@main
struct TBApp: App {
    // 将TBStatusItem作为应用程序的代理
    @NSApplicationDelegateAdaptor(TBStatusItem.self) var appDelegate
    @AppStorage("launchAtLogin") private var launchAtLogin = false

    init() {
        // 初始化共享实例
        TBStatusItem.shared = appDelegate
        // 记录应用启动事件
        logger.append(event: TBLogEventAppStart())
        
        // 确保开机启动设置与当前状态一致
        if launchAtLogin {
            // 在应用启动时同步开机启动设置
            DispatchQueue.main.async {
                let timer = TBTimer()
                timer.setLaunchAtLogin(true)
            }
        }
    }

    // 应用程序的主体场景
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

// 状态栏项管理类，实现应用程序代理协议
class TBStatusItem: NSObject, NSApplicationDelegate {
    private var popover = NSPopover()              // 弹出窗口
    private var statusBarItem: NSStatusItem?       // 状态栏项
    static var shared: TBStatusItem!               // 共享实例

    // 应用程序启动完成时调用
    func applicationDidFinishLaunching(_: Notification) {
        let view = TBPopoverView()

        // 配置弹出窗口
        popover.behavior = .transient
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: view)
        if let contentViewController = popover.contentViewController {
            popover.contentSize.height = contentViewController.view.intrinsicContentSize.height
            popover.contentSize.width = 240
        }

        // 创建并配置状态栏项
        statusBarItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.variableLength
        )
        statusBarItem?.button?.imagePosition = .imageLeft
        setIcon(name: .idle)
        statusBarItem?.button?.action = #selector(TBStatusItem.togglePopover(_:))
    }

    // 设置状态栏项的标题
    func setTitle(title: String?) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.9
        paragraphStyle.alignment = NSTextAlignment.center

        let attributedTitle = NSAttributedString(
            string: title != nil ? " \(title!)" : "",
            attributes: [
                NSAttributedString.Key.font: digitFont,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        statusBarItem?.button?.attributedTitle = attributedTitle
    }

    // 设置状态栏项的图标
    func setIcon(name: NSImage.Name) {
        statusBarItem?.button?.image = NSImage(named: name)
    }

    // 显示弹出窗口
    func showPopover(_: AnyObject?) {
        if let button = statusBarItem?.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }

    // 关闭弹出窗口
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }

    // 切换弹出窗口的显示状态
    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
}

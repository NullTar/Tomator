//
//  AppStatusItem.swift
//
//  Created by NullSilck on 2025/3/13.
//

import AppKit
import Foundation
import SwiftUI

// 定义等宽数字字体，用于状态栏显示
private let digitFont = NSFont.monospacedDigitSystemFont(
    ofSize: 0, weight: .regular)

// 状态栏项管理类，实现应用程序代理协议
class MenuBarController: NSObject, NSApplicationDelegate {
    static var shared: MenuBarController!  // 共享实例
    private var popover = NSPopover()  // 弹出窗口
    private var statusBarItem: NSStatusItem?  // 状态栏项
    @Published var windowProperties = WindowProperties(
        width: 260, height: 280)

    // 应用程序启动完成时调用
    func applicationDidFinishLaunching(_: Notification) {
        let view = PopoverView()

        // 配置弹出窗口
        popover.behavior = .transient
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: view)
        popover.contentSize = NSSize(
            width: 260,
            height: popover.contentViewController?.view.intrinsicContentSize
                .height ?? 280)
        // 创建并配置状态栏项
        statusBarItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.variableLength
        )
        statusBarItem?.button?.imagePosition = .imageLeft
        setIcon(name: .idle)
        statusBarItem?.button?.action = #selector(
            MenuBarController.togglePopover(_:))
        initHeight()
        // 避免死锁，放这里了
        AppSetter.shared.checkCountdownDiaplay()
        AppSetter.shared.checkSoundSetting()
    }

    // 设置状态栏项的标题
    func setTitle(title: String?) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1
        paragraphStyle.alignment = NSTextAlignment.center

        let attributedTitle = NSAttributedString(
            string: title != nil ? " \(title!)" : "",
            attributes: [
                NSAttributedString.Key.font: digitFont,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
            ]
        )
        statusBarItem?.button?.attributedTitle = attributedTitle
    }

    // 设置状态栏项的图标
    func setIcon(name: NSImage.Name) {
        statusBarItem?.button?.image = NSImage(named: name)
    }

    // 显示弹出窗口
    private func showPopoverWindow(_: AnyObject?) {
        if let button = statusBarItem?.button {
            popover.show(
                relativeTo: button.bounds, of: button,
                preferredEdge: NSRectEdge.minY)
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
            showPopoverWindow(sender)
        }
    }

    func updateEdg(toggle: Bool, edg: WindowEdg, quantity: CGFloat) {
        var operation: WindowOperation = .minus
        if toggle == true {
            operation = .plus
        }
        windowProperties.updateEdg(
            edg: edg, operation: operation, quantity: quantity)
        popover.contentSize = NSSize(
            width: windowProperties.width, height: windowProperties.height)
    }

    func initHeight() {
        var edg = 0
        if AppSetter.shared.forceRest {
            windowProperties.height += 40
        }
        if AppSetter.shared.scheduleExpanded , AppSetter.shared.scheduleExpanded {
            windowProperties.height += 120
        }
        if AppSetter.shared.scheduleMenu {
            edg += 1
        }
        if AppSetter.shared.forceRestMenu {
            edg += 1
        }
        if AppSetter.shared.shortRestMenu {
            edg += 1
        }
        if AppSetter.shared.stopAfterBrekeMenu {
            edg += 1
        }
        while 0 < edg {
            windowProperties.height += 30
            edg -= 1
        }
    }

    
}

#Preview {
    PopoverView()
}

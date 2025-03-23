//
//  AppSetter.swift
//
//  Created by NullSilck on 2025/3/13.
//

import Combine
import Foundation
import ServiceManagement
import SwiftUI

class AppSetter: ObservableObject {

    static let shared = AppSetter()

    ////////// App 功能管理
    // 通知中心
    private let notificationCenter = AppNotificationCenter()
    // 音效播放器
    private let soundPlayer = SoundPlayer.shared
    // 强制休息窗口管理器
    @Published var forceRestWindowController = ForceRestWindowController.shared
    // 统计管理器实例
    @Published var statsManager = AppStatsDataViewModel.shared

    //////////  检测
    @AppStorage("scheduleExpanded") var scheduleExpanded: Bool = false
    @Published var scheduleAlert: String = ""

    ////////// 菜单栏设置
    // 显示小憩时间
    @AppStorage("shortRestMenu") var shortRestMenu = false
    // 显示强制休息
    @AppStorage("addTimeMenu") var addTimeMenu = true
    // 显示时间表
    @AppStorage("scheduleMenu") var scheduleMenu = false
    // 显示休息后停止
    @AppStorage("stopAfterBrekeMenu") var stopAfterBrekeMenu = false
    // 显示强制休息
    @AppStorage("forceRestMenu") var forceRestMenu = true

    ////////// 功能设置
    // 开机启动
    @AppStorage("launchAtLogin") var launchAtLogin = true
    // 样式 颜色、背景、模糊
    @AppStorage("appAppearance") private var appearanceData: Data = Data()
    // 设置的背景图
    @AppStorage("customizePic") var customizePic: Data = Data()
    // 通知设置
    @AppStorage("notification") var notification = true
    // 声音设置
    @AppStorage("appSound") var appSound = false
    // 在菜单栏显示计时器
    @AppStorage("showTimerInMenuBar") var showTimerInMenuBar = true
    // 在菜单栏常显计时器
    @AppStorage("showTimerInMenuBarAways") var showTimerInMenuBarAways = false
    // 休息后停止
    @AppStorage("stopAfterBreak") var stopAfterBreak = false
    // 强制休息
    @AppStorage("forceRest") var forceRest = true
    // 隐藏 跳过强制休息
    @AppStorage("hidenSkipForceRest") var hidenSkipForceRest = false
    // 默认值
    @Published var appearance = Appearance(
        color: "Aqua", background: .gradation, blur: 0.8)
    {
        didSet {
            setAppearance()
        }
    }

    private init() {
        // init Appearance
        if let decodeAppearance = getAppearance() {
            appearance = decodeAppearance
        }
        // 注册 URL 处理
        let aem: NSAppleEventManager = NSAppleEventManager.shared()
        aem.setEventHandler(
            self,
            andSelector: #selector(handleGetURLEvent(_:withReplyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL))
    }
    
    // 返回渐变  TODO 渐变组
    func returnGradation() -> some View {
        HStack{
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.4),
                    Color.purple.opacity(0.7),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    // 返回壁纸 TODO
    func returnWallpaper() -> some View {
        HStack{
            if let wallpaper = getDesktopWallpaper() {
               Image(nsImage: wallpaper)
                    .resizable().scaledToFill()
            }
        }
    }
    
    // 返回自定义图片
    func returnCustomize() -> some View {
        HStack{
            Image(nsImage: NSImage(data: customizePic) ?? .init())
                .resizable().scaledToFill()
        }
    }
    
    // 返回桌面
    func returnDesktop() -> some View {
        HStack{
            Image(.screenshot).resizable().scaledToFill()
        }
    }
    
    // 返回壁纸
    func getDesktopWallpaper() -> NSImage? {
        if let screen = NSScreen.screens.first {
            let workspace = NSWorkspace.shared
            if let wallpaperURL = workspace.desktopImageURL(for: screen),
                let image = NSImage(contentsOf: wallpaperURL)
            {
                return image
            }
        }
        return nil
    }


    // 检查菜单栏时间显示
    func checkCountdownDiplayMenu() {
        if !showTimerInMenuBar {
            showTimerInMenuBarAways = false
        } else if showTimerInMenuBar, showTimerInMenuBarAways {
            if AppTimer.shared.timeLeftString == nil {
                AppTimer.shared.timeLeftString = "00:00"
            }
            MenuBarController.shared.setTitle(
                title: AppTimer.shared.timeLeftString)
            return
        }
        MenuBarController.shared.setTitle(title: nil)
    }

    // 设置开机启动状态
    func setLaunchAtLogin(_ enable: Bool) {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""

        // 对于 macOS 13 及以上版本，使用 SMAppService
        if #available(macOS 13.0, *) {
            let service = SMAppService.mainApp
            do {
                if enable {
                    if service.status != .enabled {
                        try service.register()
                    }
                } else {
                    if service.status == .enabled {
                        try service.unregister()
                    }
                }
                logger.append(event: SetLaunch(value: enable))
            } catch {
                print("无法更改登录项状态: \(error.localizedDescription)")
            }
        }
        // 对于 macOS 12 及更早版本，使用旧的 SMLoginItemSetEnabled API
        else {
            let success = SMLoginItemSetEnabled(
                bundleIdentifier as CFString, enable)
            if !success {
                print("无法更改登录项状态：SMLoginItemSetEnabled 失败")
            }
        }
    }

    // 处理 URL 事件
    @objc func handleGetURLEvent(
        _ event: NSAppleEventDescriptor,
        withReplyEvent: NSAppleEventDescriptor
    ) {
        guard
            let urlString = event.forKeyword(AEKeyword(keyDirectObject))?
                .stringValue
        else {
            print("url handling error: cannot get url")
            return
        }
        let url = URL(string: urlString)
        guard url != nil,
            let scheme = url!.scheme,
            let host = url!.host
        else {
            print("url handling error: cannot parse url")
            return
        }
        guard scheme.caseInsensitiveCompare("Tomator") == .orderedSame else {
            print("url handling error: unknown scheme \(scheme)")
            return
        }
        switch host.lowercased() {
        case "startstop":
            AppTimer.shared.startStop()
        default:
            print("url handling error: unknown command \(host)")
            return
        }
    }

    // 编码存储
    private func setAppearance() {
        if let encoded = try? JSONEncoder().encode(appearance) {
            appearanceData = encoded
        }
    }
    // 解码获取
    private func getAppearance() -> Appearance? {
        return try? JSONDecoder().decode(Appearance.self, from: appearanceData)
    }
    
    // 返回 声音设置类
    public var player: SoundPlayer {
        return soundPlayer
    }

    // 返回 通知处理类
    public var notifier: AppNotificationCenter {
        return notificationCenter
    }

}

#Preview {
    AppSettings()
        .environmentObject(AppTimer.shared)
        .environmentObject(AppSetter.shared)
        .environmentObject(SettingsWindowController.shared.windowProperties)
}

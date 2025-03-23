//
//  FeatureSettingView.swift
//
//  Created by NullSilck on 2025/3/15.
//

import SwiftUI

struct FeatureSettingView: View {

    @EnvironmentObject var appTimer: AppTimer
    @EnvironmentObject var appSetter: AppSetter
    
    private var shortTimeStr = NSLocalizedString(
        "ShortRestIntervalLength.label",
        comment: "小憩时间")

    var body: some View {

        VStack(alignment: .leading) {
            Text(NSLocalizedString("Window.Feature.setting", comment: "功能"))
                .fontWeight(.bold).font(.caption)
                .foregroundColor(Color.gray)
                .padding(.leading, 8).padding(.top, 8)
            VStack {
                VStack {
                    // 开机启动选项
                    HStack {
                        Toggle(isOn: $appSetter.launchAtLogin) {
                            Text(
                                NSLocalizedString(
                                    "LaunchAtLogin.label",
                                    comment: "开机启动")
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }.toggleStyle(.switch).tint(Color(appSetter.appearance.color))
                            .onChange(of: appSetter.launchAtLogin) { newValue in
                                appSetter.setLaunchAtLogin(newValue)
                            }
                        InfoConponet(
                            label: NSLocalizedString(
                                "LaunchAtLogin.info",
                                comment: "开机时自动启动应用程序"))
                    }.padding(.top, 2)
                    Divider()
                    // 在菜单栏显示计时器选项
                    HStack {
                        Toggle(isOn: $appSetter.showTimerInMenuBar) {
                            Text(
                                NSLocalizedString(
                                    "ShowTimerInMenuBar.label",
                                    comment: "菜单栏显示")
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .toggleStyle(.switch).tint(Color(appSetter.appearance.color))
                        .onChange(of: appSetter.showTimerInMenuBar) { _ in
                            appTimer.updateTimeLeft()
                        }
                        InfoConponet(
                            label: NSLocalizedString(
                                "ShowOnMenuBar.info",
                                comment: "在菜单栏显示倒计时"))
                    }
                    
                    // 在菜单栏常显计时器
                    HStack {
                        Toggle(isOn: $appSetter.showTimerInMenuBarAways) {
                            Text(
                                NSLocalizedString(
                                    "ShowOnMenuBarAways.label",
                                    comment: "菜单栏常显")
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }.disabled(!appSetter.showTimerInMenuBar)
                            .toggleStyle(.switch).tint(Color(appSetter.appearance.color))
                        .onChange(of: appSetter.showTimerInMenuBarAways) { _ in
                            appSetter.checkCountdownDiplayMenu()
                        }
                        
                        InfoConponet(
                            label: NSLocalizedString(
                                "ShowOnMenuBarAways.info",
                                comment: "倒计时在菜单栏常驻"))
                    }
                    
                    HStack {
                        Toggle(isOn: $appSetter.notification) {
                            Text(
                                NSLocalizedString(
                                    "ShowNotifications.label",
                                    comment: "显示通知")
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .toggleStyle(.switch).tint(Color(appSetter.appearance.color))
                        InfoConponet(
                            label: NSLocalizedString(
                                "ShowNotifications.info",
                                comment: "启用此选项以开启 通知"))
                    }
                    Divider()
                    HStack {
                        SettingCompont(
                            toggle: $appSetter.stopAfterBreak,
                            label: NSLocalizedString(
                                "StopAfterBreak.label", comment: "休息后停止"),
                            appSetter: appSetter)
                        InfoConponet(
                            label: NSLocalizedString(
                                "StopAfterBreak.info",
                                comment: "启用此选项以开启 休息后停止"))
                    }
                    Divider()
                    // 强制休息选项
                    HStack {
                        SettingCompont(
                            toggle: $appSetter.forceRest,
                            label: NSLocalizedString(
                                "ForceRest.label", comment: "强制休息"),
                            appSetter: appSetter)
                        InfoConponet(
                            label: NSLocalizedString(
                                "ForceRest.info",
                                comment: "启用此选项以开启 强制休息"))
                    }
                    // 强制休息警告文字
                    if appSetter.forceRest {
                        Text(
                            NSLocalizedString(
                                "ForceRest.screen",
                                comment: "强制休息警告")
                        )
                        .font(.system(size: 12))
                        .foregroundColor(Color(appSetter.appearance.color))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack {
                        SettingCompont(
                            toggle: $appSetter.hidenSkipForceRest,
                            label: NSLocalizedString(
                                "hidenSkipForceRest.label", comment: "隐藏跳过"),
                            appSetter: appSetter)
                        InfoConponet(
                            label: NSLocalizedString(
                                "hidenSkipForceRest.info",
                                comment: "启用此选项以隐藏强制休息窗口的 跳过按钮"))
                    }
                    Divider()
                    TimeComponent(
                        leadingText: shortTimeStr,
                        interval: $appTimer.shortRestIntervalLength,
                        timeType: TimeType.Short)
                    .environmentObject(appSetter)
                    if $appTimer.shortRestIntervalLength.wrappedValue == 0 {
                        Text(NSLocalizedString("ShotTime.Window.label", comment: "未开启小憩"))
                        .foregroundStyle(Color.gray.opacity(0.9))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.system(.footnote))
                    }
                }.padding(8)
            }.background(Color("CardView")).cornerRadius(8)
                .shadow(color: .gray.opacity(0.5), radius: 0.4)
        }.padding(.horizontal)

    }
}

#Preview {
    AppSettings()
        .environmentObject(AppTimer.shared)
        .environmentObject(AppSetter.shared)
        .environmentObject(SettingsWindowController.shared.windowProperties)
}

//
//  SettingsView.swift
//
//  Created by NullSilck on 2025/3/13.
//

import SwiftUI

// 应用设置视图，用于配置应用的行为
struct AppSettings: View {

    @ObservedObject var appTimer = AppTimer.shared
    @ObservedObject var appSetter = AppSetter.shared
    @EnvironmentObject var windowProperties: WindowProperties

    @State private var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            // 首选项 width: 600, height: 460
            PreferenceSettingView()
                .environmentObject(appTimer)
                .environmentObject(appSetter)
                .tag(0)
                .tabItem {
                    Image(systemName: "gearshape")
                }

            // 外观设置
            AppearanceSetting()
                .environmentObject(appSetter)
                .tag(1)
                .tabItem {
                    Image(systemName: "paintpalette")
                }

            // 声音设置 width: 600, height: 440
            SoundSetting()
                .padding(.horizontal, 8)
                .environmentObject(appSetter)
                .tag(2)
                .tabItem {
                    Image(systemName: "waveform.circle")
                }

            // 时间表设置
            ScheduleSetting()
                .environmentObject(appTimer)
                .environmentObject(appSetter)
                .tag(3)
                .tabItem {
                    Image(systemName: "calendar.circle")
                }
            // 帮助页面
            HelpSetting()
                .tag(4)
                .padding()
                .tabItem {
                    Image(systemName: "questionmark.circle")
                }
            // 关于页面
            AboutSetting()
                .tag(5)
                .padding()
                .tabItem {
                    Image(systemName: "info.circle")
                }

        }
        .frame(width: windowProperties.width, height: windowProperties.height)
        .onChange(of: selectedTab) { _ in
            switch selectedTab {
            case 2:
                SettingsWindowController.shared.updateFrame(
                    width: 200, height: 160)
            case 3:
                SettingsWindowController.shared.updateFrame(
                    width: 240, height: 160)
            default:
                SettingsWindowController.shared.updateFrame(
                    width: 600, height: 460)
            }
        }
    }
}

#Preview {
    AppSettings()
        .environmentObject(AppTimer.shared)
        .environmentObject(AppSetter.shared)
}

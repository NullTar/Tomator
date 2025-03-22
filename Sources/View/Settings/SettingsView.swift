//
//  SettingsView.swift
//  TomatoBar
//
//  Created by NullSilck on 2025/3/13.
//

import SwiftUI

// 应用设置视图，用于配置应用的行为
struct AppSettings: View {

    @ObservedObject var appTimer = AppTimer.shared
    @ObservedObject var appSetter = AppSetter.shared

    @StateObject private var windowProperties = WindowProperties()

    var body: some View {
        TabView {
            // 首选项
            PreferenceSettingView()
                .environmentObject(appTimer)
                .environmentObject(appSetter)
                .environmentObject(windowProperties)
                .tabItem {
                    Image(systemName: "gearshape")
                }
            // 声音设置
            AppearanceSetting()
                .environmentObject(appSetter)
                .tabItem {
                    Image(systemName: "paintpalette")
                }
            // 声音设置
            SoundSetting()
                .environmentObject(appSetter)
                .tabItem {
                    Image(systemName: "waveform.circle")
                }
            // 时间表设置
            ScheduleSetting()
                .environmentObject(appSetter)
                .tabItem {
                    Image(systemName: "calendar.circle")
                }
            // 帮助页面
            HelpSetting()
                .padding()
                .tabItem {
                    Image(systemName: "questionmark.circle")
                }
            // 关于页面
            AboutSetting()
                .padding()
                .tabItem {
                    Image(systemName: "info.circle")
                }
        }.frame(width: windowProperties.windowWidth,height: windowProperties.windowHeight)
    }
}

#Preview {
    AppSettings()
        .environmentObject(AppTimer.shared)
        .environmentObject(AppSetter.shared)
}

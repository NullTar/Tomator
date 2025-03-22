//
//  TBPopoverView.swift
//
//  Created by NullSilck on 2025/3/13.
//

import SwiftUI

// 主弹出视图，包含所有设置选项和控制按钮
struct PopoverView: View {
    @ObservedObject var appTimer = AppTimer.shared
    @ObservedObject var appSetter = AppSetter.shared
    // 必须操作，不然无法更新视图
    @ObservedObject var windowProperties = MenuBarController.shared
        .windowProperties
    @State private var showAlert: Bool = false

    var body: some View {
        VStack {
            // 关于按钮
            Button("") {
                NSApp.activate(ignoringOtherApps: true)
                NSApp.orderFrontStandardAboutPanel()
            }.buttonStyle(.borderless).keyboardShortcut(
                "a", modifiers: .command
            ).frame(maxHeight: 0).labelsHidden()
            PopoverTop()
                .environmentObject(appTimer)
                .environmentObject(appSetter)
            VStack {
                TimeView()
                    .environmentObject(appTimer)
                    .environmentObject(appSetter)
                if appSetter.scheduleMenu || appSetter.stopAfterBrekeMenu
                    || appSetter.forceRestMenu
                {
                    Divider()
                }
                if appSetter.scheduleMenu {
                    ScheduleComponet()
                        .environmentObject(appTimer)
                        .environmentObject(appSetter)
                }
                QuickSettingView()
                    .environmentObject(appTimer)
                    .environmentObject(appSetter)
            }.padding(8).background(Color("CardView")).cornerRadius(8).shadow(
                color: .gray.opacity(0.5), radius: 0.4)
            // 底部按钮组
            PopoverButtom().padding(5)
        }
        .padding(16)
        .accentColor(Color(appSetter.colorSet))
        .tint(Color(appSetter.colorSet))
        .frame(height: windowProperties.height)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(NSLocalizedString("Start.Error", comment: "无法开始")),
                message: Text(appSetter.scheduleAlert),
                dismissButton: .default(Text(NSLocalizedString("Ok", comment: "确定"))){
                    appSetter.scheduleAlert = ""
                }
            )
        }
        .onChange(of: appSetter.scheduleAlert) { _ in
            if !appSetter.scheduleAlert.isEmpty {
                showAlert = true
            }
        }
        .onChange(of: appSetter.scheduleMenu) { newValue in
            freshView(newValue: newValue, quantity: 30)
        }
        .onChange(of: appSetter.shortRestMenu) { newValue in
            freshView(newValue: newValue, quantity: 30)
        }
        .onChange(of: appSetter.stopAfterBrekeMenu) { newValue in
            freshView(newValue: newValue, quantity: 30)
        }
        .onChange(of: appSetter.forceRestMenu) { newValue in
            freshView(newValue: newValue, quantity: 30)
        }
        .onChange(of: appSetter.forceRest) { newValue in
            freshView(newValue: newValue, quantity: 40)
        }
    }
    private func freshView(newValue: Bool, quantity: CGFloat) {
        MenuBarController.shared.updateEdg(
            toggle: newValue, edg: .height, quantity: quantity)
    }
}

#Preview {
    PopoverView()
}

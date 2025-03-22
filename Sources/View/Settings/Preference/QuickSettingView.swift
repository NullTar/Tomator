//
//  QuickSettingView.swift
//
//  Created by NullSilck on 2025/3/13.
//

import SwiftUI

struct QuickSettingView: View {
    @EnvironmentObject var appTimer: AppTimer
    @EnvironmentObject var appSetter: AppSetter

    var body: some View {
        VStack {

            if appSetter.stopAfterBrekeMenu {
                // 休息后停止选项
                SettingCompont(
                    toggle: $appSetter.stopAfterBreak,
                    label: NSLocalizedString(
                        "StopAfterBreak.label", comment: "休息后停止"),
                    appSetter: appSetter)
                
            }

            if appSetter.forceRestMenu {
                // 强制休息选项
                SettingCompont(
                    toggle: $appSetter.forceRest,
                    label: NSLocalizedString(
                        "ForceRest.label", comment: "强制休息"),
                    appSetter: appSetter)
                
            }
            // 强制休息警告文字
            if appSetter.forceRest {
                Text(
                    NSLocalizedString(
                        "ForceRest.screen",
                        comment: "强制休息警告")
                )
                .font(.system(size: 12))
                .foregroundColor(Color(appSetter.colorSet))
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
                
            }
        }
    }
}

func SettingCompont(toggle: Binding<Bool>, label: String, appSetter: AppSetter)
    -> some View
{
    Toggle(isOn: toggle) {
        Text(label)
            .frame(maxWidth: .infinity, alignment: .leading)
    }.toggleStyle(.switch).tint(Color(appSetter.colorSet))
}

#Preview {
    QuickSettingView()
        .environmentObject(AppTimer.shared)
        .environmentObject(AppSetter.shared)
}

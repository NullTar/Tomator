//
//  MenuSettingView.swift
//
//  Created by NullSilck on 2025/3/15.
//

import SwiftUI

struct MenuSettingView: View {

    @EnvironmentObject var appSetter: AppSetter

    var body: some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString("Window.Menu.setting", comment: "弹出窗口"))
                .fontWeight(.bold).font(.caption)
                .foregroundColor(Color.gray).padding(.leading, 8)
            VStack {
                VStack {
                    HStack {
                        Toggle(isOn: $appSetter.shortRestMenu) {
                            Text(
                                NSLocalizedString(
                                    "EnableShorRestMenu.label",
                                    comment: "小憩时间")
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }.toggleStyle(.switch).tint(Color(appSetter.colorSet))
                        InfoConponet(
                            label: NSLocalizedString(
                                "EnableShorRestMenu.info",
                                comment: "启用此选项以在弹出窗口中显示 小憩时间"))
                    }.padding(.top, 2)
                    Divider()
                    HStack {
                        Toggle(isOn: $appSetter.scheduleMenu) {
                            Text(
                                NSLocalizedString(
                                    "EnableScheduleMenu.label",
                                    comment: "时间表")
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }.toggleStyle(.switch).tint(Color(appSetter.colorSet))
                        InfoConponet(
                            label: NSLocalizedString(
                                "EnableScheduleMenu.info",
                                comment: "启用此选项以在弹出窗口中显示 时间表"))
                    }
                    Divider()
                    HStack {
                        Toggle(isOn: $appSetter.stopAfterBrekeMenu) {
                            Text(
                                NSLocalizedString(
                                    "EnableShopAfterRestMenu.label",
                                    comment: "休息后停止")
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }.toggleStyle(.switch).tint(Color(appSetter.colorSet))
                        InfoConponet(
                            label: NSLocalizedString(
                                "EnableShopAfterRestMenu.info",
                                comment: "启用此选项以在弹出窗口中显示 休息后停止"))
                    }
                    Divider()
                    HStack {
                        Toggle(isOn: $appSetter.forceRestMenu) {
                            Text(
                                NSLocalizedString(
                                    "EnableForceRestMenu.label",
                                    comment: "强制休息")
                            ).tint(Color(appSetter.colorSet)).frame(
                                maxWidth: .infinity, alignment: .leading)
                        }.toggleStyle(.switch).tint(Color(appSetter.colorSet))
                        InfoConponet(
                            label: NSLocalizedString(
                                "EnableForceRestMenu.info",
                                comment: "启用此选项以在弹出窗口中显示 强制休息"))
                    }
                }.padding(8)

            }.background(Color("CardView")).cornerRadius(8)
                .shadow(color: .gray.opacity(0.5), radius: 0.4)
        }.padding()
    }
}

#Preview {
    AppSettings()
        .environmentObject(AppTimer.shared)
        .environmentObject(AppSetter.shared)
}

//
//  ForceWindowSetting.swift
//
//  Created by NullSilck on 2025/3/15.
//

import SwiftUI

struct ForceWindowSetting: View {

    @EnvironmentObject var appSetter: AppSetter
    @State private var activeBackground = AppSetter.shared.appearance.background
    @State private var selectedImage = NSImage(
        data: AppSetter.shared.customizePic)

    var body: some View {
        VStack {
            HStack {
                Text(NSLocalizedString("Force.window.setting", comment: "强制休息"))
                    .fontWeight(.bold).frame(
                        maxWidth: .infinity, alignment: .leading
                    ).font(.caption)
                    .foregroundColor(Color.gray).padding(.leading, 8)
                InfoConponet(
                    label: NSLocalizedString(
                        "Force.window.setting.info",
                        comment: "开启强制休息后的窗口设置"))
            }.padding(.top, 8)
            VStack {
                VStack {
                    VStack {
                        switch activeBackground {
                        case .gradation:
                            appSetter.returnGradation()
                        case .desktop:
                            appSetter.returnDesktop()
                        case .customize:
                            appSetter.returnCustomize()
                                .overlay {
                                    Image(systemName: "plus.square")
                                        .resizable()
                                        .foregroundStyle(
                                            .white.opacity(
                                                selectedImage != nil ? 0.6 : 0.8
                                            )
                                        )
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80)
                                }
                        }
                    }
                    .frame(width: 320, height: 200).clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .gray.opacity(0.6), radius: 1)
                    .overlay {
                        Color.black.opacity(
                            activeBackground == .desktop
                            ? appSetter.appearance.opacity : 0
                        ).cornerRadius(8)
                            .onTapGesture {
                                if activeBackground == .customize {
                                    selectPicture()
                                }
                            }
                    }
                }.padding(.vertical)
                Picker("", selection: $activeBackground) {
                    Text(
                        NSLocalizedString(
                            "ForceWindow.Gradation", comment: "渐变")
                    ).tag(Background.gradation)
                    Text(
                        NSLocalizedString("ForceWindow.Desktop", comment: "桌面")
                    ).tag(Background.desktop)
                    Text(
                        NSLocalizedString(
                            "ForceWindow.Customize", comment: "自定义")
                    ).tag(Background.customize)
                }
                .pickerStyle(.segmented).labelsHidden()
                .onChange(of: activeBackground) { _ in
                    appSetter.appearance.background = activeBackground
                }
                HStack {
                    if appSetter.appearance.background == .desktop {
                        Slider(
                            value: $appSetter.appearance.opacity, in: 0.6...0.96,
                            step: 0.01)
                        InfoConponet(
                            label: NSLocalizedString(
                                "ForceWindowOpacity.info", comment: "不透明度只对 桌面 生效"))
                    }
                }.padding(.top, 4)
                HStack {
                    if appSetter.appearance.background == .gradation {
                        Slider(
                            value: $appSetter.appearance.blur, in: 0...20,
                            step: 1)
                        InfoConponet(
                            label: NSLocalizedString(
                                "ForceWindowBlur.info", comment: "模糊只对 渐变 生效"))
                    }
                }.padding(.top, 4)
            }
            .padding(8)
            .background(Color("CardView"))
            .cornerRadius(8)
            .shadow(color: .gray.opacity(0.5), radius: 0.4)
        }
    }

    private func selectPicture() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false

        if panel.runModal() == .OK, let url = panel.urls.first {
            if let imageData = try? Data(contentsOf: url) {
                // 将选择的更新到数据库
                appSetter.customizePic = imageData
                // 将数据库的更新到视图
                selectedImage = NSImage(data: appSetter.customizePic)
            }
        }
    }
}

#Preview {
    ForceWindowSetting()
        .environmentObject(AppSetter.shared)
}

#Preview {
    AppearanceSetting()
        .environmentObject(AppSetter.shared)
}

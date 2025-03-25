//
//  SoundsView.swift
//
//  Created by NullSilck on 2025/3/13.
//

import SwiftUI

// 声音设置视图，用于配置应用的声音效果
struct SoundSetting: View {

    @EnvironmentObject var appSetter: AppSetter
    @ObservedObject var soundPlayer = SoundPlayer.shared

    private var columns = [
        GridItem(.flexible()),
        GridItem(.fixed(140)),
    ]

    var body: some View {
        VStack{
            Text(NSLocalizedString("Sound.Feature.setting", comment: "声音"))
                .fontWeight(.bold).font(.caption)
                .foregroundColor(Color.gray)
                .padding(.leading, 8).padding(.top, 8)
            VStack {
                HStack {
                    Toggle(isOn: $appSetter.appSound) {
                        Text(
                            NSLocalizedString(
                                "AppSound.label",
                                comment: "提示音")
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }.toggleStyle(.switch).tint(appSetter.color)
                    InfoConponet(
                        label: NSLocalizedString(
                            "Sound.Feature.info",
                            comment: "开启次选项以关闭应用提示音"))
                }.padding(.horizontal, 8).padding(.top, 8)
                Divider()
                LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                    // 上弦声音设置
                    Text(
                        NSLocalizedString(
                            "Sounds.isWindupEnabled.label",
                            comment: "喂 Windup"))
                    VolumeSlider(volume: $soundPlayer.windupVolume)
                    // 叮声音设置
                    Text(
                        NSLocalizedString(
                            "Sounds.isDingEnabled.label",
                            comment: "叮 Ding"))
                    VolumeSlider(volume: $soundPlayer.dingVolume)
                    // 滴答声音设置
                    Text(
                        NSLocalizedString(
                            "Sounds.isTickingEnabled.label",
                            comment: "滴答 Ticking"))
                    VolumeSlider(volume: $soundPlayer.tickingVolume)
                }.padding(.horizontal, 8).padding(.bottom, 8)
            }.background(Color("CardView")).cornerRadius(8)
                .shadow(color: .gray.opacity(0.5), radius: 0.4)
        }
    }

    // 音量滑块组件，用于调整声音音量
    private struct VolumeSlider: View {
        @Binding var volume: Double
        var body: some View {
            Slider(value: $volume, in: 1...4,step: 0.2) {
                Text(String(format: "%.1f", volume))
            }
            .tint(Color(AppSetter.shared.appearance.color))
        }
    }
}

#Preview {
    SoundSetting()
        .environmentObject(AppSetter.shared)
}

#Preview {
    AppSettings()
        .environmentObject(AppSetter.shared)
}

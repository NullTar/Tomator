//
//  ForceRestView.swift
//
//  Created by NullSilck on 2025/3/13.
//

import SwiftUI

// 强制休息视图
struct ForceRest: View {
    @EnvironmentObject var appSetter: AppSetter
    @ObservedObject var forceRestWindowController = ForceRestWindowController
        .shared
    @State private var closeForceWindowNum = 0

    var body: some View {
        ZStack {
            // 背景
            switch appSetter.appearance.background {
            case .desktop:
                Color.black.opacity(appSetter.appearance.blur)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(true)
            case .customize:
                appSetter.returnCustomize()
                    .allowsHitTesting(true)
            case .gradation:
                appSetter.returnGradation()
                    .allowsHitTesting(true)
            case .wallpaper:
                appSetter.returnWallpaper()
                    .allowsHitTesting(true)
            }
            VStack {
                // 休息图标
                Image(systemName: "cup.and.heat.waves.fill")
                    .font(.system(size: 160))
                    .foregroundColor(.white)
                    .padding(.top, 160)
                // 休息提示文本
                Text(
                    forceRestWindowController.isLongBreak
                        ? NSLocalizedString(
                            "ForceRest.longBreak.title", comment: "是时候休息啦")
                        : NSLocalizedString(
                            "ForceRest.shortBreak.title", comment: "是时候小憩啦")
                )
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(
                    Color(appSetter.appearance.color).opacity(0.9))
                // 详细提示
                Text(
                    NSLocalizedString(
                        "ForceRest.description", comment: "劝劝你快休息吧")
                )
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                // 计时器
                Text(forceRestWindowController.timeRemaining)
                    .font(
                        .system(
                            size: 80, weight: .bold, design: .monospaced)
                    )
                    .foregroundColor(.white)
                    .padding(.top)
                // 底部提示
                Spacer()
                Text(
                    NSLocalizedString(
                        "ForceRest.cannot_skip", comment: "不能跳过强制休息")
                )
                .font(.headline)
                .foregroundColor(.white)
                if !appSetter.hidenSkipForceRest {
                    Button(
                        action: {
                            checkQuit()
                        },
                        label: {
                            Text(
                                closeForceWindowNum == 1
                                    ? NSLocalizedString(
                                        "ForceRest.quiteSure",
                                        comment: "再点一下关闭紧急窗口"
                                    )
                                    : NSLocalizedString(
                                        "ForceRest.emergency",
                                        comment: "点击跳过")
                            )
                            .foregroundColor(
                                Color(appSetter.appearance.color).opacity(
                                    0.8))
                        }
                    ).buttonStyle(BorderlessButtonStyle())
                        .padding(.bottom, 40)
                }
            }.padding()
        }
        .contentShape(Rectangle())
        // 禁用所有交互 - 但捕获点击事件
        .allowsHitTesting(true)
        // 空手势处理器捕获但不做任何操作
        .onTapGesture {}
        .onExitCommand {}
    }

    private func checkQuit() {
        closeForceWindowNum += 1
        if closeForceWindowNum == 2 {
            forceRestWindowController.closeForceRestWindow()
        }
    }
}

#Preview {
    ForceRest()
        .environmentObject(AppSetter.shared)
}

//
//
//  Created by NullSilck on 2025/3/15.
//

import SwiftUI

// 底部按钮组
struct PopoverButtom: View {
    var body: some View {
        VStack(spacing: 8) {
            // 统计按钮
            Button {
                // 显示统计窗口
                StatsWindowController.shared.showStatsWindow()
            } label: {
                iniComponet(
                    localized: NSLocalizedString(
                        "Popover.stats.label",
                        comment: "统计"), label: "⌘ S")
            }
            .buttonStyle(.plain)
            .keyboardShortcut("s", modifiers: .command)

            // 设置按钮
            Button {
                // 显示设置窗口
                SettingsWindowController.shared.showSettingWindow()
            } label: {
                iniComponet(localized: NSLocalizedString(
                    "Popover.setting.label",
                    comment:"设置"), label: "⌘ ,")
            }
            .buttonStyle(.plain)
            .keyboardShortcut(",", modifiers: .command)

            // 退出按钮
            Button {
                NSApplication.shared.terminate(self)
            } label: {
                iniComponet(
                    localized: NSLocalizedString(
                        "Popover.quit.label",
                        comment: "退出"), label: "⌘ Q")
            }
            .buttonStyle(.plain)
            .keyboardShortcut("q", modifiers: .command)
        }
    }

    private func iniComponet(localized: String, label: String) -> some View {
        return HStack {
            Text(localized)
            Spacer()
            Text(label).foregroundColor(Color.gray).monospaced()
        }
    }
}

#Preview {
    PopoverView()
        .frame(width: 380, height: 400)
}

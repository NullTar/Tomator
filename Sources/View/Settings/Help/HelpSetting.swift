//
//  HelpSettingView.swift
//
//  Created by NullSilck on 2025/3/15.
//

import SwiftUI

struct HelpSetting: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString("what.is.Pomodoro.Clock", comment: "什么是番茄时钟?"))
                .font(.title).fontWeight(.bold)
            Text(NSLocalizedString("Pomodoro.info", comment: "番茄时钟介绍"))
                .font(.title3).lineLimit(nil).padding(.bottom,8)
            Text(NSLocalizedString("MenuSetting.help", comment: "菜单显示?"))
                .font(.title).fontWeight(.bold)
            Text(NSLocalizedString("MenuSetting.help.info", comment: "菜单显示介绍"))
                .font(.title3).lineLimit(nil).padding(.bottom,8)
            Text(NSLocalizedString("Scheduletting.help", comment: "时间表帮助"))
                .font(.title).fontWeight(.bold)
            Text(NSLocalizedString("Scheduletting.help.info", comment: "时间表介绍"))
                .font(.title3).lineLimit(nil).padding(.bottom,8)
            Text(NSLocalizedString("ColorSetting.help", comment: "颜色帮助"))
                .font(.title).fontWeight(.bold)
            Text(NSLocalizedString("ColorSetting.help.info", comment: "颜色介绍"))
                .font(.title3).lineLimit(nil).padding(.bottom,8)
            Text(NSLocalizedString("ForceWindowSetting.help", comment: "强制窗口帮助"))
                .font(.title).fontWeight(.bold)
            Text(NSLocalizedString("ForceWindowSetting.help.info", comment: "强制窗口介绍"))
                .font(.title3).lineLimit(nil).padding(.bottom,8)
        }
    }
}



#Preview {
    HelpSetting()
}


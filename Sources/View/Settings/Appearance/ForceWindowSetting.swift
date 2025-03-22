//
//  ForceWindowSetting.swift
//
//  Created by NullSilck on 2025/3/15.
//

import SwiftUI

struct ForceWindowSetting: View {
    
    @EnvironmentObject var appSetter: AppSetter
    
    var body: some View {
        VStack {
            HStack{
                Text(NSLocalizedString("Force.window.setting", comment: "强制休息"))
                    .fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading).font(.caption)
                    .foregroundColor(Color.gray).padding(.leading, 8)
                InfoConponet(
                    label: NSLocalizedString(
                        "Force.window.setting.info",
                        comment: "开启强制休息后的窗口设置"))
            }.padding(.top, 8)
            HStack{
                // TODO 渐变、壁纸、自定义壁纸
                // TODO blur 渐变值
                Text("测试")
            }.frame(height: 40)
                .background(Color("CardView")).cornerRadius(8)
                .shadow(color: .gray.opacity(0.5), radius: 0.4)
        }
    }
}



#Preview {
    ForceWindowSetting()
        .environmentObject(AppSetter.shared)
}



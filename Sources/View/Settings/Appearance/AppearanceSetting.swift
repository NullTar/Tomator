//
//  AppearanceSettingView.swift
//
//  Created by NullSilck on 2025/3/15.
//
import SwiftUI

struct AppearanceSetting: View {
    
    @EnvironmentObject var appSetter: AppSetter
    
    var body: some View {
        VStack {
            ForceWindowSetting()
                .padding(.horizontal)
                .environmentObject(appSetter)
            ColorSetting()
                .padding(.horizontal)
                .environmentObject(appSetter)
            Spacer()
        }
    }
}



#Preview {
    AppearanceSetting()
        .environmentObject(AppSetter.shared)
}

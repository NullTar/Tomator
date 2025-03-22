//
//  PreferenceSetting.swift
//
//  Created by NullSilck on 2025/3/14.
//

import SwiftUI

struct PreferenceSettingView: View {
    @EnvironmentObject var appTimer: AppTimer
    @EnvironmentObject var appSetter: AppSetter

    var body: some View {
        VStack {
            FeatureSettingView()
                .environmentObject(appTimer)
                .environmentObject(appSetter)
            MenuSettingView()
                .environmentObject(appTimer)
                .environmentObject(appSetter)
            Spacer()
        }
    }  
}

#Preview {
 
    AppSettings()
        .colorScheme(.light)
        .environmentObject(AppTimer.shared)
        .environmentObject(AppSetter.shared)
}

#Preview {
    AppSettings()
        .colorScheme(.dark)
        .environmentObject(AppTimer.shared)
        .environmentObject(AppSetter.shared)
}

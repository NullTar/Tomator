//
//  AboutSettingView.swift
//
//  Created by NullSilck on 2025/3/14.
//

import SwiftUI

struct AboutSetting: View {
    var body: some View {
        VStack(spacing: 8) {
            Image("Icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text(NSLocalizedString("about.info", comment: "app 介绍"))
                .lineLimit(nil)
        }
    }
    
    
}

#Preview {
    AboutSetting()
}

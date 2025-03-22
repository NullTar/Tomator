//
//  ScheduleComponet.swift
//
//  Created by NullSilck on 2025/3/15.
//

import SwiftUI

struct ScheduleComponet: View {

    @EnvironmentObject var appTimer: AppTimer
    @EnvironmentObject var appSetter: AppSetter

    var body: some View {
        HStack {
            Text(NSLocalizedString("Schedule.label", comment: "时间表"))
            Spacer()
            Image(systemName: "chevron.forward")
                .rotationEffect(.degrees(appSetter.scheduleExpanded ? 90 : 0))
                .padding(.trailing, 4)
        }
        .onTapGesture {
            withAnimation {
                appSetter.scheduleExpanded.toggle()
            }
        }
        .onChange(of: appSetter.scheduleExpanded) { newValue in
            MenuBarController.shared.updateEdg(
                toggle: newValue, edg: .height, quantity: 120)
        }
        if appSetter.scheduleExpanded {
            ScheduleDate()
                .environmentObject(appTimer)
                .environmentObject(appSetter)
            Divider()
        }
    }
}

#Preview {
    ScheduleSetting()
        .environmentObject(AppSetter.shared)
}

#Preview {
    ScheduleDate()
        .environmentObject(AppSetter.shared)
}

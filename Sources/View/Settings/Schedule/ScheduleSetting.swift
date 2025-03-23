//
//  ScheduleSettingView.swift
//
//  Created by NullSilck on 2025/3/14.
//

import SwiftUI

struct ScheduleSetting: View {

    @EnvironmentObject var appTimer: AppTimer
    @EnvironmentObject var appSetter: AppSetter
    @ObservedObject var scheduleSetter = ScheduleSetter.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString("Schedule.Model.setting", comment: "时间表"))
                .fontWeight(.bold).font(.caption)
                .foregroundColor(Color.gray)
                .padding(.leading, 8).padding(.leading, 8).padding(.top, 8)
            VStack {
                HStack {
                    Toggle(isOn: $scheduleSetter.workSchedule) {
                        Text(
                            NSLocalizedString(
                                "ScheduleSettingView.workSchedule.label",
                                comment: "开启时间表")
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }.toggleStyle(.switch)
                    InfoConponet(
                        label: NSLocalizedString(
                            "ScheduleSettingView.workSchedule.info",
                            comment: "开启时间表模式"))
                }.padding(.horizontal, 8).padding(.top, 8)
                Divider()
                Group{
                    Text(
                        NSLocalizedString(
                            "Schedule.Model.Day.setting", comment: "周几")
                    )
                    .fontWeight(.bold).font(.caption)
                    .foregroundColor(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    ScheduleDate()
                        .environmentObject(appTimer)
                        .environmentObject(appSetter)
                }.padding(.bottom, 8).padding(.horizontal, 8)
            }.background(Color("CardView")).cornerRadius(8)
                .shadow(color: .gray.opacity(0.5), radius: 0.4)
                .padding(.horizontal, 8)
            Spacer()
        }.accentColor(Color(appSetter.appearance.color))
    }
}

#Preview {
    ScheduleSetting()
        .environmentObject(AppSetter.shared)
        .environmentObject(AppTimer.shared)
}

#Preview {
    AppSettings()
}

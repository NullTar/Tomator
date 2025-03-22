//
//  DateView.swift
//
//  Created by NullSilck on 2025/3/13.
//

import SwiftUI

struct ScheduleDate: View {
    @EnvironmentObject var appSetter: AppSetter
    @StateObject var scheduleSetter = ScheduleSetter.shared
    @State private var selectedDays: Set<Int> = []
    // 日期
    private let week = [sunday,monday,tuesday,wednesday,thursday,friday,saturday]
    var body: some View {
        VStack {
            HStack {
                ForEach(week) { day in
                    let isSelected = selectedDays.contains(day.id)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isSelected ? Color(appSetter.colorSet) : Color.gray.opacity(0.8))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text(day.value)
                                .foregroundColor(.white)
                        )
                        .onTapGesture {
                            if isSelected {
                                selectedDays.remove(day.id)
                                scheduleSetter.removeDays(id: day.id)
                            } else {
                                selectedDays.insert(day.id)
                                scheduleSetter.addDays(day: day)
                            }
                        }
                }
            }.onAppear{
                scheduleSetter.fetchDays().forEach { day in
                    selectedDays.insert(day.id)
                }
            }.padding(.bottom, 8)
            HStack {
                Text(NSLocalizedString("Day.Moring", comment: "早上"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                let morningStartRange =
                    Calendar.current.date(
                        bySettingHour: 7, minute: 0, second: 0, of: Date())!...scheduleSetter
                    .morningEnd.addingTimeInterval(-60)  // 确保不会等于或超过结束时间
                let morningEndRange =
                scheduleSetter.morningStart.addingTimeInterval(60)...Calendar
                    .current.date(
                        bySettingHour: 13, minute: 0, second: 0, of: Date())!  // 确保不会小于开始时间
                DatePicker(
                    "", selection: $scheduleSetter.morningStart,
                    in: morningStartRange, displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                Text("to")
                // 第二个时间选择器：结束时间
                DatePicker(
                    "", selection: $scheduleSetter.morningEnd, in: morningEndRange,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
            }
            HStack {
                Text(
                    NSLocalizedString(
                        "Day.Afternoon", comment: "下午")
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()

                let afternoonStartRange =
                    Calendar.current.date(
                        bySettingHour: 13, minute: 0, second: 0, of: Date())!...scheduleSetter.afternoonEnd.addingTimeInterval(-60)
                let afternoonEndRange = scheduleSetter.afternoonStart.addingTimeInterval(60)...Calendar
                    .current.date(
                        bySettingHour: 23, minute: 0, second: 0, of: Date())!
                DatePicker(
                    "", selection: $scheduleSetter.afternoonStart,
                    in: afternoonStartRange, displayedComponents: .hourAndMinute
                )
                .labelsHidden()

                Text("to")
                // 第二个时间选择器：结束时间
                DatePicker(
                    "", selection: $scheduleSetter.afternoonEnd,
                    in: afternoonEndRange, displayedComponents: .hourAndMinute
                )
                .labelsHidden()
            }
        }
    }
}

#Preview {
    ScheduleDate()
        .environmentObject(AppTimer.shared)
        .environmentObject(AppSetter.shared)
}

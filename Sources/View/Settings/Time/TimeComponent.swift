//
//  TimeComponent.swift
//
//  Created by NullSilck on 2025/3/15.
//

import SwiftUI

struct TimeComponent: View {
    
    @EnvironmentObject var appSetter: AppSetter
    
    private let minStr = NSLocalizedString("IntervalsView.min", comment: "分钟")
    
    // 文字
    var leadingText: String
    // 计时器标识
    @Binding var interval: Int
    // 工作时间的数组
    let worktimeMain = [15, 30, 45, 60]
    let workTimeOther = [10, 20, 25, 35, 40, 50, 55, 80, 100]
    // 选择的数据
    @State private var selectedValue: Int? = nil
    
    var timeType: TimeType
    var body: some View {
        HStack {
            Text(leadingText).frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            let data = switch timeType {
            case .Work:
                worktimeMain
            case .Short:
                Array(0 ... 5)
            case .Long:
                Array(10 ... 20)
            case .Add:
                Array(3 ... 15)
            }
            Menu(String.localizedStringWithFormat(minStr, interval)) {
                ForEach(data, id: \.self) { value in
                    Button(String.localizedStringWithFormat(minStr, value), action: {
                        selectedValue = value })
                }
                if timeType == TimeType.Work{
                    Divider()
                    Menu(NSLocalizedString("Other", comment: "其他")) {
                        ForEach(workTimeOther, id: \.self) { value in
                            Button(String.localizedStringWithFormat(minStr, value), action: { selectedValue = value })
                        }
                    }.foregroundColor(.red).accentColor(Color(appSetter.appearance.color)).tint(Color(appSetter.appearance.color))
                    Menu(NSLocalizedString("More", comment: "更多")) {
                        ForEach(20 ... 80, id: \.self) { value in
                            if !worktimeMain.contains(value) && !workTimeOther.contains(value) {
                                Button(String.localizedStringWithFormat(minStr, value),
                                       action: { selectedValue = value })
                            }
                        }
                    }.accentColor(Color(appSetter.appearance.color)).tint(Color(appSetter.appearance.color))
                }
            }.accentColor(Color(appSetter.appearance.color)).tint(Color(appSetter.appearance.color))
            .frame(width: 80)
            .onChange(of: selectedValue) { newValue in
                if let newValue = newValue {
                    interval = newValue
                }
            }
        }.accentColor(Color(appSetter.appearance.color)).tint(Color(appSetter.appearance.color))
    }
}


#Preview {
    TimeComponent(leadingText: "String", interval: AppTimer
        .shared.$workIntervalLength, timeType: TimeType.Work)
        .environmentObject(AppSetter.shared)
}

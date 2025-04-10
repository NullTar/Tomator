import SwiftUI

// 间隔设置视图，用于配置工作和休息的时间间隔
struct TimeView: View {

    @EnvironmentObject var appTimer: AppTimer
    @EnvironmentObject var appSetter: AppSetter

    private var minStr = NSLocalizedString("IntervalsView.min", comment: "分钟")
    private var workTimeStr = NSLocalizedString(
        "WorkIntervalLength.label",
        comment: "工作时间")
    private var shortTimeStr = NSLocalizedString(
        "ShortRestIntervalLength.label",
        comment: "小憩时间")
    private var longTimeStr = NSLocalizedString(
        "LongRestIntervalLength.label",
        comment: "休息时间")
    private var numberStr = NSLocalizedString(
        "WorkIntervalsInSet.label",
        comment: "每组中的工作间隔数量")
    private var addTimeStr = NSLocalizedString(
        "addTimeIntervalLength.label",
        comment: "添加时间")
    var body: some View {
        VStack {
            // 工作间隔时长设置,timer.workIntervalLength
            TimeComponent(
                leadingText: workTimeStr,
                interval: $appTimer.workIntervalLength, timeType: .Work)
            if appSetter.shortRestMenu {
                // 短休息间隔时长设置
                TimeComponent(
                    leadingText: shortTimeStr,
                    interval: $appTimer.shortRestIntervalLength,
                    timeType: .Short)
                if $appTimer.shortRestIntervalLength.wrappedValue == 0 {
                    Text(
                        NSLocalizedString(
                            "ShotTime.Window.label", comment: "未开启小憩")
                    )
                    .foregroundStyle(Color.gray.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.system(.footnote))
                }
            }
            // 长休息间隔时长设置
            TimeComponent(
                leadingText: longTimeStr,
                interval: $appTimer.longRestIntervalLength, timeType: .Long)
            // 每组中的工作间隔数量
            TimeComponent(
                leadingText: numberStr,
                interval: $appTimer.workIntervalsInSet, timeType: .Number)
            // 添加时间
            if appSetter.addTimeMenu, appTimer.currentState != .idle {
                TimeComponent(
                    leadingText: addTimeStr,
                    interval: $appTimer.addTimeIntervalLength, timeType: .Add
                )
            }
        }
    }
}

#Preview {
    TimeView()
        .environmentObject(AppTimer.shared)
        .environmentObject(AppSetter.shared)
}

#Preview {
    AppSettings()
        .environmentObject(AppTimer.shared)
        .environmentObject(AppSetter.shared)
}

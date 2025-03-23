import Charts
import SwiftUI

// 统计视图 - 显示番茄钟使用统计信息
@available(macOS 13.0, *)
struct StatsView: View {
    @ObservedObject private var appStatsDataViewModel = AppStatsDataViewModel
        .shared

    // 用于格式化时间的属性
    private var hourFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 16) {
            // 顶部总计统计
            HStack(spacing: 20) {
                // 总番茄钟数量
                VStack {
                    Text(
                        "\(appStatsDataViewModel.appStatsData.totalCompletedPomodoros)"
                    )
                    .font(.system(size: 24, weight: .bold))
                    Text(
                        NSLocalizedString(
                            "StatsData.totalPomodoros",
                            comment: "总番茄钟数 Total Pomodoros")
                    )
                    .font(.caption)
                    .foregroundColor(.secondary)
                }

                Divider().frame(height: 40)

                // 总工作时间
                VStack {
                    Text(
                        hourFormatter.string(
                            from: TimeInterval(
                                appStatsDataViewModel.appStatsData
                                    .totalWorkMinutes * 60)) ?? "0"
                    )
                    .font(.system(size: 24, weight: .bold))
                    Text(
                        NSLocalizedString(
                            "StatsData.totalFocusTime",
                            comment: "总专注时间 Total Focus Time")
                    )
                    .font(.caption)
                    .foregroundColor(.secondary)
                }

                Divider().frame(height: 40)

                // 连续天数
                VStack {
                    Text("\(appStatsDataViewModel.appStatsData.currentStreak)")
                        .font(.system(size: 24, weight: .bold))
                    Text(
                        NSLocalizedString(
                            "StatsData.currentStreak",
                            comment: "当前连续天数 Current Streak")
                    )
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
            .padding(.bottom, 16)

            // 今日统计
            GroupBox {
                VStack(alignment: .leading, spacing: 8) {
                    Text(NSLocalizedString("StatsData.today", comment: "今天"))
                        .font(.headline)

                    HStack {
                        VStack(alignment: .leading) {
                            Text(
                                NSLocalizedString(
                                    "StatsData.completed", comment: "已完成")
                            )
                            .font(.caption)
                            .foregroundColor(.secondary)
                            Text(
                                "\(appStatsDataViewModel.appStatsData.todayCompletedPomodoros) \(NSLocalizedString("StatsData.pomodoros", comment: "个番茄钟 pomodoros"))"
                            )
                            .font(.body)
                        }

                        Spacer()

                        VStack(alignment: .trailing) {
                            Text(
                                NSLocalizedString(
                                    "StatsData.focusTime", comment: "专注时间")
                            )
                            .font(.caption)
                            .foregroundColor(.secondary)
                            Text(
                                hourFormatter.string(
                                    from: TimeInterval(
                                        appStatsDataViewModel.appStatsData
                                            .todayWorkMinutes * 60)) ?? "0"
                            )
                            .font(.body)
                        }
                    }
                }
                .padding(8)
            }

            // 过去7天的统计图表
            GroupBox {
                VStack(alignment: .leading, spacing: 8) {
                    Text(
                        NSLocalizedString(
                            "StatsData.last7Days", comment: "过去 7 天")
                    )
                    .font(.headline)

                    Chart {
                        ForEach(
                            appStatsDataViewModel.getPomodorosForLastDays(7),
                            id: \.date
                        ) { item in
                            BarMark(
                                x: .value("Date", item.date, unit: .day),
                                y: .value("Count", item.count)
                            )
                            .foregroundStyle(Color.accentColor)
                        }
                    }
                    .frame(height: 160)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisValueLabel(
                                format: .dateTime.weekday(.abbreviated))
                        }
                    }
                }
                .padding(8)
            }

            // 休息统计
            GroupBox {
                VStack(alignment: .leading, spacing: 8) {
                    Text(NSLocalizedString("StatsData.breaks", comment: "休息"))
                        .font(.headline)

                    HStack {
                        VStack(alignment: .leading) {
                            Text(
                                NSLocalizedString(
                                    "StatsData.shortBreaks", comment: "小憩")
                            )
                            .font(.caption)
                            .foregroundColor(.secondary)
                            Text(
                                "\(appStatsDataViewModel.appStatsData.totalShortBreaks)"
                            )
                            .font(.body)
                        }

                        Spacer()

                        VStack(alignment: .trailing) {
                            Text(
                                NSLocalizedString(
                                    "StatsData.longBreaks", comment: "休息")
                            )
                            .font(.caption)
                            .foregroundColor(.secondary)
                            Text(
                                "\(appStatsDataViewModel.appStatsData.totalLongBreaks)"
                            )
                            .font(.body)
                        }
                    }
                }
                .padding(8)
            }

            // 重置统计按钮
            Button(action: {
                // 显示确认对话框
                let alert = NSAlert()
                alert.messageText = NSLocalizedString(
                    "StatsData.resetConfirmTitle", comment: "重置统计 Reset Stats")
                alert.informativeText = NSLocalizedString(
                    "StatsData.resetConfirmMessage",
                    comment: "确定要重置所有统计数据吗？此操作无法撤销。")
                alert.alertStyle = .warning
                alert.addButton(
                    withTitle: NSLocalizedString(
                        "StatsData.resetConfirm", comment: "重置"))
                alert.addButton(
                    withTitle: NSLocalizedString(
                        "StatsData.resetCancel", comment: "取消"))

                if alert.runModal() == .alertFirstButtonReturn {
                    appStatsDataViewModel.resetAllStats()
                }
            }) {
                Text(
                    NSLocalizedString(
                        "StatsData.reset", comment: "重置统计 Reset Statistics")
                )
                .foregroundColor(.red)
                .font(.title)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 8)

            Spacer(minLength: 20)
        }.padding()
    }
}

#Preview {
    StatsView()
}

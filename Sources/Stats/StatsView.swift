import SwiftUI
import Charts

// 统计视图 - 显示番茄钟使用统计信息
@available(macOS 13.0, *)
struct StatsView: View {
    @ObservedObject private var statsManager = StatsManager.shared
    
    // 用于格式化时间的属性
    private var hourFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 顶部总计统计
                HStack(spacing: 20) {
                    // 总番茄钟数量
                    VStack {
                        Text("\(statsManager.stats.totalCompletedPomodoros)")
                            .font(.system(size: 24, weight: .bold))
                        Text(NSLocalizedString("StatsView.totalPomodoros", comment: "Total Pomodoros"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider().frame(height: 40)
                    
                    // 总工作时间
                    VStack {
                        Text(hourFormatter.string(from: TimeInterval(statsManager.stats.totalWorkMinutes * 60)) ?? "0")
                            .font(.system(size: 24, weight: .bold))
                        Text(NSLocalizedString("StatsView.totalFocusTime", comment: "Total Focus Time"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider().frame(height: 40)
                    
                    // 连续天数
                    VStack {
                        Text("\(statsManager.stats.currentStreak)")
                            .font(.system(size: 24, weight: .bold))
                        Text(NSLocalizedString("StatsView.currentStreak", comment: "Current Streak"))
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
                        Text(NSLocalizedString("StatsView.today", comment: "Today"))
                            .font(.headline)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(NSLocalizedString("StatsView.completed", comment: "Completed"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(statsManager.stats.todayCompletedPomodoros) \(NSLocalizedString("StatsView.pomodoros", comment: "pomodoros"))")
                                    .font(.body)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(NSLocalizedString("StatsView.focusTime", comment: "Focus time"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(hourFormatter.string(from: TimeInterval(statsManager.stats.todayWorkMinutes * 60)) ?? "0")
                                    .font(.body)
                            }
                        }
                    }
                    .padding(8)
                }
                
                // 过去7天的统计图表
                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("StatsView.last7Days", comment: "Last 7 Days"))
                            .font(.headline)
                        
                        Chart {
                            ForEach(statsManager.getPomodorosForLastDays(7), id: \.date) { item in
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
                                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                            }
                        }
                    }
                    .padding(8)
                }
                
                // 休息统计
                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("StatsView.breaks", comment: "Breaks"))
                            .font(.headline)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(NSLocalizedString("StatsView.shortBreaks", comment: "Short breaks"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(statsManager.stats.totalShortBreaks)")
                                    .font(.body)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(NSLocalizedString("StatsView.longBreaks", comment: "Long breaks"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(statsManager.stats.totalLongBreaks)")
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
                    alert.messageText = NSLocalizedString("StatsView.resetConfirmTitle", comment: "Reset Stats")
                    alert.informativeText = NSLocalizedString("StatsView.resetConfirmMessage", comment: "Are you sure you want to reset all statistics? This cannot be undone.")
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: NSLocalizedString("StatsView.resetConfirm", comment: "Reset"))
                    alert.addButton(withTitle: NSLocalizedString("StatsView.resetCancel", comment: "Cancel"))
                    
                    if alert.runModal() == .alertFirstButtonReturn {
                        statsManager.resetAllStats()
                    }
                }) {
                    Text(NSLocalizedString("StatsView.reset", comment: "Reset Statistics"))
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 8)
                
                Spacer(minLength: 20)
            }
            .padding()
        }
        // .frame(minWidth: 320, minHeight: 600)
    }
} 
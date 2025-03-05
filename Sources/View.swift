import SwiftUI

// 间隔设置视图，用于配置工作和休息的时间间隔
private struct IntervalsView: View {
    @EnvironmentObject var timer: TBTimer
    private var minStr = NSLocalizedString("IntervalsView.min", comment: "min")

    var body: some View {
        VStack {
            // 工作间隔时长设置
            Stepper(value: $timer.workIntervalLength, in: 1 ... 60) {
                HStack {
                    Text(NSLocalizedString("IntervalsView.workIntervalLength.label",
                                           comment: "Work interval label"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(String.localizedStringWithFormat(minStr, timer.workIntervalLength))
                }
            }
            // 短休息间隔时长设置
            Stepper(value: $timer.shortRestIntervalLength, in: 1 ... 60) {
                HStack {
                    Text(NSLocalizedString("IntervalsView.shortRestIntervalLength.label",
                                           comment: "Short rest interval label"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(String.localizedStringWithFormat(minStr, timer.shortRestIntervalLength))
                }
            }
            // 长休息间隔时长设置
            Stepper(value: $timer.longRestIntervalLength, in: 1 ... 60) {
                HStack {
                    Text(NSLocalizedString("IntervalsView.longRestIntervalLength.label",
                                           comment: "Long rest interval label"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(String.localizedStringWithFormat(minStr, timer.longRestIntervalLength))
                }
            }
            .help(NSLocalizedString("IntervalsView.longRestIntervalLength.help",
                                    comment: "Long rest interval hint"))
            // 每组中的工作间隔数量设置
            Stepper(value: $timer.workIntervalsInSet, in: 1 ... 10) {
                HStack {
                    Text(NSLocalizedString("IntervalsView.workIntervalsInSet.label",
                                           comment: "Work intervals in a set label"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(timer.workIntervalsInSet)")
                }
            }
            .help(NSLocalizedString("IntervalsView.workIntervalsInSet.help",
                                    comment: "Work intervals in set hint"))
            Spacer().frame(height: 28)  // 保持一个最小高度
            Spacer().frame(minHeight: 0)
        }
        .padding(4)
    }
}

// 应用设置视图，用于配置应用的行为
private struct SettingsView: View {
    @EnvironmentObject var timer: TBTimer

    var body: some View {
        VStack {
            // 休息后停止选项
            Toggle(isOn: $timer.stopAfterBreak) {
                Text(NSLocalizedString("SettingsView.stopAfterBreak.label",
                                       comment: "Stop after break label"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.toggleStyle(.switch)
            // 在菜单栏显示计时器选项
            Toggle(isOn: $timer.showTimerInMenuBar) {
                Text(NSLocalizedString("SettingsView.showTimerInMenuBar.label",
                                       comment: "Show timer in menu bar label"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.toggleStyle(.switch)
                .onChange(of: timer.showTimerInMenuBar) { _ in
                    timer.updateTimeLeft()
                }
            // 开机启动选项
            Toggle(isOn: $timer.launchAtLogin) {
                Text(NSLocalizedString("SettingsView.launchAtLogin.label",
                                       comment: "Launch at login label"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.toggleStyle(.switch)
                .onChange(of: timer.launchAtLogin) { newValue in
                    timer.setLaunchAtLogin(newValue)
                }
            // 强制休息选项
            Toggle(isOn: $timer.forceRest) {
                Text(NSLocalizedString("SettingsView.forceRest.label",
                                      comment: "Force rest label"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.toggleStyle(.switch)
            
            // 强制休息警告文字
            if timer.forceRest {
                Text(NSLocalizedString("SettingsView.forceRest.help",
                                      comment: "Force rest warning"))
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 2)
                    .padding(.bottom, 4)
            }
            
            Spacer()
        }
        .padding(4)
    }
}

// 音量滑块组件，用于调整声音音量
private struct VolumeSlider: View {
    @Binding var volume: Double

    var body: some View {
        Slider(value: $volume, in: 0...2) {
            Text(String(format: "%.1f", volume))
        }.gesture(TapGesture(count: 2).onEnded({
            volume = 1.0
        }))
    }
}

// 声音设置视图，用于配置应用的声音效果
private struct SoundsView: View {
    @EnvironmentObject var player: TBPlayer

    private var columns = [
        GridItem(.flexible()),
        GridItem(.fixed(110))
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 4) {
            // 上弦声音设置
            Text(NSLocalizedString("SoundsView.isWindupEnabled.label",
                                   comment: "Windup label"))
            VolumeSlider(volume: $player.windupVolume)
            // 叮声音设置
            Text(NSLocalizedString("SoundsView.isDingEnabled.label",
                                   comment: "Ding label"))
            VolumeSlider(volume: $player.dingVolume)
            // 滴答声音设置
            Text(NSLocalizedString("SoundsView.isTickingEnabled.label",
                                   comment: "Ticking label"))
            VolumeSlider(volume: $player.tickingVolume)
        }.padding(4)
        Spacer()
    }
}

// 子视图枚举，用于标识当前显示的设置页面
private enum ChildView {
    case intervals, settings, sounds
}

// 主弹出视图，包含所有设置选项和控制按钮
struct TBPopoverView: View {
    @ObservedObject var timer = TBTimer()
    @State private var buttonHovered = false
    @State private var activeChildView = ChildView.intervals

    private var startLabel = NSLocalizedString("TBPopoverView.start.label", comment: "Start label")
    private var stopLabel = NSLocalizedString("TBPopoverView.stop.label", comment: "Stop label")
    
    // 定义状态显示文本
    private var statusText: some View {
        let status: String
        let color: Color
        
        if timer.timer == nil {
            status = NSLocalizedString("TBPopoverView.status.ready", comment: "Ready status")
            color = .secondary
        } else {
            switch timer.currentState {
            case .work:
                // 添加当前工作次数/总工作次数的信息 (n/total)
                let currentCount = timer.consecutiveWorkIntervals + 1 // +1 因为是当前正在进行的
                let totalCount = timer.workIntervalsInSet
                status = "\(NSLocalizedString("TBPopoverView.status.working", comment: "Working status")) (\(currentCount)/\(totalCount))"
                color = .green
            case .rest:
                if timer.isLongRest {
                    status = NSLocalizedString("TBPopoverView.status.longRest", comment: "Long rest status")
                } else {
                    status = NSLocalizedString("TBPopoverView.status.shortRest", comment: "Short rest status")
                }
                color = .blue
            default:
                status = NSLocalizedString("TBPopoverView.status.ready", comment: "Ready status")
                color = .secondary
            }
        }
        
        return Text(status)
            .foregroundColor(color)
            .font(.system(size: 14, weight: .medium))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 状态指示器
            HStack {
                Spacer()
                statusText
                    .padding(.vertical, 4)
                Spacer()
            }
            
            // 开始/停止按钮
            Button {
                timer.startStop()
                TBStatusItem.shared.closePopover(nil)
            } label: {
                HStack {
                    Image(systemName: timer.timer != nil ? "pause.fill" : "play.fill")
                    Text(timer.timer != nil ?
                         (buttonHovered ? stopLabel : timer.timeLeftString) :
                            startLabel)
                        /*
                          当外观设置为"暗色"且强调色设置为"石墨"时，
                          "defaultAction"按钮标签的颜色与按钮颜色相同，
                          使按钮看起来是空白的。#24
                         */
                        .foregroundColor(Color.white)
                        .font(.system(.body).monospacedDigit())
                }
                .frame(maxWidth: .infinity)
            }
            .onHover { over in
                buttonHovered = over
            }
            .controlSize(.large)
            .keyboardShortcut(.defaultAction)

            // 设置页面选择器
            Picker("", selection: $activeChildView) {
                Text(NSLocalizedString("TBPopoverView.intervals.label",
                                       comment: "Intervals label")).tag(ChildView.intervals)
                Text(NSLocalizedString("TBPopoverView.settings.label",
                                       comment: "Settings label")).tag(ChildView.settings)
                Text(NSLocalizedString("TBPopoverView.sounds.label",
                                       comment: "Sounds label")).tag(ChildView.sounds)
            }
            .labelsHidden()
            .frame(maxWidth: .infinity)
            .pickerStyle(.segmented)

            // 设置内容区域
            GroupBox {
                switch activeChildView {
                case .intervals:
                    IntervalsView().environmentObject(timer)
                case .settings:
                    SettingsView().environmentObject(timer)
                case .sounds:
                    SoundsView().environmentObject(timer.player)
                }
            }

            // 底部按钮组
            Group {
                // 统计按钮
                Button {
                    // 显示统计窗口
                    StatsWindowController.shared.showStatsWindow()
                    // 关闭弹出窗口
                    TBStatusItem.shared.closePopover(nil)
                } label: {
                    Text(NSLocalizedString("TBPopoverView.stats.label",
                                          comment: "Statistics label"))
                    Spacer()
                    Text("⌘ S").foregroundColor(Color.gray)
                }
                .buttonStyle(.plain)
                .keyboardShortcut("s")
                
                // 关于按钮
                Button {
                    NSApp.activate(ignoringOtherApps: true)
                    NSApp.orderFrontStandardAboutPanel()
                } label: {
                    Text(NSLocalizedString("TBPopoverView.about.label",
                                           comment: "About label"))
                    Spacer()
                    Text("⌘ A").foregroundColor(Color.gray)
                }
                .buttonStyle(.plain)
                .keyboardShortcut("a")
                // 退出按钮
                Button {
                    NSApplication.shared.terminate(self)
                } label: {
                    Text(NSLocalizedString("TBPopoverView.quit.label",
                                           comment: "Quit label"))
                    Spacer()
                    Text("⌘ Q").foregroundColor(Color.gray)
                }
                .buttonStyle(.plain)
                .keyboardShortcut("q")
            }
        }
        #if DEBUG
            /*
             经过几个小时的搜索和尝试各种StackOverflow上的方案，
             我仍然没有找到一种可靠的方法来自动调整弹出窗口的大小以适应其所有内容
             （欢迎提交拉取请求！）。
             以下代码块用于确定弹出窗口的最佳几何形状。
             */
            .overlay(
                GeometryReader { proxy in
                    debugSize(proxy: proxy)
                }
            )
        #endif
            /* 使用GeometryReader中的值 */
//            .frame(width: 240, height: 276)
            .padding(12)
    }
}

#if DEBUG
    // 调试函数，用于打印最佳弹出窗口大小
    func debugSize(proxy: GeometryProxy) -> some View {
        print("Optimal popover size:", proxy.size)
        return Color.clear
    }
#endif

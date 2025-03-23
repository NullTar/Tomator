import ServiceManagement
import SwiftUI

class AppTimer: ObservableObject {

    // 单例实例
    static let shared = AppTimer()

    // TODO 监听键盘 如果长时间不操作就 pause

    // TODO 播放视频、打电话和视频电话的时候 pause

    @ObservedObject private var appSetter = AppSetter.shared

    ///////////////////////////////// Config /////////////////////////////////
    // 工作间隔长度（分钟）
    @AppStorage("workIntervalLength") var workIntervalLength = 45
    // 短休息间隔长度（分钟）
    @AppStorage("shortRestIntervalLength") var shortRestIntervalLength = 0
    // 长休息间隔长度（分钟）
    @AppStorage("longRestIntervalLength") var longRestIntervalLength = 10
    // 添加的时间（分钟）
    @AppStorage("addTimeIntervalLength") var addTimeIntervalLength = 0 {
        didSet { addTime() }
    }
    // 连续工作计数
    @Published public private(set) var consecutiveWorkIntervals = 0
    // 超时限制（秒）
    @AppStorage("overrunTimeLimit") var overrunTimeLimit = -60.0

    // 工作开始时间 用于记录统计
    private var workStartTime: Date?
    // 计时结束时间
    @Published private(set) var finishTime: Date!
    // 剩余时间字符串 用于显示在菜单栏的
    @Published var timeLeftString: String?

    ///////////////////////////////// Manager /////////////////////////////////
    // 状态机，初始状态为空闲
    private var stateMachine = StateMachine(state: .idle)
    // 计时器
    @Published var timer: DispatchSourceTimer?
    // 时间格式化器
    private var timerFormatter = DateComponentsFormatter()
    private let dateFormatter = DateFormatter()

    // 公共方法：获取当前状态
    public var currentState: StateMachineStates {
        return stateMachine.state
    }

    // 公共方法：判断是否是长休息
    public var isLongRest: Bool {
        return stateMachine.state == .rest
    }

    private init() {

        // 设置状态转换处理器
        stateMachine.add_anyToWork(handler: onWorkStart)  // 任何状态到工作状态
        stateMachine.add_workToRest(handler: onWorkFinish)  // 工作状态到休息状态
        stateMachine.add_workToAny(handler: onWorkEnd)  // 工作状态到任何状态
        stateMachine.add_anyToRest(handler: onRestStart)  // 任何状态到休息状态
        stateMachine.add_restToWork(handler: onRestFinish)  // 休息状态到工作状态
        stateMachine.add_anyToIdle(handler: onIdleStart)  // 任何状态到空闲状态

        // 记录所有状态转换
        stateMachine.add_anyToAny(handler: {
            let fromState = self.stateMachine.state
            let toState = self.stateMachine.state
            let event = LogEventTransition(
                from: String(describing: fromState),
                to: String(describing: toState))
            logger.append(event: event)
        })

        // 配置时间格式化器
        timerFormatter.unitsStyle = .positional
        timerFormatter.allowedUnits = [.minute, .second]
        timerFormatter.zeroFormattingBehavior = .pad

        // 设置通知动作处理器
        appSetter.notifier.setActionHandler(handler: onNotificationAction)
    }

    // 开始/停止计时器
    func startStop() {
        if checkScheduleSetting() {
            _ = stateMachine.tryEvent(.startStop)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                MenuBarController.shared.closePopover(nil)
            }
        }
    }

    // 跳过休息
    private func skipRest() {
        // 如果启用了强制休息，不允许跳过
        if !appSetter.forceRest {
            _ = stateMachine.tryEvent(.skipRest)
        }
    }

    // 更新剩余时间显示
    func updateTimeLeft() {
        if finishTime == nil {
            // 强制初始化
            finishTime = Date().addingTimeInterval(TimeInterval(workIntervalLength * 60))
        }
        timeLeftString = timerFormatter.string(from: Date(), to: finishTime)!
        // 更新状态栏时间
        if timer != nil, appSetter.showTimerInMenuBar {
            MenuBarController.shared.setTitle(title: timeLeftString)
        } else {
            appSetter.checkCountdownDiplayMenu()
        }
        // 更新强制休息窗口时间（如果正在显示）
        if appSetter.forceRest && stateMachine.state == .rest {
            appSetter.forceRestWindowController.updateTimeRemaining(
                timeLeftString ?? "")
        }
    }

    // 启用计时器
    private func startTimer(seconds: Int) {
        // 初始化
        let queue = DispatchQueue(label: "Timer")
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        }
        // 更新数据
        finishTime = Date().addingTimeInterval(TimeInterval(seconds))
        // 配置
        timer!.schedule(
            deadline: .now(), repeating: .seconds(1), leeway: .never)
        timer!.setEventHandler(handler: onTimerTick)
        timer!.setCancelHandler(handler: onTimerCancel)
        timer!.resume()
    }

    // 暂停
    func pauseTimer() {
        timer?.suspend()
    }

    // 计时器滴答事件处理
    private func onTimerTick() {
        /* 无法从后台线程发布更新 */
        DispatchQueue.main.async { [self] in
            updateTimeLeft()
            let timeLeft = finishTime.timeIntervalSince(Date())
            if timeLeft <= 0 {
                /*
                 机器休眠期间可能会错过滴答声。
                 如果超过超时限制，则停止计时器。
                 */
                if timeLeft < overrunTimeLimit {
                    _ = stateMachine.tryEvent(.startStop)
                } else {
                    _ = stateMachine.tryEvent(.timerFired) {
                        self.appSetter.stopAfterBreak
                    }
                }
            }
        }
    }

    // 添加时间
    private func addTime() {
        DispatchQueue.main.async { [self] in
            print("addTimeStart \(addTimeIntervalLength)")
            print("finishTime \(String(describing: finishTime))")
            if addTimeIntervalLength != 0 {
                finishTime += TimeInterval(addTimeIntervalLength * 60)
                addTimeIntervalLength = 0
            }
            print("finishTime \(String(describing: finishTime))")
            print("addTimeEnd \(addTimeIntervalLength)")
        }
    }

    // 计时器取消事件处理
    private func onTimerCancel() {
        DispatchQueue.main.async { [self] in
            updateTimeLeft()
        }
    }

    // 通知动作处理
    private func onNotificationAction(action: AppNotification.Action) {
        if action == .skipRest && !appSetter.forceRest
            && stateMachine.state == .rest
        {
            skipRest()
        }
    }

    // 工作开始处理
    private func onWorkStart() {
        MenuBarController.shared.setIcon(name: .work)
        appSetter.player.playWindup()
        appSetter.player.startTicking()
        startTimer(seconds: workIntervalLength * 60)
        // 记录工作开始时间，用于统计
        workStartTime = Date()
    }

    // 工作完成处理
    private func onWorkFinish() {
        consecutiveWorkIntervals += 1
        appSetter.player.playDing()

        // 计算并记录已完成的工作时间
        if let startTime = workStartTime {
            let workDuration = Date().timeIntervalSince(startTime)
            let workMinutes = Int(workDuration / 60)
            appSetter.statsManager.recordCompletedPomodoro(
                workMinutes: workMinutes)
            workStartTime = nil
        }
    }

    // 工作结束处理
    private func onWorkEnd() {
        appSetter.player.stopTicking()
        workStartTime = nil
    }

    // 休息开始处理
    private func onRestStart() {
        var body: String
        var length: Int
        var imgName: NSImage.Name

        if shortRestIntervalLength > 0 {
            body = NSLocalizedString(
                "Timer.onRestStart.short.body", comment: "小憩时间到")
            length = shortRestIntervalLength
            imgName = NSImage.Name.shortRest
            appSetter.statsManager.recordBreak(value: .Short)
        } else {
            body = NSLocalizedString(
                "Timer.onRestStart.long.body", comment: "休息时间到")
            length = longRestIntervalLength
            imgName = .longRest
            appSetter.statsManager.recordBreak(value: .Long)
        }
        // 设置图标
        MenuBarController.shared.setIcon(name: imgName)

        // 根据是否强制休息显示不同的通知
        if appSetter.forceRest {
            appSetter.notifier.postNotification(
                title: NSLocalizedString(
                    "Timer.onRestStart.title", comment: "时间到 Time's up"),
                body: body)

            // 显示强制休息全屏窗口
            DispatchQueue.main.async { [self] in
                let initialTime = timerFormatter.string(
                    from: TimeInterval(length * 60))!
                appSetter.forceRestWindowController.showForceRestWindow(
                    timeRemaining: initialTime, isLongBreak: isLongRest)
            }
        } else {
            appSetter.notifier.postNotification(
                title: NSLocalizedString(
                    "Timer.onRestStart.title", comment: "时间到 Time's up"),
                body: body,
                skipButton: NSLocalizedString(
                    "Timer.onRestStart.skip.title", comment: "跳过"))
        }
        startTimer(seconds: length * 60)
    }

    // 休息完成处理
    private func onRestFinish() {
        // 关闭强制休息窗口
        if appSetter.forceRest {
            DispatchQueue.main.async {
                self.appSetter.forceRestWindowController.closeForceRestWindow()
            }
        }

        appSetter.notifier.postNotification(
            title: NSLocalizedString(
                "TBTimer.onRestFinish.title", comment: "Rest finished title"),
            body: NSLocalizedString(
                "TBTimer.onRestFinish.body", comment: "Rest finished body"))
    }

    // 空闲状态开始处理
    private func onIdleStart() {
        if timer != nil {
            timer!.cancel()
            timer = nil
        }
        // 关闭强制休息窗口
        if appSetter.forceRest {
            DispatchQueue.main.async {
                self.appSetter.forceRestWindowController.closeForceRestWindow()
            }
        }
        MenuBarController.shared.setIcon(name: .idle)
    }

    // 检查日期
    private func checkScheduleSetting() -> Bool {
        if ScheduleSetter.shared.workSchedule {
            // 获取今天的星期
            let calendar = Calendar.current
            // 获取今天是星期几 1表示星期日 以此类推
            let weekdayIndex = calendar.component(.weekday, from: Date())
            if ScheduleSetter.shared.fetchDays().contains(where: {
                $0.id == weekdayIndex
            }) {
                dateFormatter.dateFormat = "HH:mm"
                dateFormatter.timeZone = TimeZone.current
                let currentDate = dateFormatter.string(from: Date())
                let morningS = dateFormatter.string(
                    from: ScheduleSetter.shared.morningStart)
                let morningE = dateFormatter.string(
                    from: ScheduleSetter.shared.morningEnd)
                let afternoonS = dateFormatter.string(
                    from: ScheduleSetter.shared.afternoonStart)
                let afternoonE = dateFormatter.string(
                    from: ScheduleSetter.shared.afternoonEnd)
                if (currentDate >= morningS && currentDate <= morningE)
                    || (currentDate >= afternoonS && currentDate <= afternoonE)
                {
                    return true
                } else {
                    appSetter.scheduleAlert = NSLocalizedString(
                        "Schedule.Alert.Time", comment: "请检查时间表的时间")
                    return false
                }
            } else {
                appSetter.scheduleAlert = NSLocalizedString(
                    "Schedule.Alert.Day", comment: "请检查时间表的星期")
                return false
            }
        } else {
            return true
        }
    }

}

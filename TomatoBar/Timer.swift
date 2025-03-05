import SwiftUI

class TBTimer: ObservableObject {
    @AppStorage("stopAfterBreak") var stopAfterBreak = false
    @AppStorage("showTimerInMenuBar") var showTimerInMenuBar = true
    @AppStorage("workIntervalLength") var workIntervalLength = 25
    @AppStorage("shortRestIntervalLength") var shortRestIntervalLength = 5
    @AppStorage("longRestIntervalLength") var longRestIntervalLength = 15
    @AppStorage("workIntervalsInSet") var workIntervalsInSet = 4
    @AppStorage("forceRest") var forceRest = true
    // This preference is "hidden"
    @AppStorage("overrunTimeLimit") var overrunTimeLimit = -60.0

    private var stateMachine = TBStateMachine(state: .idle)
    public let player = TBPlayer()
    private var consecutiveWorkIntervals: Int = 0
    private var notificationCenter = TBNotificationCenter()
    private var finishTime: Date!
    private var timerFormatter = DateComponentsFormatter()
    @Published var timeLeftString: String = ""
    @Published var timer: DispatchSourceTimer?

    init() {
        /*
         * State diagram
         *
         *                 start/stop
         *       +--------------+-------------+
         *       |              |             |
         *       |  start/stop  |  timerFired |
         *       V    |         |    |        |
         * +--------+ |  +--------+  | +--------+
         * | idle   |--->| work   |--->| rest   |
         * +--------+    +--------+    +--------+
         *   A                  A        |    |
         *   |                  |        |    |
         *   |                  +--------+    |
         *   |  timerFired (!stopAfterBreak)  |
         *   |             skipRest           |
         *   |                                |
         *   +--------------------------------+
         *      timerFired (stopAfterBreak)
         *
         */
        
        // 设置状态转换处理器
        stateMachine.add_anyToWork(handler: onWorkStart)
        stateMachine.add_workToRest(handler: onWorkFinish)
        stateMachine.add_workToAny(handler: onWorkEnd)
        stateMachine.add_anyToRest(handler: onRestStart)
        stateMachine.add_restToWork(handler: onRestFinish)
        stateMachine.add_anyToIdle(handler: onIdleStart)
        stateMachine.add_anyToAny(handler: {
            let fromState = self.stateMachine.state
            let toState = self.stateMachine.state
            let timestamp = Date()
            let event = ["type": "transition", 
                         "from": String(describing: fromState), 
                         "to": String(describing: toState), 
                         "timestamp": timestamp] as [String : Any]
//            logger.append(event: event)
        })

        timerFormatter.unitsStyle = .positional
        timerFormatter.allowedUnits = [.minute, .second]
        timerFormatter.zeroFormattingBehavior = .pad

        notificationCenter.setActionHandler(handler: onNotificationAction)

        let aem: NSAppleEventManager = NSAppleEventManager.shared()
        aem.setEventHandler(self,
                            andSelector: #selector(handleGetURLEvent(_:withReplyEvent:)),
                            forEventClass: AEEventClass(kInternetEventClass),
                            andEventID: AEEventID(kAEGetURL))
    }

    @objc func handleGetURLEvent(_ event: NSAppleEventDescriptor,
                                 withReplyEvent: NSAppleEventDescriptor) {
        guard let urlString = event.forKeyword(AEKeyword(keyDirectObject))?.stringValue else {
            print("url handling error: cannot get url")
            return
        }
        let url = URL(string: urlString)
        guard url != nil,
              let scheme = url!.scheme,
              let host = url!.host else {
            print("url handling error: cannot parse url")
            return
        }
        guard scheme.caseInsensitiveCompare("tomatobar") == .orderedSame else {
            print("url handling error: unknown scheme \(scheme)")
            return
        }
        switch host.lowercased() {
        case "startstop":
            startStop()
        default:
            print("url handling error: unknown command \(host)")
            return
        }
    }

    func startStop() {
        _ = stateMachine.tryEvent(.startStop)
    }

    func skipRest() {
        if !forceRest {
            _ = stateMachine.tryEvent(.skipRest)
        }
    }

    func updateTimeLeft() {
        timeLeftString = timerFormatter.string(from: Date(), to: finishTime)!
        if timer != nil, showTimerInMenuBar {
            TBStatusItem.shared.setTitle(title: timeLeftString)
        } else {
            TBStatusItem.shared.setTitle(title: nil)
        }
    }

    private func startTimer(seconds: Int) {
        finishTime = Date().addingTimeInterval(TimeInterval(seconds))

        let queue = DispatchQueue(label: "Timer")
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(1), leeway: .never)
        timer!.setEventHandler(handler: onTimerTick)
        timer!.setCancelHandler(handler: onTimerCancel)
        timer!.resume()
    }

    private func stopTimer() {
        timer!.cancel()
        timer = nil
    }

    private func onTimerTick() {
        /* Cannot publish updates from background thread */
        DispatchQueue.main.async { [self] in
            updateTimeLeft()
            let timeLeft = finishTime.timeIntervalSince(Date())
            if timeLeft <= 0 {
                /*
                 Ticks can be missed during the machine sleep.
                 Stop the timer if it goes beyond an overrun time limit.
                 */
                if timeLeft < overrunTimeLimit {
                    _ = stateMachine.tryEvent(.startStop)
                } else {
                    _ = stateMachine.tryEvent(.timerFired) { self.stopAfterBreak }
                }
            }
        }
    }

    private func onTimerCancel() {
        DispatchQueue.main.async { [self] in
            updateTimeLeft()
        }
    }

    private func onNotificationAction(action: TBNotification.Action) {
        if action == .skipRest && !forceRest && stateMachine.state == .rest {
            skipRest()
        }
    }

    private func onWorkStart() {
        TBStatusItem.shared.setIcon(name: .work)
        player.playWindup()
        player.startTicking()
        startTimer(seconds: workIntervalLength * 60)
    }

    private func onWorkFinish() {
        consecutiveWorkIntervals += 1
        player.playDing()
    }

    private func onWorkEnd() {
        player.stopTicking()
    }

    private func onRestStart() {
        var body = NSLocalizedString("TBTimer.onRestStart.short.body", comment: "Short break body")
        var length = shortRestIntervalLength
        var imgName = NSImage.Name.shortRest
        if consecutiveWorkIntervals >= workIntervalsInSet {
            body = NSLocalizedString("TBTimer.onRestStart.long.body", comment: "Long break body")
            length = longRestIntervalLength
            imgName = .longRest
            consecutiveWorkIntervals = 0
        }
        TBStatusItem.shared.setIcon(name: imgName)
        
        if forceRest {
            notificationCenter.postNotification(
                title: NSLocalizedString("TBTimer.onRestStart.title", comment: "Rest title"),
                body: body)
        } else {
            notificationCenter.postNotification(
                title: NSLocalizedString("TBTimer.onRestStart.title", comment: "Rest title"),
                body: body,
                skipButton: NSLocalizedString("TBTimer.onRestStart.skip.title", comment: "Skip button"))
        }
        
        startTimer(seconds: length * 60)
    }

    private func onRestFinish() {
        notificationCenter.postNotification(
            title: NSLocalizedString("TBTimer.onRestFinish.title", comment: "Rest finished title"),
            body: NSLocalizedString("TBTimer.onRestFinish.body", comment: "Rest finished body"))
    }

    private func onIdleStart() {
        if timer != nil {
            stopTimer()
        }
        TBStatusItem.shared.setIcon(name: .idle)
    }
}

import UserNotifications

typealias TBNotificationHandler = (AppNotification.Action) -> Void

class AppNotificationCenter: NSObject, UNUserNotificationCenterDelegate {

    private var center = UNUserNotificationCenter.current()
    private var handler: TBNotificationHandler?

    override init() {
        super.init()
        center.requestAuthorization( options: [.alert] ) { _, error in
            if error != nil {
                print("Error requesting notification authorization: \(error!)")
            }
        }

        center.delegate = self

        let actionSkipRest = UNNotificationAction(
            identifier: AppNotification.Action.skipRest.rawValue,
            title: NSLocalizedString(
                "Timer.onRestStart.skip.title", comment: "跳过"),
            options: []
        )
        let restStartedCategory = UNNotificationCategory(
            identifier: AppNotification.Category.restStarted.rawValue,
            actions: [actionSkipRest],
            intentIdentifiers: []
        )
        let restFinishedCategory = UNNotificationCategory(
            identifier: AppNotification.Category.restFinished.rawValue,
            actions: [],
            intentIdentifiers: []
        )

        center.setNotificationCategories([
            restStartedCategory,
            restFinishedCategory,
        ])
    }

    func setActionHandler(handler: @escaping TBNotificationHandler) {
        self.handler = handler
    }

    internal func userNotificationCenter(
        _: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler _: @escaping () -> Void
    ) {
        if handler != nil {
            if let action = AppNotification.Action(
                rawValue: response.actionIdentifier)
            {
                handler!(action)
            }
        }
    }

    private func send(
        title: String, body: String, category: AppNotification.Category
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = category.rawValue
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        center.add(request) { error in
            if error != nil {
                print("Error adding notification: \(error!)")
            } else {
                logger.append(
                    event: NotificationLog(
                        title: title, body: body, category: category.rawValue))
            }
        }
    }

    func postNotification(
        title: String, body: String, skipButton: String? = nil
    ) {
        let category: AppNotification.Category =
            skipButton != nil ? .restStarted : .restFinished
        if AppSetter.shared.notification{
            send(title: title, body: body, category: category)
        }
    }
    
}

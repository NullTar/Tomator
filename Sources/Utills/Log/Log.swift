//
//  Log.swift
//
//  Created by NullSilck on 2025/3/15.
//
import Foundation
import UserNotifications

class LogEventTransition: LogEventProtocol {
    internal let type = "transition"
    internal let timestamp: Date = Date()
    let from: String
    let to: String
    init(from: String, to: String) {
        self.from = from
        self.to = to
    }
    var verboseMessage: String {
        return "Transition from \(from) to \(to) at \(timestamp)"
    }
}

class AppStart: LogEventProtocol {
    internal let type = "AppStart"
    internal let timestamp: Date = Date()
    var verboseMessage: String {
        return "App Start at \(timestamp)"
    }
}

class SetLaunch: LogEventProtocol {
    internal let type = "SetLaunch"
    internal let timestamp: Date = Date()
    let value: Bool
    init(value: Bool) {
        self.value = value
    }
    var verboseMessage: String {
        return "Set Launch Time \(value) at \(timestamp)"
    }

}

class NotificationLog: LogEventProtocol {
    internal let type = "Notifications"
    internal let timestamp: Date = Date()
    let title: String
    let body: String
    let category: String
    init(title: String, body: String, category: String) {
        self.title = title
        self.body = body
        self.category = category
    }
    var verboseMessage: String {
        return
            "Send Notification: Title \(title) message: \(body) category: \(category) at \(timestamp)"
    }

}

class Init: LogEventProtocol {
    internal let type = "init"
    internal let timestamp: Date = Date()
    let object: String

    init(object: String) {
        self.object = object
    }
    var verboseMessage: String {
        return "Successful Initialization: object \(object) at \(timestamp)"
    }

}

class Append: LogEventProtocol {
    internal var type = ""
    internal let timestamp: Date = Date()
    let value: String
    init(type: LogType, value: String) {
        self.type = type.rawValue
        self.value = value
    }
    var verboseMessage: String {
        return "\(type): \(value)"
    }

}

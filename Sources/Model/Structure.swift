//
//  Enum.swift
//
//  Created by NullSilck on 2025/3/13.
//

import AppKit
import SwiftUICore

// 状态栏图标
extension NSImage.Name {
    static let idle = Self("BarIconIdle")  // 空闲状态图标
    static let work = Self("BarIconWork")  // 工作状态图标
    static let shortRest = Self("BarIconShortRest")  // 短休息状态图标
    static let longRest = Self("BarIconLongRest")  // 长休息状态图标
}

// 时间类型
enum TimeType {
    case Work, Short, Long, Add
}

// Log Protocol
protocol LogEventProtocol: Encodable {
    var type: String { get }
    var timestamp: Date { get }
    var verboseMessage: String { get }
}

enum LogType: String {
    case debug = "debug"
    case warn = "warn"
    case info = "info"
    case error = "error"
}

// Log verboseMessage 默认
extension LogEventProtocol {
    var verboseMessage: String {
        return "\(type) at \(timestamp)"
    }
}

// 状态机事件枚举
enum StateMachineEvents {
    case startStop, timerFired, skipRest
}

// 状态机状态枚举
enum StateMachineStates {
    case idle, work, rest
}

// 通知
enum AppNotification {

    enum Category: String {
        case restStarted = "restStarted"
        case restFinished = "restFinished"
    }

    enum Action: String {
        case skipRest = "skipRest"
    }
}

// 窗口边缘
enum WindowEdg {
    case width
    case height
}
// 计算操作
enum WindowOperation {
    case plus
    case minus
}

// Days
struct Days: Codable, Identifiable {
    var id: Int
    var name: String
    var value: String
}

let sunday = Days(
    id: 1, name: "sunday", value: NSLocalizedString("Week.Sun", comment: "星期日"))
let monday = Days(
    id: 2, name: "monday", value: NSLocalizedString("Week.Mon", comment: "星期一"))
let tuesday = Days(
    id: 3, name: "tuesday", value: NSLocalizedString("Week.Tue", comment: "星期二")
)
let wednesday = Days(
    id: 4, name: "wednesday",
    value: NSLocalizedString("Week.Wed", comment: "星期三"))
let thursday = Days(
    id: 5, name: "thursday",
    value: NSLocalizedString("Week.Thu", comment: "星期四"))
let friday = Days(
    id: 6, name: "friday", value: NSLocalizedString("Week.Fri", comment: "星期五"))
let saturday = Days(
    id: 7, name: "saturday",
    value: NSLocalizedString("Week.Sat", comment: "星期六"))

// 颜色数据
struct ColorPattern: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var color: Color
}

// 颜色集
let Colors = [
    ColorPattern(name: "Aqua", color: Color("Aqua")),
    ColorPattern(name: "CongoPink", color: Color("CongoPink")),
    ColorPattern(
        name: "CrayolaBrightYellow", color: Color("CrayolaBrightYellow")),
    ColorPattern(name: "CrayolaGreen", color: Color("CrayolaGreen")),
    ColorPattern(name: "FerrariRed", color: Color("FerrariRed")),
    ColorPattern(name: "IndigoRainbow", color: Color("IndigoRainbow")),
    ColorPattern(name: "Iris", color: Color("Iris")),
    ColorPattern(name: "Jasper", color: Color("Jasper")),
    ColorPattern(name: "JetStream", color: Color("JetStream")),
    ColorPattern(
        name: "MidnightEagleGreen", color: Color("MidnightEagleGreen")),
    ColorPattern(name: "MintGreen", color: Color("MintGreen")),
    ColorPattern(name: "MossGreen", color: Color("MossGreen")),
    ColorPattern(name: "Orchid", color: Color("Orchid")),
    ColorPattern(name: "Oxley", color: Color("Oxley")),
    ColorPattern(name: "PaleGoldenrod", color: Color("PaleGoldenrod")),
    ColorPattern(name: "Persimmon", color: Color("Persimmon")),
    ColorPattern(name: "Pistachio", color: Color("Pistachio")),
    ColorPattern(name: "PortlandOrange", color: Color("PortlandOrange")),
    ColorPattern(name: "Skobeloff", color: Color("Skobeloff")),
    ColorPattern(name: "SpartanCrimson", color: Color("SpartanCrimson")),
    ColorPattern(name: "St.Patrick'sBlue", color: Color("St.Patrick'sBlue")),
    ColorPattern(name: "SunsetOrange", color: Color("SunsetOrange")),
    ColorPattern(name: "Tulip", color: Color("Tulip")),
]

//  背景
enum Background: Codable {
    case gradation, wallpaper, desktop, customize
}

//  样式
struct Appearance: Sendable, Codable {
    var color: String
    var background: Background
    var blur: CGFloat
}

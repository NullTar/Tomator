//
//  SchedulViewModel.swift
//
//  Created by NullSilck on 2025/3/15.
//

import Foundation
import SwiftUI

class ScheduleSetter: ObservableObject {

    static let shared = ScheduleSetter()

    // 时间表设置 检测是否开启时间表模式
    @AppStorage("workSchedule") var workSchedule = false
    // 数据库存储
    @AppStorage("workDays") private var workDays: Data = Data()
    @AppStorage("moringTime") private var moringTime: Data = Data()
    @AppStorage("afternoonTime") private var afternoonTime: Data = Data()

    @Published var morningStart: Date = createTime(hour: 8, min: 00) {
        didSet {
            updateMorningTimes()
        }
    }
    @Published var morningEnd: Date = createTime(hour: 13, min: 00) {
        didSet {
            updateMorningTimes()
        }
    }
    @Published var afternoonStart: Date = createTime(hour: 13, min: 00) {
        didSet {
            updateAfternoonTimes()
        }
    }
    @Published var afternoonEnd: Date = createTime(hour: 23, min: 30) {
        didSet {
            updateAfternoonTimes()
        }
    }

    // 默认值
    private var days: [Days] = [
        monday, tuesday, wednesday, thursday, friday,
    ]

    private init() {
        if let decodedMorningTimes = decodeDate(from: moringTime), decodedMorningTimes.count == 2 {
            morningStart =
                decodedMorningTimes.first!
            morningEnd =
                decodedMorningTimes.last!
        }

        if let decodedAfternoonTimes = decodeDate(from: afternoonTime), decodedAfternoonTimes.count == 2  {
            afternoonStart =
                decodedAfternoonTimes.first!
            afternoonEnd =
                decodedAfternoonTimes.last!
        }
    }

    // 更新数据库
    private func setWorkDays() {
        // 排序
        let sortedDays = days.sorted { $0.id < $1.id }
        // 编码并添加
        if let encoded = try? JSONEncoder().encode(sortedDays) {
            workDays = encoded
        }
    }

    // 添加 并更新数据库
    func addDays(day: Days) {
        // 检查重复
        if !days.contains(where: { $0.id == day.id }) {
            days.append(day)
            setWorkDays()
        }
    }

    // 删除 并更新数据库
    func removeDays(id: Int) {
        days.removeAll { day in
            day.id == id
        }
        setWorkDays()
    }

    // 拿到days数据 先从workDays拿 没有就使用初始化数据
    func fetchDays() -> [Days] {
        if let decoded = try? JSONDecoder().decode([Days].self, from: workDays),
            !decoded.isEmpty
        {
            days = decoded.sorted { $0.id < $1.id }
        } else {
            // 如果没有存储的数据，保存默认数据
            setWorkDays()
        }
        return days
    }

    // 更新早晨时间
    private func updateMorningTimes() {
        let morningTimes = [morningStart, morningEnd]
        if let encoded = try? JSONEncoder().encode(morningTimes) {
            moringTime = encoded
        }
    }

    // 更新下午时间
    private func updateAfternoonTimes() {
        let afternoonTimes = [afternoonStart, afternoonEnd]
        if let encoded = try? JSONEncoder().encode(afternoonTimes) {
            afternoonTime = encoded
        }
    }
    // 结构
    private func decodeDate(from data: Data) -> [Date]? {
        return try? JSONDecoder().decode([Date].self, from: data)
    }

    //  创建时间
    private static func createTime(hour: Int, min: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents(
            [.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = min

        // 使用这些组件来创建一个新的 Date 对象
        if let newDate = calendar.date(from: components) {
            return newDate
        } else {
            return Date()
        }
    }

}

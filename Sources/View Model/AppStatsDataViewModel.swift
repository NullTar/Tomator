//
//  StatsViewModel.swift
//
//  Created by NullSilck on 2025/3/12.
//

import Foundation

// 统计管理器 - 用于管理所有统计数据的处理和存取
class AppStatsDataViewModel: ObservableObject {

    static let shared = AppStatsDataViewModel()

    @Published private(set) var appStatsData: AppStatsData
    private let appStatsDataKey = "appStatsData"

    private init() {
        // 从用户默认设置加载统计数据，如果没有则创建新的
        if let data = UserDefaults.standard.data(forKey: appStatsDataKey),
            let loadedStats = try? JSONDecoder().decode(
                AppStatsData.self, from: data)
        {
            appStatsData = loadedStats
            checkAndResetDailyStats()  // 检查是否需要重置每日统计
        } else {
            appStatsData = AppStatsData()
        }
    }

    // 检查并重置每日统计数据，如果日期变更则重置当日统计并更新连续天数
    private func checkAndResetDailyStats() {
        let calendar = Calendar.current
        let today = Date()

        // 获取上次更新日期的日期部分
        let lastUpdateDay = calendar.startOfDay(
            for: appStatsData.lastUpdateDate)
        let todayDay = calendar.startOfDay(for: today)

        // 如果不是同一天，重置当日统计
        if lastUpdateDay != todayDay {
            // 如果上次更新日期是昨天，则增加连续天数
            if let yesterday = calendar.date(
                byAdding: .day, value: -1, to: todayDay),
                calendar.isDate(lastUpdateDay, inSameDayAs: yesterday)
            {
                // 更新连续天数
                if appStatsData.todayCompletedPomodoros > 0 {
                    appStatsData.currentStreak += 1
                    appStatsData.longestStreak = max(
                        appStatsData.longestStreak, appStatsData.currentStreak)
                }
            } else if appStatsData.todayCompletedPomodoros == 0 {
                // 如果不是昨天且没有完成番茄钟，重置连续天数
                appStatsData.currentStreak = 0
            }

            // 保存昨天的数据到每日统计
            if appStatsData.todayCompletedPomodoros > 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateKey = dateFormatter.string(
                    from: appStatsData.lastUpdateDate)
                appStatsData.dailyPomodoros[dateKey] =
                    appStatsData.todayCompletedPomodoros
            }

            // 重置当日统计
            appStatsData.todayCompletedPomodoros = 0
            appStatsData.todayWorkMinutes = 0
            appStatsData.lastUpdateDate = today

            // 保存更新
            saveStats()
        }
    }

    // 保存统计数据到用户默认设置
    private func saveStats() {
        if let data = try? JSONEncoder().encode(appStatsData) {
            UserDefaults.standard.set(data, forKey: appStatsDataKey)
        }
    }

    // 记录一个完成的番茄钟工作时间段
    func recordCompletedPomodoro(workMinutes: Int) {
        checkAndResetDailyStats()

        appStatsData.totalCompletedPomodoros += 1
        appStatsData.todayCompletedPomodoros += 1
        appStatsData.totalWorkMinutes += workMinutes
        appStatsData.todayWorkMinutes += workMinutes

        saveStats()
    }

    // 记录一次休息
    func recordBreak(value: TimeType) {
        switch value {
        case .Short:
            appStatsData.totalShortBreaks += 1
        case .Long:
            appStatsData.totalLongBreaks += 1
        default: return
        }
        saveStats()
    }

    // 获取过去N天的每日番茄钟数据
    func getPomodorosForLastDays(_ days: Int) -> [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var result: [(date: Date, count: Int)] = []

        // 添加过去N天的数据
        for dayOffset in 0..<days {
            if let date = calendar.date(
                byAdding: .day, value: -dayOffset, to: today)
            {
                let dateKey = dateFormatter.string(from: date)
                let count = appStatsData.dailyPomodoros[dateKey] ?? 0
                result.append((date: date, count: count))
            }
        }

        // 添加今天的数据（尚未保存到dailyPomodoros中）
        result[0] = (date: today, count: appStatsData.todayCompletedPomodoros)

        return result.reversed()
    }

    // 重置所有统计数据
    func resetAllStats() {
        appStatsData = AppStatsData()
        saveStats()
    }
}

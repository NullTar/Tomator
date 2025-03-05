import Foundation
import SwiftUI

// 番茄钟统计数据模型
struct TomatoStats: Codable {
    // 累计总工作时间（分钟）
    var totalWorkMinutes: Int = 0
    
    // 总完成的番茄钟数量
    var totalCompletedPomodoros: Int = 0
    
    // 总短休息次数
    var totalShortBreaks: Int = 0
    
    // 总长休息次数
    var totalLongBreaks: Int = 0
    
    // 当日完成的番茄钟数量
    var todayCompletedPomodoros: Int = 0
    
    // 当日工作时间（分钟）
    var todayWorkMinutes: Int = 0
    
    // 上次统计更新日期
    var lastUpdateDate: Date = Date()
    
    // 每日统计记录 - 键为日期字符串 "yyyy-MM-dd"，值为当日完成的番茄钟数量
    var dailyPomodoros: [String: Int] = [:]
    
    // 最长连续工作天数
    var longestStreak: Int = 0
    
    // 当前连续工作天数
    var currentStreak: Int = 0
}

// 统计管理器 - 用于管理所有统计数据的处理和存取
class StatsManager: ObservableObject {
    static let shared = StatsManager()
    
    @Published private(set) var stats: TomatoStats
    private let statsKey = "TomatoBarStats"
    
    private init() {
        // 从用户默认设置加载统计数据，如果没有则创建新的
        if let data = UserDefaults.standard.data(forKey: statsKey),
           let loadedStats = try? JSONDecoder().decode(TomatoStats.self, from: data) {
            stats = loadedStats
            checkAndResetDailyStats() // 检查是否需要重置每日统计
        } else {
            stats = TomatoStats()
        }
    }
    
    // 检查并重置每日统计数据，如果日期变更则重置当日统计并更新连续天数
    private func checkAndResetDailyStats() {
        let calendar = Calendar.current
        let today = Date()
        
        // 获取上次更新日期的日期部分
        let lastUpdateDay = calendar.startOfDay(for: stats.lastUpdateDate)
        let todayDay = calendar.startOfDay(for: today)
        
        // 如果不是同一天，重置当日统计
        if lastUpdateDay != todayDay {
            // 如果上次更新日期是昨天，则增加连续天数
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: todayDay),
               calendar.isDate(lastUpdateDay, inSameDayAs: yesterday) {
                // 更新连续天数
                if stats.todayCompletedPomodoros > 0 {
                    stats.currentStreak += 1
                    stats.longestStreak = max(stats.longestStreak, stats.currentStreak)
                }
            } else if stats.todayCompletedPomodoros == 0 {
                // 如果不是昨天且没有完成番茄钟，重置连续天数
                stats.currentStreak = 0
            }
            
            // 保存昨天的数据到每日统计
            if stats.todayCompletedPomodoros > 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateKey = dateFormatter.string(from: stats.lastUpdateDate)
                stats.dailyPomodoros[dateKey] = stats.todayCompletedPomodoros
            }
            
            // 重置当日统计
            stats.todayCompletedPomodoros = 0
            stats.todayWorkMinutes = 0
            stats.lastUpdateDate = today
            
            // 保存更新
            saveStats()
        }
    }
    
    // 保存统计数据到用户默认设置
    private func saveStats() {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: statsKey)
        }
    }
    
    // 记录一个完成的番茄钟工作时间段
    func recordCompletedPomodoro(workMinutes: Int) {
        checkAndResetDailyStats()
        
        stats.totalCompletedPomodoros += 1
        stats.todayCompletedPomodoros += 1
        stats.totalWorkMinutes += workMinutes
        stats.todayWorkMinutes += workMinutes
        
        saveStats()
    }
    
    // 记录一次短休息
    func recordShortBreak() {
        stats.totalShortBreaks += 1
        saveStats()
    }
    
    // 记录一次长休息
    func recordLongBreak() {
        stats.totalLongBreaks += 1
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
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let dateKey = dateFormatter.string(from: date)
                let count = stats.dailyPomodoros[dateKey] ?? 0
                result.append((date: date, count: count))
            }
        }
        
        // 添加今天的数据（尚未保存到dailyPomodoros中）
        result[0] = (date: today, count: stats.todayCompletedPomodoros)
        
        return result.reversed()
    }
    
    // 重置所有统计数据
    func resetAllStats() {
        stats = TomatoStats()
        saveStats()
    }
} 
//
//  Stats.swift
//
//  Created by NullSilck on 2025/3/12.
//

import Foundation

// 番茄钟统计数据模型
struct AppStatsData: Codable {
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


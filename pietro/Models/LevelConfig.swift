//
//  LevelConfig.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import Foundation

// MARK: - Level Configuration

struct LevelConfig {
    /// Base XP required for level 2
    static let baseXP: Int = 100

    /// XP scaling factor per level (1.15 = 15% more each level)
    static let scalingFactor: Double = 1.15

    /// Maximum level cap
    static let maxLevel: Int = 100

    /// XP required to reach a specific level from level 1
    static func xpRequired(forLevel level: Int) -> Int {
        guard level > 1 else { return 0 }
        var totalXP = 0
        for l in 2...level {
            totalXP += xpForLevelUp(from: l - 1)
        }
        return totalXP
    }

    /// XP needed to level up FROM a specific level
    static func xpForLevelUp(from level: Int) -> Int {
        Int(Double(baseXP) * pow(scalingFactor, Double(level - 1)))
    }

    /// Calculate level from total XP
    static func level(forTotalXP xp: Int) -> Int {
        var level = 1
        var xpAccumulated = 0

        while level < maxLevel {
            let xpNeeded = xpForLevelUp(from: level)
            if xpAccumulated + xpNeeded > xp {
                break
            }
            xpAccumulated += xpNeeded
            level += 1
        }

        return level
    }

    /// XP progress within current level (0.0 to 1.0)
    static func levelProgress(forTotalXP xp: Int) -> Double {
        let currentLevel = level(forTotalXP: xp)
        let xpAtCurrentLevel = xpRequired(forLevel: currentLevel)
        let xpForNextLevel = xpForLevelUp(from: currentLevel)

        guard xpForNextLevel > 0 else { return 1.0 }

        let xpIntoLevel = xp - xpAtCurrentLevel
        return Double(xpIntoLevel) / Double(xpForNextLevel)
    }

    /// XP remaining to next level
    static func xpToNextLevel(forTotalXP xp: Int) -> Int {
        let currentLevel = level(forTotalXP: xp)
        let xpAtCurrentLevel = xpRequired(forLevel: currentLevel)
        let xpForNextLevel = xpForLevelUp(from: currentLevel)

        return xpForNextLevel - (xp - xpAtCurrentLevel)
    }
}

// MARK: - XP Award Configuration

struct XPAwardConfig {
    // MARK: - Workout Completion

    /// Base XP for completing any workout
    static let workoutBaseXP: Int = 50

    /// XP per 10 minutes of workout duration
    static let workoutDurationBonusPerTenMinutes: Int = 10

    /// Maximum duration bonus XP
    static let workoutDurationBonusCap: Int = 100

    /// Calculate workout completion XP
    static func workoutXP(durationMinutes: Int) -> Int {
        let durationBonus = min((durationMinutes / 10) * workoutDurationBonusPerTenMinutes, workoutDurationBonusCap)
        return workoutBaseXP + durationBonus
    }

    // MARK: - Daily Bonuses

    /// XP for first workout of the day
    static let firstWorkoutOfDayXP: Int = 20

    // MARK: - Streak Bonuses

    /// XP per streak day
    static let streakBonusPerDay: Int = 25

    /// Maximum streak days for bonus calculation
    static let streakBonusCap: Int = 7

    /// Calculate streak bonus XP
    static func streakBonusXP(streakDays: Int) -> Int {
        min(streakDays, streakBonusCap) * streakBonusPerDay
    }

    // MARK: - Weekly Goals

    /// XP for completing weekly goal
    static let weeklyGoalXP: Int = 100

    // MARK: - Quests (future use)

    /// Base XP for completing a daily quest
    static let dailyQuestXP: Int = 30

    /// Base XP for completing a weekly quest
    static let weeklyQuestXP: Int = 75

    // MARK: - Achievements (future use)

    /// XP for bronze tier achievement
    static let achievementBronzeXP: Int = 50

    /// XP for silver tier achievement
    static let achievementSilverXP: Int = 100

    /// XP for gold tier achievement
    static let achievementGoldXP: Int = 200
}

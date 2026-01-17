//
//  AchievementService.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import Foundation
import SwiftData
import Observation

// MARK: - Achievement Unlock Result

struct AchievementUnlockResult {
    let achievement: Achievement
    let xpAwarded: Int
}

// MARK: - Achievement Service

@Observable
final class AchievementService {
    private let modelContext: ModelContext

    // Pending unlock notifications
    var pendingUnlocks: [AchievementUnlockResult] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Seed Achievements

    /// Create all achievement definitions if they don't exist
    func seedAchievementsIfNeeded(existingAchievements: [Achievement]) {
        let existingKeys = Set(existingAchievements.map { $0.key })

        for definition in AchievementDefinition.all {
            if !existingKeys.contains(definition.key) {
                let achievement = definition.createAchievement()
                modelContext.insert(achievement)
            }
        }
    }

    // MARK: - Check Achievements

    /// Check all achievements and unlock any that are newly completed
    func checkAchievements(
        profile: PlayerProfile,
        completedWorkouts: [CompletedWorkout],
        achievements: [Achievement],
        currentStreak: Int
    ) -> [AchievementUnlockResult] {
        var newlyUnlocked: [AchievementUnlockResult] = []

        for achievement in achievements where !achievement.isUnlocked {
            var newProgress: Int?
            var shouldUnlock = false

            switch achievement.key {
            // Workout count achievements
            case "first_workout":
                newProgress = completedWorkouts.count
                shouldUnlock = completedWorkouts.count >= 1

            case "workouts_10":
                newProgress = completedWorkouts.count
                shouldUnlock = completedWorkouts.count >= 10

            case "workouts_50":
                newProgress = completedWorkouts.count
                shouldUnlock = completedWorkouts.count >= 50

            case "workouts_100":
                newProgress = completedWorkouts.count
                shouldUnlock = completedWorkouts.count >= 100

            // Streak achievements
            case "streak_7":
                newProgress = currentStreak
                shouldUnlock = currentStreak >= 7

            case "streak_30":
                newProgress = currentStreak
                shouldUnlock = currentStreak >= 30

            case "streak_100":
                newProgress = currentStreak
                shouldUnlock = currentStreak >= 100

            // Rank achievements
            case "rank_d":
                shouldUnlock = profile.rank >= .d

            case "rank_c":
                shouldUnlock = profile.rank >= .c

            case "rank_b":
                shouldUnlock = profile.rank >= .b

            case "rank_a":
                shouldUnlock = profile.rank >= .a

            case "rank_s":
                shouldUnlock = profile.rank >= .s

            // Level achievements
            case "level_10":
                newProgress = profile.currentLevel
                shouldUnlock = profile.currentLevel >= 10

            case "level_25":
                newProgress = profile.currentLevel
                shouldUnlock = profile.currentLevel >= 25

            case "level_50":
                newProgress = profile.currentLevel
                shouldUnlock = profile.currentLevel >= 50

            // Category mastery achievements
            case "push_master":
                let count = completedWorkouts.filter { $0.category == .push }.count
                newProgress = count
                shouldUnlock = count >= 10

            case "pull_master":
                let count = completedWorkouts.filter { $0.category == .pull }.count
                newProgress = count
                shouldUnlock = count >= 10

            case "core_master":
                let count = completedWorkouts.filter { $0.category == .core }.count
                newProgress = count
                shouldUnlock = count >= 10

            default:
                break
            }

            // Update progress
            if let progress = newProgress {
                achievement.progress = min(progress, achievement.targetProgress)
            }

            // Check for unlock
            if shouldUnlock && !achievement.isUnlocked {
                let result = unlockAchievement(achievement, profile: profile)
                newlyUnlocked.append(result)
            }
        }

        pendingUnlocks = newlyUnlocked
        return newlyUnlocked
    }

    /// Unlock an achievement and award XP
    private func unlockAchievement(_ achievement: Achievement, profile: PlayerProfile) -> AchievementUnlockResult {
        achievement.unlock()

        // Create XP event
        let xpEvent = XPEvent.achievementUnlock(
            achievementName: achievement.title,
            achievementId: achievement.id,
            xp: achievement.xpReward
        )
        modelContext.insert(xpEvent)

        // Award XP to profile
        profile.totalXP += achievement.xpReward
        profile.currentXP = profile.totalXP

        return AchievementUnlockResult(achievement: achievement, xpAwarded: achievement.xpReward)
    }

    // MARK: - Helper Methods

    /// Get unlocked achievements
    func unlockedAchievements(from achievements: [Achievement]) -> [Achievement] {
        achievements.filter { $0.isUnlocked }.sorted { $0.unlockedAt ?? Date() > $1.unlockedAt ?? Date() }
    }

    /// Get locked achievements
    func lockedAchievements(from achievements: [Achievement]) -> [Achievement] {
        achievements.filter { !$0.isUnlocked }.sorted { $0.progressPercent > $1.progressPercent }
    }

    /// Get achievements by category
    func achievements(from achievements: [Achievement], category: AchievementCategory) -> [Achievement] {
        achievements.filter { $0.category == category }
    }

    /// Get next closest achievement to unlock
    func nextAchievementToUnlock(from achievements: [Achievement]) -> Achievement? {
        lockedAchievements(from: achievements).first
    }

    /// Get recently unlocked achievements (within last 7 days)
    func recentlyUnlocked(from achievements: [Achievement]) -> [Achievement] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return achievements.filter {
            $0.isUnlocked && ($0.unlockedAt ?? Date.distantPast) > weekAgo
        }.sorted { $0.unlockedAt ?? Date() > $1.unlockedAt ?? Date() }
    }

    /// Get achievement statistics
    func stats(from achievements: [Achievement]) -> (unlocked: Int, total: Int, percent: Double) {
        let unlocked = achievements.filter { $0.isUnlocked }.count
        let total = achievements.count
        let percent = total > 0 ? Double(unlocked) / Double(total) : 0
        return (unlocked, total, percent)
    }

    /// Clear pending unlocks
    func clearPendingUnlocks() {
        pendingUnlocks = []
    }
}

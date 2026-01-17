//
//  XPService.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import Foundation
import SwiftData
import Observation

// MARK: - XP Award Result

struct XPAwardResult {
    let totalXPAwarded: Int
    let breakdown: [XPBreakdownItem]
    let leveledUp: Bool
    let newLevel: Int?
    let rankedUp: Bool
    let newRank: HunterRank?

    struct XPBreakdownItem {
        let source: String
        let amount: Int
        let icon: String
    }
}

// MARK: - XP Service

@Observable
final class XPService {
    private let modelContext: ModelContext

    // Pending notifications for UI
    var pendingXPAward: XPAwardResult?
    var showLevelUpOverlay = false
    var showRankUpOverlay = false
    var levelUpLevel: Int?
    var rankUpRank: HunterRank?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Award XP for Workout Completion

    func awardXPForWorkout(
        workout: CompletedWorkout,
        profile: PlayerProfile,
        currentStreak: Int,
        isFirstWorkoutOfDay: Bool,
        didCompleteWeeklyGoal: Bool
    ) -> XPAwardResult {
        var breakdownItems: [XPAwardResult.XPBreakdownItem] = []
        var totalXP = 0

        // 1. Base workout XP
        let workoutXP = XPAwardConfig.workoutXP(durationMinutes: workout.durationMinutes)
        breakdownItems.append(.init(
            source: "Workout Complete",
            amount: workoutXP,
            icon: "dumbbell.fill"
        ))
        totalXP += workoutXP

        // 2. First workout of day bonus
        if isFirstWorkoutOfDay {
            let firstWorkoutXP = XPAwardConfig.firstWorkoutOfDayXP
            breakdownItems.append(.init(
                source: "First Today",
                amount: firstWorkoutXP,
                icon: "sunrise.fill"
            ))
            totalXP += firstWorkoutXP
        }

        // 3. Streak bonus (if streak > 1)
        if currentStreak > 1 {
            let streakXP = XPAwardConfig.streakBonusXP(streakDays: currentStreak)
            breakdownItems.append(.init(
                source: "\(min(currentStreak, 7)) Day Streak",
                amount: streakXP,
                icon: "flame.fill"
            ))
            totalXP += streakXP
        }

        // 4. Weekly goal completion
        if didCompleteWeeklyGoal {
            let weeklyXP = XPAwardConfig.weeklyGoalXP
            breakdownItems.append(.init(
                source: "Weekly Goal",
                amount: weeklyXP,
                icon: "trophy.fill"
            ))
            totalXP += weeklyXP
        }

        // Apply XP to profile and check for level/rank ups
        let previousLevel = profile.currentLevel
        let previousRank = profile.rank

        profile.totalXP += totalXP
        profile.currentXP = profile.totalXP

        // Check for level up
        let newLevel = LevelConfig.level(forTotalXP: profile.totalXP)
        let leveledUp = newLevel > previousLevel
        if leveledUp {
            profile.currentLevel = newLevel
        }

        // Check for rank up
        let newRank = HunterRank.rank(forTotalXP: profile.totalXP)
        let rankedUp = newRank > previousRank
        if rankedUp {
            profile.rank = newRank
        }

        // Create XP events for history
        for item in breakdownItems {
            let sourceType: XPSourceType = {
                switch item.icon {
                case "dumbbell.fill": return .workoutCompletion
                case "sunrise.fill": return .firstWorkoutOfDay
                case "flame.fill": return .dailyStreak
                case "trophy.fill": return .weeklyGoal
                default: return .bonusXP
                }
            }()

            let event = XPEvent(
                amount: item.amount,
                sourceType: sourceType,
                sourceId: workout.id.uuidString,
                sourceName: item.source
            )
            modelContext.insert(event)
        }

        let result = XPAwardResult(
            totalXPAwarded: totalXP,
            breakdown: breakdownItems,
            leveledUp: leveledUp,
            newLevel: leveledUp ? newLevel : nil,
            rankedUp: rankedUp,
            newRank: rankedUp ? newRank : nil
        )

        // Set pending notifications
        pendingXPAward = result

        if leveledUp {
            levelUpLevel = newLevel
            showLevelUpOverlay = true
        }

        if rankedUp {
            rankUpRank = newRank
            showRankUpOverlay = true
        }

        return result
    }

    // MARK: - Helper Methods

    func isFirstWorkoutOfDay(completedWorkouts: [CompletedWorkout]) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let todayWorkouts = completedWorkouts.filter {
            calendar.startOfDay(for: $0.completedAt) == today
        }

        // If this would be the first workout today (count is 0 before adding new one)
        return todayWorkouts.isEmpty
    }

    func didJustCompleteWeeklyGoal(
        completedWorkouts: [CompletedWorkout],
        weeklyGoal: Int
    ) -> Bool {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
            return false
        }

        let workoutsThisWeek = completedWorkouts.filter {
            $0.completedAt >= startOfWeek
        }.count

        // Returns true if we just hit the goal exactly (was at goal-1, now at goal)
        return workoutsThisWeek == weeklyGoal
    }

    func calculateCurrentStreak(completedWorkouts: [CompletedWorkout]) -> Int {
        guard !completedWorkouts.isEmpty else { return 1 } // First workout starts streak at 1

        let calendar = Calendar.current
        let sortedByDate = completedWorkouts.sorted { $0.completedAt > $1.completedAt }

        // Group by day
        var uniqueDays: [Date] = []
        for workout in sortedByDate {
            let day = calendar.startOfDay(for: workout.completedAt)
            if !uniqueDays.contains(day) {
                uniqueDays.append(day)
            }
        }

        guard !uniqueDays.isEmpty else { return 1 }

        let today = calendar.startOfDay(for: Date())

        // If most recent workout is today, include today in streak
        // Otherwise start counting from most recent workout day
        var streak = 1

        // Check if today has a workout
        if uniqueDays[0] == today {
            // Count consecutive days backwards from today
            for i in 1..<uniqueDays.count {
                let expectedDay = calendar.date(byAdding: .day, value: -i, to: today)!
                if uniqueDays[i] == expectedDay {
                    streak += 1
                } else {
                    break
                }
            }
        } else {
            // No workout today yet - this new workout will be today's
            // Check if yesterday had a workout to continue streak
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            if uniqueDays[0] == yesterday {
                streak = 2 // Yesterday + today
                for i in 1..<uniqueDays.count {
                    let expectedDay = calendar.date(byAdding: .day, value: -(i + 1), to: today)!
                    if uniqueDays[i] == expectedDay {
                        streak += 1
                    } else {
                        break
                    }
                }
            }
            // Otherwise streak is 1 (just today)
        }

        return streak
    }

    // MARK: - Clear Notifications

    func clearPendingXPAward() {
        pendingXPAward = nil
    }

    func dismissLevelUpOverlay() {
        showLevelUpOverlay = false
        levelUpLevel = nil
    }

    func dismissRankUpOverlay() {
        showRankUpOverlay = false
        rankUpRank = nil
    }
}

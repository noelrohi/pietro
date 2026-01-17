//
//  QuestService.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import Foundation
import SwiftData
import Observation

// MARK: - Quest Completion Result

struct QuestCompletionResult {
    let quest: Quest
    let xpAwarded: Int
}

// MARK: - Quest Service

@Observable
final class QuestService {
    private let modelContext: ModelContext

    // Pending completion notifications
    var pendingCompletions: [QuestCompletionResult] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Quest Generation

    /// Generate daily quests if needed (called on app launch / day change)
    func generateDailyQuestsIfNeeded(existingQuests: [Quest]) {
        // Check if we already have active daily quests for today
        let today = Calendar.current.startOfDay(for: Date())
        let hasActiveDailyQuests = existingQuests.contains { quest in
            quest.type == .daily &&
            Calendar.current.isDate(quest.createdAt, inSameDayAs: today) &&
            !quest.isExpired
        }

        guard !hasActiveDailyQuests else { return }

        // Clean up expired quests first
        cleanupExpiredQuests(existingQuests: existingQuests)

        // Generate new daily quests
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: today)!

        let dailyQuests = generateDailyQuests(expiresAt: endOfDay)
        for quest in dailyQuests {
            modelContext.insert(quest)
        }
    }

    /// Generate weekly quests if needed (called on Monday / app launch)
    func generateWeeklyQuestsIfNeeded(existingQuests: [Quest]) {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
            return
        }

        // Check if we already have active weekly quests for this week
        let hasActiveWeeklyQuests = existingQuests.contains { quest in
            quest.type == .weekly &&
            quest.createdAt >= startOfWeek &&
            !quest.isExpired
        }

        guard !hasActiveWeeklyQuests else { return }

        // Generate new weekly quests
        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else { return }
        let endOfWeekNight = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endOfWeek)!

        let weeklyQuests = generateWeeklyQuests(expiresAt: endOfWeekNight)
        for quest in weeklyQuests {
            modelContext.insert(quest)
        }
    }

    /// Generate 3 daily quests
    private func generateDailyQuests(expiresAt: Date) -> [Quest] {
        // Randomly select quest templates for variety
        var quests: [Quest] = []

        // Always include "Complete 1 workout" quest
        quests.append(Quest.completeWorkouts(count: 1, expiresAt: expiresAt))

        // Randomly pick a category quest
        let categories: [WorkoutCategory] = [.push, .pull, .core]
        if let randomCategory = categories.randomElement() {
            quests.append(Quest.categoryWorkout(randomCategory, expiresAt: expiresAt))
        }

        // Add exercise collector quest
        quests.append(Quest.exerciseCollector(count: 5, expiresAt: expiresAt))

        return quests
    }

    /// Generate 2 weekly quests
    private func generateWeeklyQuests(expiresAt: Date) -> [Quest] {
        return [
            Quest.weeklyWorkouts(count: 5, expiresAt: expiresAt),
            Quest.allCategories(expiresAt: expiresAt)
        ]
    }

    // MARK: - Quest Progress Tracking

    /// Check and update quest progress after a workout completion
    func checkQuestProgress(
        workout: CompletedWorkout,
        profile: PlayerProfile,
        quests: [Quest],
        completedWorkouts: [CompletedWorkout]
    ) -> [QuestCompletionResult] {
        var completedQuests: [QuestCompletionResult] = []

        for quest in quests where quest.isActive {
            var shouldIncrement = false

            // Check based on quest type
            if quest.category == nil {
                // Generic workout quest - any workout counts
                if quest.title.contains("Weekly Champion") || quest.title.contains("Daily Warrior") || quest.title.contains("Double Down") {
                    shouldIncrement = true
                }
            } else if quest.matches(category: workout.category) {
                // Category-specific quest
                shouldIncrement = true
            }

            // Handle "Well Rounded" quest (all categories)
            if quest.title == "Well Rounded" {
                let categoriesThisWeek = categoriesCompletedThisWeek(completedWorkouts: completedWorkouts)
                let newProgress = categoriesThisWeek.count
                if newProgress > quest.currentProgress {
                    quest.currentProgress = newProgress
                    if quest.currentProgress >= quest.targetCount {
                        quest.isCompleted = true
                        quest.completedAt = Date()
                        let result = completeQuest(quest, profile: profile)
                        completedQuests.append(result)
                    }
                }
                continue
            }

            // Handle "Exercise Collector" quest
            if quest.title == "Exercise Collector" {
                // Count exercises from workout's associated workout template
                // For now, use a reasonable estimate based on workout duration
                let exerciseEstimate = max(workout.durationMinutes / 2, 3)
                if quest.incrementProgress(by: exerciseEstimate) {
                    let result = completeQuest(quest, profile: profile)
                    completedQuests.append(result)
                }
                continue
            }

            if shouldIncrement {
                if quest.incrementProgress() {
                    let result = completeQuest(quest, profile: profile)
                    completedQuests.append(result)
                }
            }
        }

        pendingCompletions = completedQuests
        return completedQuests
    }

    /// Complete a quest and award XP
    private func completeQuest(_ quest: Quest, profile: PlayerProfile) -> QuestCompletionResult {
        // Create XP event
        let xpEvent = XPEvent.questComplete(
            questName: quest.title,
            questId: quest.id,
            xp: quest.xpReward
        )
        modelContext.insert(xpEvent)

        // Award XP to profile (don't check level/rank here - let XPService handle that)
        profile.totalXP += quest.xpReward
        profile.currentXP = profile.totalXP

        return QuestCompletionResult(quest: quest, xpAwarded: quest.xpReward)
    }

    // MARK: - Helper Methods

    /// Get unique categories completed this week
    private func categoriesCompletedThisWeek(completedWorkouts: [CompletedWorkout]) -> Set<WorkoutCategory> {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
            return []
        }

        var categories = Set<WorkoutCategory>()
        for workout in completedWorkouts where workout.completedAt >= startOfWeek {
            categories.insert(workout.category)
        }

        return categories
    }

    /// Clean up expired quests
    func cleanupExpiredQuests(existingQuests: [Quest]) {
        let calendar = Calendar.current
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())!

        for quest in existingQuests {
            // Delete quests that expired more than 2 days ago
            if quest.expiresAt < twoDaysAgo {
                modelContext.delete(quest)
            }
        }
    }

    /// Get active quests (not completed, not expired)
    func activeQuests(from quests: [Quest]) -> [Quest] {
        quests.filter { $0.isActive }
    }

    /// Get daily quests only
    func dailyQuests(from quests: [Quest]) -> [Quest] {
        quests.filter { $0.type == .daily && !$0.isExpired }
    }

    /// Get weekly quests only
    func weeklyQuests(from quests: [Quest]) -> [Quest] {
        quests.filter { $0.type == .weekly && !$0.isExpired }
    }

    /// Clear pending completions
    func clearPendingCompletions() {
        pendingCompletions = []
    }
}

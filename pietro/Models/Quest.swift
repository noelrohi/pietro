//
//  Quest.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import Foundation
import SwiftData

// MARK: - Quest Type

enum QuestType: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"

    var icon: String {
        switch self {
        case .daily: return "sun.max.fill"
        case .weekly: return "calendar.badge.clock"
        }
    }

    var durationDescription: String {
        switch self {
        case .daily: return "Today"
        case .weekly: return "This Week"
        }
    }
}

// MARK: - Quest Model

@Model
final class Quest {
    var id: UUID
    var title: String
    var descriptionText: String
    var typeRaw: String // "Daily" | "Weekly"
    var categoryRaw: String? // Optional: "Push" | "Pull" | "Core"
    var targetCount: Int
    var currentProgress: Int
    var xpReward: Int
    var isCompleted: Bool
    var completedAt: Date?
    var expiresAt: Date
    var createdAt: Date

    // MARK: - Initialization

    init(
        title: String,
        descriptionText: String,
        type: QuestType,
        category: WorkoutCategory? = nil,
        targetCount: Int,
        xpReward: Int,
        expiresAt: Date
    ) {
        self.id = UUID()
        self.title = title
        self.descriptionText = descriptionText
        self.typeRaw = type.rawValue
        self.categoryRaw = category?.rawValue
        self.targetCount = targetCount
        self.currentProgress = 0
        self.xpReward = xpReward
        self.isCompleted = false
        self.completedAt = nil
        self.expiresAt = expiresAt
        self.createdAt = Date()
    }

    // MARK: - Type-Safe Accessors

    var type: QuestType {
        get { QuestType(rawValue: typeRaw) ?? .daily }
        set { typeRaw = newValue.rawValue }
    }

    var category: WorkoutCategory? {
        get { categoryRaw.flatMap { WorkoutCategory(rawValue: $0) } }
        set { categoryRaw = newValue?.rawValue }
    }

    // MARK: - Computed Properties

    var progress: Double {
        guard targetCount > 0 else { return 0 }
        return min(Double(currentProgress) / Double(targetCount), 1.0)
    }

    var isExpired: Bool {
        Date() > expiresAt
    }

    var isActive: Bool {
        !isCompleted && !isExpired
    }

    var progressText: String {
        "\(currentProgress)/\(targetCount)"
    }

    var icon: String {
        if let category = category {
            return category.icon
        }
        return type.icon
    }

    var timeRemaining: String {
        guard !isExpired else { return "Expired" }

        let remaining = expiresAt.timeIntervalSince(Date())
        let hours = Int(remaining / 3600)
        let minutes = Int((remaining.truncatingRemainder(dividingBy: 3600)) / 60)

        if hours >= 24 {
            let days = hours / 24
            return "\(days)d left"
        } else if hours > 0 {
            return "\(hours)h left"
        } else if minutes > 0 {
            return "\(minutes)m left"
        } else {
            return "Expires soon"
        }
    }

    // MARK: - Methods

    /// Increment progress and check for completion
    @discardableResult
    func incrementProgress(by amount: Int = 1) -> Bool {
        guard !isCompleted else { return false }

        currentProgress = min(currentProgress + amount, targetCount)

        if currentProgress >= targetCount {
            isCompleted = true
            completedAt = Date()
            return true
        }

        return false
    }

    /// Check if a workout matches this quest's requirements
    func matches(workout: CompletedWorkout) -> Bool {
        // If quest has a category requirement, check it
        if let category = category {
            return workout.category == category
        }
        // Quest applies to any workout
        return true
    }

    /// Check if a workout matches this quest's requirements
    func matches(category: WorkoutCategory) -> Bool {
        if let questCategory = self.category {
            return questCategory == category
        }
        return true
    }
}

// MARK: - Quest Templates

extension Quest {
    /// Create a "Complete X workouts" daily quest
    static func completeWorkouts(count: Int, expiresAt: Date) -> Quest {
        Quest(
            title: count == 1 ? "Daily Warrior" : "Double Down",
            descriptionText: count == 1 ? "Complete 1 workout today" : "Complete \(count) workouts today",
            type: .daily,
            targetCount: count,
            xpReward: count == 1 ? 30 : 50,
            expiresAt: expiresAt
        )
    }

    /// Create a category-specific workout quest
    static func categoryWorkout(_ category: WorkoutCategory, expiresAt: Date) -> Quest {
        Quest(
            title: "\(category.rawValue) Power",
            descriptionText: "Complete a \(category.rawValue) workout",
            type: .daily,
            category: category,
            targetCount: 1,
            xpReward: 30,
            expiresAt: expiresAt
        )
    }

    /// Create an "Exercise collector" quest
    static func exerciseCollector(count: Int, expiresAt: Date) -> Quest {
        Quest(
            title: "Exercise Collector",
            descriptionText: "Complete \(count) exercises total",
            type: .daily,
            targetCount: count,
            xpReward: 40,
            expiresAt: expiresAt
        )
    }

    /// Create a weekly workout quest
    static func weeklyWorkouts(count: Int, expiresAt: Date) -> Quest {
        Quest(
            title: "Weekly Champion",
            descriptionText: "Complete \(count) workouts this week",
            type: .weekly,
            targetCount: count,
            xpReward: 75,
            expiresAt: expiresAt
        )
    }

    /// Create a "try all categories" weekly quest
    static func allCategories(expiresAt: Date) -> Quest {
        Quest(
            title: "Well Rounded",
            descriptionText: "Complete Push, Pull, and Core workouts",
            type: .weekly,
            targetCount: 3,
            xpReward: 100,
            expiresAt: expiresAt
        )
    }
}

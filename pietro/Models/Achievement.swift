//
//  Achievement.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - Achievement Tier

enum AchievementTier: String, Codable, CaseIterable, Comparable {
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"

    static func < (lhs: AchievementTier, rhs: AchievementTier) -> Bool {
        lhs.numericValue < rhs.numericValue
    }

    private var numericValue: Int {
        switch self {
        case .bronze: return 0
        case .silver: return 1
        case .gold: return 2
        }
    }

    var xpReward: Int {
        switch self {
        case .bronze: return XPAwardConfig.achievementBronzeXP
        case .silver: return XPAwardConfig.achievementSilverXP
        case .gold: return XPAwardConfig.achievementGoldXP
        }
    }

    var color: Color {
        switch self {
        case .bronze: return Color(hex: "cd7f32")
        case .silver: return Color(hex: "c0c0c0")
        case .gold: return Color(hex: "fbbf24")
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .bronze:
            return LinearGradient(
                colors: [Color(hex: "b45309"), Color(hex: "cd7f32")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .silver:
            return LinearGradient(
                colors: [Color(hex: "9ca3af"), Color(hex: "d1d5db")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .gold:
            return LinearGradient(
                colors: [Color(hex: "d97706"), Color(hex: "fbbf24"), Color(hex: "fde68a")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    var hasGlow: Bool {
        self == .gold
    }
}

// MARK: - Achievement Category

enum AchievementCategory: String, Codable, CaseIterable {
    case workout = "Workouts"
    case streak = "Streaks"
    case rank = "Ranks"
    case level = "Levels"
    case category = "Categories"

    var icon: String {
        switch self {
        case .workout: return "dumbbell.fill"
        case .streak: return "flame.fill"
        case .rank: return "crown.fill"
        case .level: return "star.fill"
        case .category: return "square.grid.2x2.fill"
        }
    }
}

// MARK: - Achievement Model

@Model
final class Achievement {
    var id: UUID
    var key: String // Unique identifier: "first_workout", "streak_7"
    var title: String
    var descriptionText: String
    var tierRaw: String // "Bronze" | "Silver" | "Gold"
    var categoryRaw: String // Achievement category for grouping
    var xpReward: Int
    var icon: String // SF Symbol name
    var isUnlocked: Bool
    var unlockedAt: Date?
    var progress: Int // Current progress toward unlock
    var targetProgress: Int // Target to unlock
    var createdAt: Date

    // MARK: - Initialization

    init(
        key: String,
        title: String,
        descriptionText: String,
        tier: AchievementTier,
        category: AchievementCategory,
        icon: String,
        targetProgress: Int
    ) {
        self.id = UUID()
        self.key = key
        self.title = title
        self.descriptionText = descriptionText
        self.tierRaw = tier.rawValue
        self.categoryRaw = category.rawValue
        self.xpReward = tier.xpReward
        self.icon = icon
        self.isUnlocked = false
        self.unlockedAt = nil
        self.progress = 0
        self.targetProgress = targetProgress
        self.createdAt = Date()
    }

    // MARK: - Type-Safe Accessors

    var tier: AchievementTier {
        get { AchievementTier(rawValue: tierRaw) ?? .bronze }
        set { tierRaw = newValue.rawValue }
    }

    var category: AchievementCategory {
        get { AchievementCategory(rawValue: categoryRaw) ?? .workout }
        set { categoryRaw = newValue.rawValue }
    }

    // MARK: - Computed Properties

    var progressPercent: Double {
        guard targetProgress > 0 else { return 0 }
        return min(Double(progress) / Double(targetProgress), 1.0)
    }

    var progressText: String {
        if isUnlocked {
            return "Completed"
        }
        return "\(progress)/\(targetProgress)"
    }

    var formattedXP: String {
        "+\(xpReward) XP"
    }

    var unlockedDateText: String? {
        guard let date = unlockedAt else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // MARK: - Methods

    /// Update progress and check for unlock
    @discardableResult
    func updateProgress(_ newProgress: Int) -> Bool {
        guard !isUnlocked else { return false }

        progress = min(newProgress, targetProgress)

        if progress >= targetProgress {
            isUnlocked = true
            unlockedAt = Date()
            return true
        }

        return false
    }

    /// Unlock the achievement immediately
    func unlock() {
        guard !isUnlocked else { return }
        progress = targetProgress
        isUnlocked = true
        unlockedAt = Date()
    }
}

// MARK: - Achievement Definitions

struct AchievementDefinition {
    let key: String
    let title: String
    let description: String
    let tier: AchievementTier
    let category: AchievementCategory
    let icon: String
    let target: Int

    func createAchievement() -> Achievement {
        Achievement(
            key: key,
            title: title,
            descriptionText: description,
            tier: tier,
            category: category,
            icon: icon,
            targetProgress: target
        )
    }

    // MARK: - All Achievement Definitions

    static let all: [AchievementDefinition] = [
        // Workout Achievements
        AchievementDefinition(
            key: "first_workout",
            title: "First Blood",
            description: "Complete your first workout",
            tier: .bronze,
            category: .workout,
            icon: "bolt.fill",
            target: 1
        ),
        AchievementDefinition(
            key: "workouts_10",
            title: "Dedicated",
            description: "Complete 10 workouts",
            tier: .bronze,
            category: .workout,
            icon: "dumbbell.fill",
            target: 10
        ),
        AchievementDefinition(
            key: "workouts_50",
            title: "Committed",
            description: "Complete 50 workouts",
            tier: .silver,
            category: .workout,
            icon: "dumbbell.fill",
            target: 50
        ),
        AchievementDefinition(
            key: "workouts_100",
            title: "Centurion",
            description: "Complete 100 workouts",
            tier: .gold,
            category: .workout,
            icon: "medal.fill",
            target: 100
        ),

        // Streak Achievements
        AchievementDefinition(
            key: "streak_7",
            title: "Week Warrior",
            description: "Maintain a 7-day streak",
            tier: .bronze,
            category: .streak,
            icon: "flame.fill",
            target: 7
        ),
        AchievementDefinition(
            key: "streak_30",
            title: "Monthly Master",
            description: "Maintain a 30-day streak",
            tier: .silver,
            category: .streak,
            icon: "flame.fill",
            target: 30
        ),
        AchievementDefinition(
            key: "streak_100",
            title: "Unstoppable",
            description: "Maintain a 100-day streak",
            tier: .gold,
            category: .streak,
            icon: "flame.fill",
            target: 100
        ),

        // Rank Achievements
        AchievementDefinition(
            key: "rank_d",
            title: "Hunter",
            description: "Reach Rank D",
            tier: .bronze,
            category: .rank,
            icon: "shield.fill",
            target: 1
        ),
        AchievementDefinition(
            key: "rank_c",
            title: "Warrior",
            description: "Reach Rank C",
            tier: .bronze,
            category: .rank,
            icon: "shield.fill",
            target: 1
        ),
        AchievementDefinition(
            key: "rank_b",
            title: "Elite",
            description: "Reach Rank B",
            tier: .silver,
            category: .rank,
            icon: "shield.fill",
            target: 1
        ),
        AchievementDefinition(
            key: "rank_a",
            title: "Champion",
            description: "Reach Rank A",
            tier: .silver,
            category: .rank,
            icon: "shield.fill",
            target: 1
        ),
        AchievementDefinition(
            key: "rank_s",
            title: "Shadow Monarch",
            description: "Reach Rank S",
            tier: .gold,
            category: .rank,
            icon: "crown.fill",
            target: 1
        ),

        // Level Achievements
        AchievementDefinition(
            key: "level_10",
            title: "Rising Star",
            description: "Reach Level 10",
            tier: .bronze,
            category: .level,
            icon: "star.fill",
            target: 10
        ),
        AchievementDefinition(
            key: "level_25",
            title: "Veteran",
            description: "Reach Level 25",
            tier: .silver,
            category: .level,
            icon: "star.fill",
            target: 25
        ),
        AchievementDefinition(
            key: "level_50",
            title: "Legend",
            description: "Reach Level 50",
            tier: .gold,
            category: .level,
            icon: "star.fill",
            target: 50
        ),

        // Category Mastery Achievements
        AchievementDefinition(
            key: "push_master",
            title: "Push Master",
            description: "Complete 10 Push workouts",
            tier: .bronze,
            category: .category,
            icon: "dumbbell.fill",
            target: 10
        ),
        AchievementDefinition(
            key: "pull_master",
            title: "Pull Master",
            description: "Complete 10 Pull workouts",
            tier: .bronze,
            category: .category,
            icon: "figure.strengthtraining.traditional",
            target: 10
        ),
        AchievementDefinition(
            key: "core_master",
            title: "Core Master",
            description: "Complete 10 Core workouts",
            tier: .bronze,
            category: .category,
            icon: "bolt.fill",
            target: 10
        ),
    ]
}

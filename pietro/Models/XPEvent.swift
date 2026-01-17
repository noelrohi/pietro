//
//  XPEvent.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import Foundation
import SwiftData

// MARK: - XP Source Type

enum XPSourceType: String, Codable, CaseIterable {
    case workoutCompletion = "Workout Completion"
    case dailyStreak = "Daily Streak"
    case firstWorkoutOfDay = "First Workout"
    case weeklyGoal = "Weekly Goal"
    case questCompletion = "Quest"
    case achievementUnlock = "Achievement"
    case bonusXP = "Bonus"

    var icon: String {
        switch self {
        case .workoutCompletion: return "dumbbell.fill"
        case .dailyStreak: return "flame.fill"
        case .firstWorkoutOfDay: return "sunrise.fill"
        case .weeklyGoal: return "trophy.fill"
        case .questCompletion: return "scroll.fill"
        case .achievementUnlock: return "star.fill"
        case .bonusXP: return "gift.fill"
        }
    }

    var description: String {
        switch self {
        case .workoutCompletion: return "Completed a workout"
        case .dailyStreak: return "Maintained your streak"
        case .firstWorkoutOfDay: return "First workout today"
        case .weeklyGoal: return "Reached weekly goal"
        case .questCompletion: return "Completed a quest"
        case .achievementUnlock: return "Unlocked achievement"
        case .bonusXP: return "Bonus reward"
        }
    }
}

// MARK: - XP Event Model

@Model
final class XPEvent {
    var id: UUID
    var amount: Int
    var sourceTypeRaw: String
    var sourceId: String? // Optional: ID of workout, quest, or achievement
    var sourceName: String? // Optional: Name for display
    var earnedAt: Date

    // MARK: - Initialization

    init(
        amount: Int,
        sourceType: XPSourceType,
        sourceId: String? = nil,
        sourceName: String? = nil
    ) {
        self.id = UUID()
        self.amount = amount
        self.sourceTypeRaw = sourceType.rawValue
        self.sourceId = sourceId
        self.sourceName = sourceName
        self.earnedAt = Date()
    }

    // MARK: - Type-Safe Accessors

    var sourceType: XPSourceType {
        get { XPSourceType(rawValue: sourceTypeRaw) ?? .bonusXP }
        set { sourceTypeRaw = newValue.rawValue }
    }

    // MARK: - Computed Properties

    var displayTitle: String {
        sourceName ?? sourceType.description
    }

    var displaySubtitle: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: earnedAt, relativeTo: Date())
    }

    var formattedAmount: String {
        "+\(amount) XP"
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(earnedAt)
    }

    var isThisWeek: Bool {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
            return false
        }
        return earnedAt >= startOfWeek
    }

    // MARK: - Factory Methods

    static func workoutCompletion(workoutName: String, workoutId: UUID, xp: Int) -> XPEvent {
        XPEvent(
            amount: xp,
            sourceType: .workoutCompletion,
            sourceId: workoutId.uuidString,
            sourceName: workoutName
        )
    }

    static func dailyStreak(day: Int) -> XPEvent {
        // Cap streak bonus at 7 days (175 XP max)
        let xp = min(day, 7) * 25
        return XPEvent(
            amount: xp,
            sourceType: .dailyStreak,
            sourceName: "Day \(day) streak bonus"
        )
    }

    static func firstWorkoutOfDay() -> XPEvent {
        XPEvent(
            amount: 20,
            sourceType: .firstWorkoutOfDay
        )
    }

    static func weeklyGoalComplete(week: Int) -> XPEvent {
        XPEvent(
            amount: 100,
            sourceType: .weeklyGoal,
            sourceName: "Week \(week) goal complete"
        )
    }

    static func questComplete(questName: String, questId: UUID, xp: Int) -> XPEvent {
        XPEvent(
            amount: xp,
            sourceType: .questCompletion,
            sourceId: questId.uuidString,
            sourceName: questName
        )
    }

    static func achievementUnlock(achievementName: String, achievementId: UUID, xp: Int) -> XPEvent {
        XPEvent(
            amount: xp,
            sourceType: .achievementUnlock,
            sourceId: achievementId.uuidString,
            sourceName: achievementName
        )
    }
}

// MARK: - XP Calculation Helpers

extension XPEvent {
    /// Calculate XP for a workout based on duration
    static func calculateWorkoutXP(durationMinutes: Int) -> Int {
        // Base: 50 XP
        // Duration bonus: 10 XP per 10 minutes, capped at 100 bonus
        let baseXP = 50
        let durationBonus = min((durationMinutes / 10) * 10, 100)
        return baseXP + durationBonus
    }
}

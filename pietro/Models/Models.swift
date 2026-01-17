//
//  Models.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import Foundation
import SwiftData

// MARK: - Workout Category

enum WorkoutCategory: String, Codable, CaseIterable {
    case push = "Push"
    case pull = "Pull"
    case core = "Core"
    
    var icon: String {
        switch self {
        case .push: return "dumbbell.fill"
        case .pull: return "figure.strengthtraining.traditional"
        case .core: return "bolt.fill"
        }
    }
    
    var color: String {
        switch self {
        case .push: return "primary"
        case .pull: return "success"
        case .core: return "amber"
        }
    }
}

// MARK: - Exercise

@Model
final class Exercise {
    var id: UUID
    var name: String
    var sets: Int
    var durationSeconds: Int
    var order: Int
    
    @Relationship(inverse: \Workout.exercises)
    var workout: Workout?
    
    init(name: String, sets: Int = 3, durationSeconds: Int = 30, order: Int = 0) {
        self.id = UUID()
        self.name = name
        self.sets = sets
        self.durationSeconds = durationSeconds
        self.order = order
    }
    
    var formattedDuration: String {
        "\(durationSeconds)s"
    }
    
    var subtitle: String {
        "\(sets) sets \u{00B7} \(formattedDuration) each"
    }
}

// MARK: - Workout

@Model
final class Workout {
    var id: UUID
    var name: String
    var categoryRaw: String
    var durationMinutes: Int
    var isFeatured: Bool
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade)
    var exercises: [Exercise]
    
    init(name: String, category: WorkoutCategory, durationMinutes: Int, isFeatured: Bool = false) {
        self.id = UUID()
        self.name = name
        self.categoryRaw = category.rawValue
        self.durationMinutes = durationMinutes
        self.isFeatured = isFeatured
        self.createdAt = Date()
        self.exercises = []
    }
    
    var category: WorkoutCategory {
        get { WorkoutCategory(rawValue: categoryRaw) ?? .push }
        set { categoryRaw = newValue.rawValue }
    }
    
    var exerciseCount: Int {
        exercises.count
    }
    
    var sortedExercises: [Exercise] {
        exercises.sorted { $0.order < $1.order }
    }
    
    var subtitle: String {
        "\(durationMinutes) min \u{00B7} \(exerciseCount) ex"
    }
}

// MARK: - Completed Workout

@Model
final class CompletedWorkout {
    var id: UUID
    var workoutName: String
    var workoutCategory: String
    var durationMinutes: Int
    var completedAt: Date
    
    init(workout: Workout) {
        self.id = UUID()
        self.workoutName = workout.name
        self.workoutCategory = workout.categoryRaw
        self.durationMinutes = workout.durationMinutes
        self.completedAt = Date()
    }
    
    init(workoutName: String, category: WorkoutCategory, durationMinutes: Int, completedAt: Date = Date()) {
        self.id = UUID()
        self.workoutName = workoutName
        self.workoutCategory = category.rawValue
        self.durationMinutes = durationMinutes
        self.completedAt = completedAt
    }
    
    var category: WorkoutCategory {
        WorkoutCategory(rawValue: workoutCategory) ?? .push
    }
    
    var dayLabel: String {
        if Calendar.current.isDateInToday(completedAt) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(completedAt) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: completedAt)
        }
    }
    
    var subtitle: String {
        "\(dayLabel) \u{00B7} \(durationMinutes) min"
    }
}

// MARK: - User Stats (Computed Helper)

struct UserStats {
    let completedWorkouts: [CompletedWorkout]
    
    var totalWorkouts: Int {
        completedWorkouts.count
    }
    
    var totalMinutes: Int {
        completedWorkouts.reduce(0) { $0 + $1.durationMinutes }
    }
    
    var currentStreak: Int {
        calculateStreak()
    }
    
    var bestStreak: Int {
        calculateBestStreak()
    }
    
    var workoutsThisWeek: Int {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        return completedWorkouts.filter { $0.completedAt >= startOfWeek }.count
    }
    
    var weeklyGoal: Int { 5 }
    
    var weeklyProgress: Double {
        min(Double(workoutsThisWeek) / Double(weeklyGoal), 1.0)
    }
    
    // Get completed days this week (0 = Sunday, 1 = Monday, etc.)
    var completedDaysThisWeek: Set<Int> {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        
        var days = Set<Int>()
        for workout in completedWorkouts where workout.completedAt >= startOfWeek {
            let weekday = calendar.component(.weekday, from: workout.completedAt)
            // Convert to Monday = 0 format
            let mondayBasedDay = (weekday + 5) % 7
            days.insert(mondayBasedDay)
        }
        return days
    }
    
    var todayDayIndex: Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        return (weekday + 5) % 7  // Monday = 0
    }
    
    private func calculateStreak() -> Int {
        guard !completedWorkouts.isEmpty else { return 0 }
        
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
        
        guard !uniqueDays.isEmpty else { return 0 }
        
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        // Streak must start from today or yesterday
        guard uniqueDays[0] == today || uniqueDays[0] == yesterday else { return 0 }
        
        var streak = 1
        for i in 1..<uniqueDays.count {
            let expectedDay = calendar.date(byAdding: .day, value: -i, to: uniqueDays[0])!
            if uniqueDays[i] == expectedDay {
                streak += 1
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func calculateBestStreak() -> Int {
        guard !completedWorkouts.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let sortedByDate = completedWorkouts.sorted { $0.completedAt < $1.completedAt }
        
        // Get unique days
        var uniqueDays: [Date] = []
        for workout in sortedByDate {
            let day = calendar.startOfDay(for: workout.completedAt)
            if !uniqueDays.contains(day) {
                uniqueDays.append(day)
            }
        }
        
        guard !uniqueDays.isEmpty else { return 0 }
        
        var bestStreak = 1
        var currentStreak = 1
        
        for i in 1..<uniqueDays.count {
            let previousDay = calendar.date(byAdding: .day, value: 1, to: uniqueDays[i-1])!
            if uniqueDays[i] == previousDay {
                currentStreak += 1
                bestStreak = max(bestStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return bestStreak
    }
}

//
//  PlayerProfile.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import Foundation
import SwiftData

// MARK: - Supporting Enums

enum Gender: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    case other = "Other"

    var icon: String {
        switch self {
        case .male: return "figure.stand"
        case .female: return "figure.stand.dress"
        case .other: return "figure.wave"
        }
    }
}

enum FitnessGoal: String, Codable, CaseIterable {
    case buildMuscle = "Build Muscle"
    case loseWeight = "Lose Weight"
    case lookBetter = "Look Better"
    case stayInShape = "Stay In Shape"

    var icon: String {
        switch self {
        case .buildMuscle: return "dumbbell.fill"
        case .loseWeight: return "flame.fill"
        case .lookBetter: return "sparkles"
        case .stayInShape: return "heart.fill"
        }
    }

    var description: String {
        switch self {
        case .buildMuscle: return "Gain strength and muscle mass"
        case .loseWeight: return "Burn fat and slim down"
        case .lookBetter: return "Improve physique and confidence"
        case .stayInShape: return "Maintain fitness and health"
        }
    }
}

enum FitnessLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var description: String {
        switch self {
        case .beginner: return "New to fitness or returning after a break"
        case .intermediate: return "Consistent workouts for 6+ months"
        case .advanced: return "Training seriously for 2+ years"
        }
    }

    var baseStatMultiplier: Double {
        switch self {
        case .beginner: return 0.3
        case .intermediate: return 0.5
        case .advanced: return 0.7
        }
    }
}

enum ActivityLevel: String, Codable, CaseIterable {
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"

    var description: String {
        switch self {
        case .sedentary: return "Little to no exercise, desk job"
        case .lightlyActive: return "Light exercise 1-3 days/week"
        case .moderatelyActive: return "Moderate exercise 3-5 days/week"
        case .veryActive: return "Hard exercise 6-7 days/week"
        }
    }
}

enum FocusArea: String, Codable, CaseIterable {
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case core = "Core"
    case legs = "Legs"
    case fullBody = "Full Body"

    var icon: String {
        switch self {
        case .chest: return "figure.strengthtraining.traditional"
        case .back: return "figure.rowing"
        case .shoulders: return "figure.arms.open"
        case .arms: return "figure.boxing"
        case .core: return "bolt.fill"
        case .legs: return "figure.run"
        case .fullBody: return "figure.mixed.cardio"
        }
    }
}

enum EquipmentType: String, Codable, CaseIterable {
    case none = "No Equipment"
    case dumbbells = "Dumbbells"
    case barbells = "Barbells"
    case kettlebells = "Kettlebells"
    case resistanceBands = "Resistance Bands"
    case pullUpBar = "Pull-up Bar"
    case cables = "Cable Machines"
    case fullGym = "Full Gym Access"

    var icon: String {
        switch self {
        case .none: return "hand.raised.fill"
        case .dumbbells: return "dumbbell.fill"
        case .barbells: return "figure.strengthtraining.traditional"
        case .kettlebells: return "figure.cross.training"
        case .resistanceBands: return "arrow.left.and.right"
        case .pullUpBar: return "figure.climbing"
        case .cables: return "cable.coaxial"
        case .fullGym: return "building.2.fill"
        }
    }
}

// MARK: - Player Profile Model

@Model
final class PlayerProfile {
    var id: UUID

    // MARK: - Profile Information

    var displayName: String
    var genderRaw: String?
    var birthDate: Date?
    var heightCm: Double?
    var weightKg: Double?
    var targetWeightKg: Double?

    // MARK: - Fitness Preferences

    var fitnessLevelRaw: String
    var activityLevelRaw: String
    var goalRaw: String
    var focusAreasRaw: String // Comma-separated FocusArea raw values
    var equipmentRaw: String // Comma-separated EquipmentType raw values
    var motivationsRaw: String // Comma-separated motivation strings

    // MARK: - Gamification

    var currentXP: Int
    var totalXP: Int
    var currentLevel: Int
    var rankRaw: String

    // MARK: - Player Stats (0-100 scale)

    var strength: Int
    var vitality: Int
    var agility: Int
    var recovery: Int

    // Potential stats (what they could achieve)
    var potentialStrength: Int
    var potentialVitality: Int
    var potentialAgility: Int
    var potentialRecovery: Int

    // MARK: - Workout Preferences

    var workoutDaysRaw: String // Comma-separated day indices (0=Monday, 6=Sunday)
    var weeklyGoal: Int
    var preferredWorkoutDuration: Int // in minutes

    // MARK: - Onboarding State

    var hasCompletedOnboarding: Bool
    var onboardingCompletedAt: Date?
    var createdAt: Date

    // MARK: - Initialization

    init(displayName: String = "Player") {
        self.id = UUID()
        self.displayName = displayName
        self.genderRaw = nil
        self.birthDate = nil
        self.heightCm = nil
        self.weightKg = nil
        self.targetWeightKg = nil
        self.fitnessLevelRaw = FitnessLevel.beginner.rawValue
        self.activityLevelRaw = ActivityLevel.sedentary.rawValue
        self.goalRaw = FitnessGoal.stayInShape.rawValue
        self.focusAreasRaw = ""
        self.equipmentRaw = ""
        self.motivationsRaw = ""
        self.currentXP = 0
        self.totalXP = 0
        self.currentLevel = 1
        self.rankRaw = HunterRank.e.rawValue
        self.strength = 10
        self.vitality = 10
        self.agility = 10
        self.recovery = 10
        self.potentialStrength = 80
        self.potentialVitality = 80
        self.potentialAgility = 80
        self.potentialRecovery = 80
        self.workoutDaysRaw = ""
        self.weeklyGoal = 3
        self.preferredWorkoutDuration = 30
        self.hasCompletedOnboarding = false
        self.onboardingCompletedAt = nil
        self.createdAt = Date()
    }

    // MARK: - Computed Properties: Type-Safe Accessors

    var gender: Gender? {
        get { genderRaw.flatMap { Gender(rawValue: $0) } }
        set { genderRaw = newValue?.rawValue }
    }

    var fitnessLevel: FitnessLevel {
        get { FitnessLevel(rawValue: fitnessLevelRaw) ?? .beginner }
        set { fitnessLevelRaw = newValue.rawValue }
    }

    var activityLevel: ActivityLevel {
        get { ActivityLevel(rawValue: activityLevelRaw) ?? .sedentary }
        set { activityLevelRaw = newValue.rawValue }
    }

    var goal: FitnessGoal {
        get { FitnessGoal(rawValue: goalRaw) ?? .stayInShape }
        set { goalRaw = newValue.rawValue }
    }

    var rank: HunterRank {
        get { HunterRank(rawValue: rankRaw) ?? .e }
        set { rankRaw = newValue.rawValue }
    }

    var focusAreas: [FocusArea] {
        get {
            guard !focusAreasRaw.isEmpty else { return [] }
            return focusAreasRaw.split(separator: ",")
                .compactMap { FocusArea(rawValue: String($0)) }
        }
        set {
            focusAreasRaw = newValue.map(\.rawValue).joined(separator: ",")
        }
    }

    var equipment: [EquipmentType] {
        get {
            guard !equipmentRaw.isEmpty else { return [] }
            return equipmentRaw.split(separator: ",")
                .compactMap { EquipmentType(rawValue: String($0)) }
        }
        set {
            equipmentRaw = newValue.map(\.rawValue).joined(separator: ",")
        }
    }

    var motivations: [String] {
        get {
            guard !motivationsRaw.isEmpty else { return [] }
            return motivationsRaw.split(separator: ",").map { String($0) }
        }
        set {
            motivationsRaw = newValue.joined(separator: ",")
        }
    }

    var workoutDays: [Int] {
        get {
            guard !workoutDaysRaw.isEmpty else { return [] }
            return workoutDaysRaw.split(separator: ",")
                .compactMap { Int(String($0)) }
        }
        set {
            workoutDaysRaw = newValue.map(String.init).joined(separator: ",")
        }
    }

    // MARK: - Computed Properties: Stats & Progress

    var age: Int? {
        guard let birthDate = birthDate else { return nil }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year
    }

    var totalStats: Int {
        strength + vitality + agility + recovery
    }

    var averageStats: Int {
        totalStats / 4
    }

    var potentialTotalStats: Int {
        potentialStrength + potentialVitality + potentialAgility + potentialRecovery
    }

    var statsProgress: Double {
        guard potentialTotalStats > 0 else { return 0 }
        return Double(totalStats) / Double(potentialTotalStats)
    }

    /// XP progress within current level (0.0 to 1.0)
    var levelProgress: Double {
        let xpForCurrentLevel = xpRequiredForLevel(currentLevel)
        let xpForNextLevel = xpRequiredForLevel(currentLevel + 1)
        let xpInCurrentLevel = currentXP - xpForCurrentLevel
        let xpNeededForLevel = xpForNextLevel - xpForCurrentLevel
        guard xpNeededForLevel > 0 else { return 1.0 }
        return Double(xpInCurrentLevel) / Double(xpNeededForLevel)
    }

    /// XP progress within current rank (0.0 to 1.0)
    var rankProgress: Double {
        guard let xpToNext = rank.xpToNextRank else { return 1.0 }
        let xpInRank = totalXP - rank.xpThreshold
        return Double(xpInRank) / Double(xpToNext)
    }

    var xpToNextLevel: Int {
        xpRequiredForLevel(currentLevel + 1) - currentXP
    }

    var xpToNextRank: Int? {
        guard let next = rank.nextRank else { return nil }
        return next.xpThreshold - totalXP
    }

    // MARK: - Level Calculation

    /// XP required to reach a specific level
    func xpRequiredForLevel(_ level: Int) -> Int {
        // Formula: Level 1 = 0, each level requires progressively more XP
        // Base: 100 XP for level 2, scaling by 1.15x per level
        guard level > 1 else { return 0 }
        var totalXP = 0
        for l in 2...level {
            let xpForLevel = Int(100 * pow(1.15, Double(l - 2)))
            totalXP += xpForLevel
        }
        return totalXP
    }

    /// Calculate level from total XP
    static func level(forTotalXP xp: Int) -> Int {
        var level = 1
        var xpNeeded = 0
        while true {
            let nextLevelXP = Int(100 * pow(1.15, Double(level - 1)))
            if xpNeeded + nextLevelXP > xp {
                break
            }
            xpNeeded += nextLevelXP
            level += 1
        }
        return level
    }

    // MARK: - XP & Progression Methods

    /// Add XP and check for level/rank ups
    func addXP(_ amount: Int) -> (leveledUp: Bool, rankedUp: Bool, newLevel: Int?, newRank: HunterRank?) {
        let previousLevel = currentLevel
        let previousRank = rank

        currentXP += amount
        totalXP += amount

        // Check for level up
        let newLevel = PlayerProfile.level(forTotalXP: totalXP)
        let leveledUp = newLevel > previousLevel
        if leveledUp {
            currentLevel = newLevel
        }

        // Check for rank up
        let newRank = HunterRank.rank(forTotalXP: totalXP)
        let rankedUp = newRank > previousRank
        if rankedUp {
            rank = newRank
        }

        return (
            leveledUp: leveledUp,
            rankedUp: rankedUp,
            newLevel: leveledUp ? newLevel : nil,
            newRank: rankedUp ? newRank : nil
        )
    }

    // MARK: - Stats Calculation

    /// Calculate initial stats based on onboarding data
    func calculateInitialStats() {
        let baseMultiplier = fitnessLevel.baseStatMultiplier
        let activityBonus: Double = {
            switch activityLevel {
            case .sedentary: return 0.0
            case .lightlyActive: return 0.05
            case .moderatelyActive: return 0.1
            case .veryActive: return 0.15
            }
        }()

        let baseValue = Int((baseMultiplier + activityBonus) * 100)

        // Slight variations based on focus areas
        strength = min(max(baseValue + (focusAreas.contains(.chest) || focusAreas.contains(.arms) ? 5 : 0), 5), 50)
        vitality = min(max(baseValue + (focusAreas.contains(.fullBody) ? 5 : 0), 5), 50)
        agility = min(max(baseValue + (focusAreas.contains(.legs) ? 5 : 0), 5), 50)
        recovery = min(max(baseValue, 5), 50)
    }

    /// Calculate potential stats (what they could achieve in 90 days)
    func calculatePotentialStats() {
        // Potential is always significantly higher than current
        potentialStrength = min(strength + 40, 95)
        potentialVitality = min(vitality + 40, 95)
        potentialAgility = min(agility + 40, 95)
        potentialRecovery = min(recovery + 40, 95)
    }
}

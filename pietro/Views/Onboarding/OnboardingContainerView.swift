//
//  OnboardingContainerView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI
import SwiftData

enum OnboardingStep: Int, CaseIterable {
    case awakening = 0
    case gender
    case goal
    case motivation
    case focusAreas
    case fitnessLevel
    case activityLevel
    case age
    case height
    case weight
    case equipment
    case workoutFrequency
    case statsReveal
    case potentialStats
    case rankProjection
    case commitment
    case lockIn
}

struct OnboardingContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [PlayerProfile]

    @State private var currentStep: OnboardingStep = .awakening
    @State private var profile: PlayerProfile

    // Collected data
    @State private var selectedGender: Gender?
    @State private var selectedGoal: FitnessGoal?
    @State private var selectedMotivations: Set<String> = []
    @State private var selectedFocusAreas: Set<FocusArea> = []
    @State private var selectedFitnessLevel: FitnessLevel?
    @State private var selectedActivityLevel: ActivityLevel?
    @State private var selectedEquipment: Set<EquipmentType> = []
    @State private var selectedWorkoutDays: Set<Int> = []
    @State private var weeklyGoal: Int = 3
    @State private var age: Int = 25
    @State private var heightCm: Int = 170
    @State private var weightKg: Int = 70

    let onComplete: () -> Void

    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        self._profile = State(initialValue: PlayerProfile())
    }

    var body: some View {
        VStack(spacing: 0) {
            // Progress bar (hidden on awakening)
            if currentStep != .awakening {
                OnboardingProgress(
                    current: currentStep.rawValue,
                    total: OnboardingStep.allCases.count - 1
                )
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }

            // Content
            TabView(selection: $currentStep) {
                AwakeningView(onContinue: nextStep)
                    .tag(OnboardingStep.awakening)

                GenderSelectionView(selected: $selectedGender, onContinue: nextStep)
                    .tag(OnboardingStep.gender)

                GoalSelectionView(selected: $selectedGoal, onContinue: nextStep)
                    .tag(OnboardingStep.goal)

                MotivationSelectionView(selected: $selectedMotivations, onContinue: nextStep)
                    .tag(OnboardingStep.motivation)

                FocusAreasView(selected: $selectedFocusAreas, onContinue: nextStep)
                    .tag(OnboardingStep.focusAreas)

                FitnessLevelView(selected: $selectedFitnessLevel, onContinue: nextStep)
                    .tag(OnboardingStep.fitnessLevel)

                ActivityLevelView(selected: $selectedActivityLevel, onContinue: nextStep)
                    .tag(OnboardingStep.activityLevel)

                AgePickerView(age: $age, onContinue: nextStep)
                    .tag(OnboardingStep.age)

                HeightPickerView(heightCm: $heightCm, onContinue: nextStep)
                    .tag(OnboardingStep.height)

                WeightPickerView(weightKg: $weightKg, onContinue: nextStep)
                    .tag(OnboardingStep.weight)

                EquipmentAccessView(selected: $selectedEquipment, onContinue: nextStep)
                    .tag(OnboardingStep.equipment)

                WorkoutFrequencyView(
                    selectedDays: $selectedWorkoutDays,
                    weeklyGoal: $weeklyGoal,
                    onContinue: { calculateStats(); nextStep() }
                )
                .tag(OnboardingStep.workoutFrequency)

                StatsRevealView(profile: profile, onContinue: nextStep)
                    .tag(OnboardingStep.statsReveal)

                PotentialStatsView(profile: profile, onContinue: nextStep)
                    .tag(OnboardingStep.potentialStats)

                RankProjectionView(onContinue: nextStep)
                    .tag(OnboardingStep.rankProjection)

                CommitmentView(onContinue: nextStep)
                    .tag(OnboardingStep.commitment)

                LockInView(profile: profile, onComplete: completeOnboarding)
                    .tag(OnboardingStep.lockIn)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: currentStep)
        }
        .background(Color.theme.background)
        .ignoresSafeArea(.container, edges: .bottom)
    }

    private func nextStep() {
        guard let nextIndex = OnboardingStep(rawValue: currentStep.rawValue + 1) else { return }
        withAnimation {
            currentStep = nextIndex
        }
    }

    private func calculateStats() {
        // Update profile with collected data
        profile.gender = selectedGender
        profile.goal = selectedGoal ?? .stayInShape
        profile.motivations = Array(selectedMotivations)
        profile.focusAreas = Array(selectedFocusAreas)
        profile.fitnessLevel = selectedFitnessLevel ?? .beginner
        profile.activityLevel = selectedActivityLevel ?? .sedentary
        profile.equipment = Array(selectedEquipment)
        profile.workoutDays = Array(selectedWorkoutDays).sorted()
        profile.weeklyGoal = weeklyGoal

        // Calculate age from years
        let calendar = Calendar.current
        if let birthDate = calendar.date(byAdding: .year, value: -age, to: Date()) {
            profile.birthDate = birthDate
        }

        profile.heightCm = Double(heightCm)
        profile.weightKg = Double(weightKg)

        // Calculate initial stats
        profile.calculateInitialStats()
        profile.calculatePotentialStats()
    }

    private func completeOnboarding() {
        profile.hasCompletedOnboarding = true
        profile.onboardingCompletedAt = Date()

        // Save to SwiftData
        modelContext.insert(profile)

        onComplete()
    }
}

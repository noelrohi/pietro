//
//  ContentView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [Workout]
    @Query private var profiles: [PlayerProfile]

    @State private var selectedTab: Int = 0
    @State private var hasSeededData = false
    @State private var showOnboarding = false

    private var hasCompletedOnboarding: Bool {
        profiles.first?.hasCompletedOnboarding ?? false
    }

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                mainAppView
            } else {
                OnboardingContainerView {
                    // Onboarding complete - view will refresh automatically
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var mainAppView: some View {
        TabView(selection: $selectedTab) {
            Tab("Today", systemImage: "sun.max.fill", value: 0) {
                TodayView()
            }

            Tab("Library", systemImage: "square.grid.2x2.fill", value: 1) {
                LibraryView()
            }

            Tab("Achievements", systemImage: "trophy.fill", value: 2) {
                AchievementsView()
            }

            Tab("Progress", systemImage: "chart.bar.fill", value: 3) {
                ProgressView()
            }
        }
        .background {
            Color.theme.background
            GrainOverlay()
        }
        .onAppear {
            seedDataIfNeeded()
        }
    }

    private func seedDataIfNeeded() {
        guard workouts.isEmpty && !hasSeededData else { return }
        hasSeededData = true

        // Create Push workouts
        let pushDay = Workout(name: "Push Day", category: .push, durationMinutes: 12, isFeatured: true)
        let chestFocus = Workout(name: "Chest Focus", category: .push, durationMinutes: 18)
        let shoulders = Workout(name: "Shoulders", category: .push, durationMinutes: 15)

        // Create Core workouts
        let coreBlast = Workout(name: "Core Blast", category: .core, durationMinutes: 10)
        let absBurn = Workout(name: "Abs Burn", category: .core, durationMinutes: 8)
        let plankParty = Workout(name: "Plank Party", category: .core, durationMinutes: 12)
        let coreStrength = Workout(name: "Core Strength", category: .core, durationMinutes: 15)

        // Create Pull workouts
        let pullDay = Workout(name: "Pull Day", category: .pull, durationMinutes: 15)
        let backBuilder = Workout(name: "Back Builder", category: .pull, durationMinutes: 20)

        // Insert all workouts
        let allWorkouts = [pushDay, chestFocus, shoulders, coreBlast, absBurn, plankParty, coreStrength, pullDay, backBuilder]
        for workout in allWorkouts {
            modelContext.insert(workout)
        }

        // Add exercises to Push Day
        let pushExercises = [
            Exercise(name: "Push-ups", sets: 3, durationSeconds: 30, order: 0),
            Exercise(name: "Wide Push-ups", sets: 3, durationSeconds: 30, order: 1),
            Exercise(name: "Diamond Push-ups", sets: 3, durationSeconds: 25, order: 2),
            Exercise(name: "Pike Push-ups", sets: 3, durationSeconds: 25, order: 3),
            Exercise(name: "Decline Push-ups", sets: 3, durationSeconds: 30, order: 4),
        ]
        for exercise in pushExercises {
            exercise.workout = pushDay
            modelContext.insert(exercise)
        }

        // Add exercises to Chest Focus
        let chestExercises = [
            Exercise(name: "Standard Push-ups", sets: 4, durationSeconds: 30, order: 0),
            Exercise(name: "Wide Push-ups", sets: 4, durationSeconds: 30, order: 1),
            Exercise(name: "Archer Push-ups", sets: 3, durationSeconds: 25, order: 2),
            Exercise(name: "Incline Push-ups", sets: 3, durationSeconds: 30, order: 3),
            Exercise(name: "Decline Push-ups", sets: 3, durationSeconds: 30, order: 4),
            Exercise(name: "Explosive Push-ups", sets: 3, durationSeconds: 20, order: 5),
        ]
        for exercise in chestExercises {
            exercise.workout = chestFocus
            modelContext.insert(exercise)
        }

        // Add exercises to Core Blast
        let coreExercises = [
            Exercise(name: "Crunches", sets: 3, durationSeconds: 30, order: 0),
            Exercise(name: "Leg Raises", sets: 3, durationSeconds: 30, order: 1),
            Exercise(name: "Plank", sets: 3, durationSeconds: 45, order: 2),
            Exercise(name: "Mountain Climbers", sets: 3, durationSeconds: 30, order: 3),
            Exercise(name: "Russian Twists", sets: 3, durationSeconds: 30, order: 4),
            Exercise(name: "Bicycle Crunches", sets: 3, durationSeconds: 30, order: 5),
        ]
        for exercise in coreExercises {
            exercise.workout = coreBlast
            modelContext.insert(exercise)
        }

        // Add exercises to Pull Day
        let pullExercises = [
            Exercise(name: "Australian Pull-ups", sets: 3, durationSeconds: 30, order: 0),
            Exercise(name: "Superman Hold", sets: 3, durationSeconds: 30, order: 1),
            Exercise(name: "Reverse Snow Angels", sets: 3, durationSeconds: 30, order: 2),
            Exercise(name: "Door Frame Rows", sets: 3, durationSeconds: 30, order: 3),
            Exercise(name: "Prone Y Raises", sets: 3, durationSeconds: 25, order: 4),
        ]
        for exercise in pullExercises {
            exercise.workout = pullDay
            modelContext.insert(exercise)
        }

        // Add some completed workouts for demo
        let calendar = Calendar.current
        let today = Date()

        // Monday
        if let monday = calendar.date(byAdding: .day, value: -4, to: today) {
            let completed = CompletedWorkout(workoutName: "Push Day", category: .push, durationMinutes: 12, completedAt: monday)
            modelContext.insert(completed)
        }

        // Wednesday
        if let wednesday = calendar.date(byAdding: .day, value: -2, to: today) {
            let completed = CompletedWorkout(workoutName: "Core Blast", category: .core, durationMinutes: 10, completedAt: wednesday)
            modelContext.insert(completed)
        }

        // Thursday
        if let thursday = calendar.date(byAdding: .day, value: -1, to: today) {
            let completed = CompletedWorkout(workoutName: "Push Day", category: .push, durationMinutes: 12, completedAt: thursday)
            modelContext.insert(completed)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Workout.self, Exercise.self, CompletedWorkout.self, PlayerProfile.self, XPEvent.self, Quest.self, Achievement.self], inMemory: true)
}

//
//  TodayView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workout.createdAt) private var workouts: [Workout]
    @Query(sort: \CompletedWorkout.completedAt, order: .reverse) private var completedWorkouts: [CompletedWorkout]
    @Query private var profiles: [PlayerProfile]
    @Query(sort: \Quest.createdAt) private var quests: [Quest]
    @Query(sort: \Achievement.key) private var achievements: [Achievement]

    // XP System State
    @State private var xpService: XPService?
    @State private var showXPToast = false
    @State private var pendingXPResult: XPAwardResult?
    @State private var showLevelUp = false
    @State private var levelUpLevel: Int?
    @State private var showRankUp = false
    @State private var rankUpRank: HunterRank?

    // Quest & Achievement State
    @State private var questService: QuestService?
    @State private var achievementService: AchievementService?
    @State private var showQuestToast = false
    @State private var pendingQuestCompletions: [QuestCompletionResult] = []
    @State private var showAchievementOverlay = false
    @State private var pendingAchievementUnlocks: [AchievementUnlockResult] = []
    @State private var currentAchievementUnlock: Achievement?

    private var playerProfile: PlayerProfile? {
        profiles.first
    }

    private var todayWorkout: Workout? {
        workouts.first { $0.isFeatured }
    }

    private var stats: UserStats {
        UserStats(completedWorkouts: completedWorkouts)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Morning"
        case 12..<17: return "Afternoon"
        case 17..<21: return "Evening"
        default: return "Night"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {
                        // Player XP Header
                        if let profile = playerProfile {
                            PlayerHeaderCompact(profile: profile)
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
                        }

                        // Hero Section
                        heroSection

                        // Daily Quests
                        QuestsSection(quests: quests)
                            .padding(.top, 24)

                        // Bento Stats Grid
                        bentoStatsGrid
                            .padding(.horizontal, 20)
                            .padding(.top, 24)

                        // Exercises
                        exercisesSection
                            .padding(.top, 32)
                    }
                    .padding(.bottom, 100)
                }
                .background(Color.theme.background)

                // XP Toast Overlay
                if showXPToast, let result = pendingXPResult {
                    XPGainToast(result: result) {
                        showXPToast = false
                        pendingXPResult = nil

                        // Show level up after XP toast dismisses
                        if levelUpLevel != nil {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showLevelUp = true
                            }
                        } else if rankUpRank != nil {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showRankUp = true
                            }
                        } else {
                            // No level/rank up, go to quests
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showNextQuestToast()
                            }
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(10)
                }

                // Level Up Overlay
                if showLevelUp, let level = levelUpLevel {
                    LevelUpOverlayView(newLevel: level) {
                        showLevelUp = false
                        levelUpLevel = nil

                        // Show rank up after level up dismisses, or quests
                        if rankUpRank != nil {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showRankUp = true
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showNextQuestToast()
                            }
                        }
                    }
                    .transition(.opacity)
                    .zIndex(20)
                }

                // Rank Up Overlay
                if showRankUp, let rank = rankUpRank {
                    RankUpOverlayView(newRank: rank) {
                        showRankUp = false
                        rankUpRank = nil

                        // Show quest completions after rank up
                        showNextQuestToast()
                    }
                    .transition(.opacity)
                    .zIndex(30)
                }

                // Quest Complete Toast
                if showQuestToast, let completion = pendingQuestCompletions.first {
                    QuestCompleteToast(
                        quest: completion.quest,
                        xpAwarded: completion.xpAwarded
                    ) {
                        showQuestToast = false
                        pendingQuestCompletions.removeFirst()

                        // Show next quest or achievement
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            if !pendingQuestCompletions.isEmpty {
                                showQuestToast = true
                            } else {
                                showNextAchievementUnlock()
                            }
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(40)
                }

                // Achievement Unlock Overlay
                if showAchievementOverlay, let achievement = currentAchievementUnlock {
                    AchievementUnlockOverlay(achievement: achievement) {
                        showAchievementOverlay = false
                        currentAchievementUnlock = nil

                        // Show next achievement
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showNextAchievementUnlock()
                        }
                    }
                    .transition(.opacity)
                    .zIndex(50)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(greeting.uppercased())
                        .font(.system(size: 11, weight: .bold))
                        .tracking(2)
                        .foregroundStyle(.secondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Settings
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onAppear {
                if xpService == nil {
                    xpService = XPService(modelContext: modelContext)
                }
                if questService == nil {
                    questService = QuestService(modelContext: modelContext)
                }
                if achievementService == nil {
                    achievementService = AchievementService(modelContext: modelContext)
                }

                // Generate quests if needed
                questService?.generateDailyQuestsIfNeeded(existingQuests: quests)
                questService?.generateWeeklyQuestsIfNeeded(existingQuests: quests)

                // Seed achievements if needed
                achievementService?.seedAchievementsIfNeeded(existingAchievements: achievements)
            }
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: 0) {
            if let workout = todayWorkout {
                VStack(spacing: 16) {
                    // Category badge
                    HStack(spacing: 6) {
                        Image(systemName: workout.category.icon)
                            .font(.system(size: 12, weight: .semibold))
                        Text(workout.category.rawValue.uppercased())
                            .font(.system(size: 11, weight: .bold))
                            .tracking(1.5)
                    }
                    .foregroundStyle(workout.category.categoryColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(workout.category.categoryColor.opacity(0.15))
                    .clipShape(Capsule())

                    // Workout name - dramatic scale
                    Text(workout.name)
                        .font(.system(size: 48, weight: .heavy, design: .default))
                        .tracking(-1)
                        .multilineTextAlignment(.center)

                    // Meta info
                    HStack(spacing: 24) {
                        HStack(spacing: 6) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 13))
                            Text("\(workout.durationMinutes) min")
                                .font(.system(size: 15, weight: .semibold))
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 13))
                            Text("\(workout.exerciseCount) exercises")
                                .font(.system(size: 15, weight: .semibold))
                        }
                    }
                    .foregroundStyle(.secondary)

                    // Start button - liquid glass
                    Button {
                        startWorkout(workout)
                    } label: {
                        HStack(spacing: 12) {
                            Text("Begin")
                                .font(.system(size: 18, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundStyle(Color.theme.primary)
                        .frame(width: 160, height: 56)
                        .background {
                            Capsule()
                                .fill(Color.theme.primary.opacity(0.15))
                        }
                        .glassEffect(.regular.interactive(), in: Capsule())
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 40)
            }
        }
    }

    // MARK: - Bento Stats Grid

    private var bentoStatsGrid: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Weekly Progress - Large card
                weeklyProgressCard

                // Streak - Tall card
                streakCard
            }

            HStack(spacing: 12) {
                // Total workouts
                totalWorkoutsCard

                // Best streak
                bestStreakCard

                // Minutes
                minutesCard
            }
        }
    }

    private var weeklyProgressCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("THIS WEEK")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(1)
                        .foregroundStyle(.secondary)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(stats.workoutsThisWeek)")
                            .font(.system(size: 56, weight: .heavy, design: .rounded))
                        Text("/ \(stats.weeklyGoal)")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.tertiary)
                    }
                }

                Spacer()

                // Mini ring
                ZStack {
                    Circle()
                        .stroke(.quaternary, lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: stats.weeklyProgress)
                        .stroke(
                            Color.theme.primary.gradient,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 44, height: 44)
            }

            Spacer()

            // Week dots
            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { day in
                    Circle()
                        .fill(
                            stats.completedDaysThisWeek.contains(day)
                            ? Color.theme.primary
                            : day == stats.todayDayIndex
                            ? Color.theme.primary.opacity(0.3)
                            : Color.white.opacity(0.1)
                        )
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding(20)
        .frame(height: 160)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }

    private var streakCard: some View {
        VStack(spacing: 8) {
            Spacer()

            // Animated flame
            ZStack {
                // Glow
                Image(systemName: "flame.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.orange.opacity(0.3))
                    .blur(radius: 20)

                Image(systemName: "flame.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .symbolEffect(.bounce.up, options: .repeating.speed(0.3))
            }

            Text("\(stats.currentStreak)")
                .font(.system(size: 36, weight: .heavy, design: .rounded))

            Text("STREAK")
                .font(.system(size: 9, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(.orange.opacity(0.8))

            Spacer()
        }
        .frame(width: 100, height: 160)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [.orange.opacity(0.15), .red.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }

    private var totalWorkoutsCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 16))
                .foregroundStyle(.yellow)

            Spacer()

            Text("\(stats.totalWorkouts)")
                .font(.system(size: 28, weight: .heavy, design: .rounded))

            Text("TOTAL")
                .font(.system(size: 9, weight: .bold))
                .tracking(1)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }

    private var bestStreakCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: "crown.fill")
                .font(.system(size: 16))
                .foregroundStyle(.purple)

            Spacer()

            Text("\(stats.bestStreak)")
                .font(.system(size: 28, weight: .heavy, design: .rounded))

            Text("BEST")
                .font(.system(size: 9, weight: .bold))
                .tracking(1)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }

    private var minutesCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: "clock.fill")
                .font(.system(size: 16))
                .foregroundStyle(.green)

            Spacer()

            Text("\(stats.totalMinutes)")
                .font(.system(size: 28, weight: .heavy, design: .rounded))

            Text("MINS")
                .font(.system(size: 9, weight: .bold))
                .tracking(1)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Exercises Section

    private var exercisesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("Up Next")
                    .font(.system(size: 13, weight: .bold))
                    .tracking(1)
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)

                Spacer()

                if let workout = todayWorkout {
                    Text("\(workout.exerciseCount) exercises")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.horizontal, 20)

            // Exercise cards - horizontal scroll
            if let workout = todayWorkout {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(workout.sortedExercises.enumerated()), id: \.element.id) { index, exercise in
                            ExerciseCard(exercise: exercise, index: index + 1)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }

    private func startWorkout(_ workout: Workout) {
        let completed = CompletedWorkout(workout: workout)
        modelContext.insert(completed)

        // Award XP if we have a profile and XP service
        guard let profile = playerProfile, let service = xpService else { return }

        // Calculate bonuses
        let isFirstOfDay = service.isFirstWorkoutOfDay(completedWorkouts: completedWorkouts)
        let currentStreak = service.calculateCurrentStreak(completedWorkouts: completedWorkouts)
        let didCompleteWeeklyGoal = service.didJustCompleteWeeklyGoal(
            completedWorkouts: completedWorkouts + [completed],
            weeklyGoal: profile.weeklyGoal
        )

        // Award XP
        let result = service.awardXPForWorkout(
            workout: completed,
            profile: profile,
            currentStreak: currentStreak,
            isFirstWorkoutOfDay: isFirstOfDay,
            didCompleteWeeklyGoal: didCompleteWeeklyGoal
        )

        // Store results for overlays
        pendingXPResult = result

        if result.leveledUp {
            levelUpLevel = result.newLevel
        }

        if result.rankedUp {
            rankUpRank = result.newRank
        }

        // Check quest progress
        if let questSvc = questService {
            let questCompletions = questSvc.checkQuestProgress(
                workout: completed,
                profile: profile,
                quests: quests,
                completedWorkouts: completedWorkouts + [completed]
            )
            pendingQuestCompletions = questCompletions
        }

        // Check achievements
        if let achievementSvc = achievementService {
            let achievementUnlocks = achievementSvc.checkAchievements(
                profile: profile,
                completedWorkouts: completedWorkouts + [completed],
                achievements: achievements,
                currentStreak: currentStreak
            )
            pendingAchievementUnlocks = achievementUnlocks
        }

        // Show XP toast
        withAnimation {
            showXPToast = true
        }
    }

    // MARK: - Notification Helpers

    private func showNextQuestToast() {
        if !pendingQuestCompletions.isEmpty {
            withAnimation {
                showQuestToast = true
            }
        } else {
            showNextAchievementUnlock()
        }
    }

    private func showNextAchievementUnlock() {
        if let next = pendingAchievementUnlocks.first {
            pendingAchievementUnlocks.removeFirst()
            currentAchievementUnlock = next.achievement
            withAnimation {
                showAchievementOverlay = true
            }
        }
    }
}

// MARK: - Exercise Card

struct ExerciseCard: View {
    let exercise: Exercise
    let index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Index
            Text("\(index)")
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundStyle(Color.theme.primary.opacity(0.3))

            Spacer()

            // Name
            Text(exercise.name)
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            // Meta
            Text("\(exercise.sets) sets · \(exercise.durationSeconds)s")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(width: 140, height: 140)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    TodayView()
        .modelContainer(previewContainer)
}

// Preview helper
@MainActor
var previewContainer: ModelContainer = {
    let schema = Schema([Workout.self, Exercise.self, CompletedWorkout.self, PlayerProfile.self, XPEvent.self, Quest.self, Achievement.self])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: config)

    // Create player profile
    let profile = PlayerProfile(displayName: "Player")
    profile.hasCompletedOnboarding = true
    profile.currentLevel = 3
    profile.totalXP = 450
    profile.currentXP = 450
    profile.rank = .e
    container.mainContext.insert(profile)

    let pushWorkout = Workout(name: "Push Day", category: .push, durationMinutes: 12, isFeatured: true)

    let exercises = [
        Exercise(name: "Push-ups", sets: 3, durationSeconds: 30, order: 0),
        Exercise(name: "Wide Push-ups", sets: 3, durationSeconds: 30, order: 1),
        Exercise(name: "Diamond Push-ups", sets: 3, durationSeconds: 25, order: 2),
        Exercise(name: "Pike Push-ups", sets: 3, durationSeconds: 25, order: 3),
        Exercise(name: "Decline Push-ups", sets: 3, durationSeconds: 30, order: 4),
    ]

    container.mainContext.insert(pushWorkout)
    for exercise in exercises {
        exercise.workout = pushWorkout
        container.mainContext.insert(exercise)
    }

    let calendar = Calendar.current
    let today = Date()

    for i in 0..<3 {
        if let date = calendar.date(byAdding: .day, value: -i, to: today) {
            let completed = CompletedWorkout(workoutName: "Push Day", category: .push, durationMinutes: 12, completedAt: date)
            container.mainContext.insert(completed)
        }
    }

    // Add sample quests
    let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: today)!
    let dailyQuest1 = Quest.completeWorkouts(count: 1, expiresAt: endOfDay)
    let dailyQuest2 = Quest.categoryWorkout(.push, expiresAt: endOfDay)
    dailyQuest2.currentProgress = 1
    dailyQuest2.isCompleted = true
    let dailyQuest3 = Quest.exerciseCollector(count: 5, expiresAt: endOfDay)
    dailyQuest3.currentProgress = 2

    container.mainContext.insert(dailyQuest1)
    container.mainContext.insert(dailyQuest2)
    container.mainContext.insert(dailyQuest3)

    // Add sample weekly quest
    let endOfWeek = calendar.date(byAdding: .day, value: 5, to: today)!
    let weeklyQuest = Quest.weeklyWorkouts(count: 5, expiresAt: endOfWeek)
    weeklyQuest.currentProgress = 3
    container.mainContext.insert(weeklyQuest)

    // Add sample achievements
    for definition in AchievementDefinition.all {
        let achievement = definition.createAchievement()
        if definition.key == "first_workout" {
            achievement.unlock()
        } else if definition.key == "workouts_10" {
            achievement.progress = 3
        }
        container.mainContext.insert(achievement)
    }

    return container
}()

//
//  AchievementsView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI
import SwiftData

// MARK: - Filter Type

enum AchievementFilter: String, CaseIterable {
    case all = "All"
    case unlocked = "Unlocked"
    case locked = "Locked"
}

// MARK: - Achievements View

struct AchievementsView: View {
    @Query(sort: \Achievement.key) private var achievements: [Achievement]
    @State private var selectedFilter: AchievementFilter = .all
    @State private var selectedCategory: AchievementCategory?

    private var filteredAchievements: [Achievement] {
        var result = achievements

        // Apply filter
        switch selectedFilter {
        case .all:
            break
        case .unlocked:
            result = result.filter { $0.isUnlocked }
        case .locked:
            result = result.filter { !$0.isUnlocked }
        }

        // Apply category filter
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        // Sort: unlocked first, then by progress
        return result.sorted { a, b in
            if a.isUnlocked != b.isUnlocked {
                return a.isUnlocked
            }
            return a.progressPercent > b.progressPercent
        }
    }

    private var stats: (unlocked: Int, total: Int, percent: Double) {
        let unlocked = achievements.filter { $0.isUnlocked }.count
        let total = achievements.count
        let percent = total > 0 ? Double(unlocked) / Double(total) : 0
        return (unlocked, total, percent)
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Stats header
                    statsHeader

                    // Filter pills
                    filterSection

                    // Category filter
                    categoryFilter

                    // Achievement grid
                    achievementGrid
                }
                .padding(.bottom, 100)
            }
            .background(Color.theme.background)
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Stats Header

    private var statsHeader: some View {
        VStack(spacing: 16) {
            // Progress ring
            ZStack {
                Circle()
                    .stroke(Color.theme.muted.opacity(0.2), lineWidth: 8)
                    .frame(width: 100, height: 100)

                Circle()
                    .trim(from: 0, to: stats.percent)
                    .stroke(
                        LinearGradient(
                            colors: [Color.theme.accent, Color.theme.primary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(Int(stats.percent * 100))%")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.theme.foreground)

                    Text("Complete")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color.theme.muted)
                }
            }

            // Count
            Text("\(stats.unlocked) of \(stats.total) achievements")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.theme.muted)
        }
        .padding(.top, 20)
    }

    // MARK: - Filter Section

    private var filterSection: some View {
        HStack(spacing: 8) {
            ForEach(AchievementFilter.allCases, id: \.self) { filter in
                FilterPill(
                    title: filter.rawValue,
                    isSelected: selectedFilter == filter
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedFilter = filter
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Category Filter

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // All categories
                CategoryPill(
                    title: "All",
                    icon: "square.grid.2x2.fill",
                    isSelected: selectedCategory == nil
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedCategory = nil
                    }
                }

                ForEach(AchievementCategory.allCases, id: \.self) { category in
                    CategoryPill(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Achievement Grid

    private var achievementGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(filteredAchievements) { achievement in
                AchievementCard(achievement: achievement)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Filter Pill

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(isSelected ? Color.theme.foreground : Color.theme.muted)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected
                    ? Color.theme.accent.opacity(0.2)
                    : Color.theme.secondary
                )
                .clipShape(Capsule())
                .overlay {
                    if isSelected {
                        Capsule()
                            .stroke(Color.theme.accent.opacity(0.3), lineWidth: 1)
                    }
                }
        }
    }
}

// MARK: - Category Pill

struct CategoryPill: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11))

                Text(title)
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(isSelected ? Color.theme.foreground : Color.theme.muted)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                isSelected
                ? Color.theme.primary.opacity(0.2)
                : Color.theme.secondary
            )
            .clipShape(Capsule())
            .overlay {
                if isSelected {
                    Capsule()
                        .stroke(Color.theme.primary.opacity(0.3), lineWidth: 1)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AchievementsView()
        .modelContainer(for: [Achievement.self], inMemory: true) { result in
            if case .success(let container) = result {
                // Seed some achievements for preview
                for definition in AchievementDefinition.all.prefix(6) {
                    let achievement = definition.createAchievement()
                    if definition.key == "first_workout" {
                        achievement.unlock()
                    } else if definition.key == "workouts_10" {
                        achievement.progress = 6
                    }
                    container.mainContext.insert(achievement)
                }
            }
        }
        .preferredColorScheme(.dark)
}

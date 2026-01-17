//
//  LibraryView.swift
//  pietro
//
//  Ultra-minimal library with restrained design
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workout.createdAt) private var workouts: [Workout]

    @State private var selectedCategory: WorkoutCategory? = nil

    private var featuredWorkout: Workout? {
        workouts.first { $0.isFeatured }
    }

    private var displayedWorkouts: [Workout] {
        guard let category = selectedCategory else { return workouts }
        return workouts.filter { $0.category == category }
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Featured - only when browsing all
                    if selectedCategory == nil, let featured = featuredWorkout {
                        FeaturedCard(workout: featured) {
                            startWorkout(featured)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }

                    // Category filter
                    categoryFilter
                        .padding(.top, selectedCategory == nil && featuredWorkout != nil ? 32 : 8)

                    // Workouts
                    workoutsList
                        .padding(.top, 24)
                }
                .padding(.bottom, 100)
            }
            .background(Color.theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Library")
                        .font(.system(size: 16, weight: .semibold))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Add
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }

    // MARK: - Category Filter

    private var categoryFilter: some View {
        GlassEffectContainer(spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterPill(title: "All", isSelected: selectedCategory == nil) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = nil
                        }
                    }

                    ForEach(WorkoutCategory.allCases, id: \.self) { category in
                        FilterPill(
                            title: category.rawValue,
                            isSelected: selectedCategory == category,
                            accentColor: category.categoryColor
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedCategory = selectedCategory == category ? nil : category
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Workouts List

    private var workoutsList: some View {
        LazyVStack(spacing: 8) {
            ForEach(displayedWorkouts) { workout in
                WorkoutListRow(workout: workout) {
                    startWorkout(workout)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    private func startWorkout(_ workout: Workout) {
        let completed = CompletedWorkout(workout: workout)
        modelContext.insert(completed)
    }
}

// MARK: - Filter Pill

private struct FilterPill: View {
    let title: String
    let isSelected: Bool
    var accentColor: Color = Color.theme.primary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : .secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background {
                    if isSelected {
                        Capsule().fill(accentColor)
                    }
                }
                .modifier(UnselectedGlassModifier(isSelected: isSelected))
        }
        .buttonStyle(.plain)
    }
}

private struct UnselectedGlassModifier: ViewModifier {
    let isSelected: Bool

    func body(content: Content) -> some View {
        if isSelected {
            content
        } else {
            content.glassEffect(.regular.interactive(), in: .capsule)
        }
    }
}

#Preview {
    LibraryView()
        .modelContainer(previewContainer)
}

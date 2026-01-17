//
//  ProgressView.swift
//  pietro
//
//  Ultra-minimal progress with viral shareable card
//

import SwiftUI
import SwiftData

struct ProgressView: View {
    @Query(sort: \CompletedWorkout.completedAt, order: .reverse) private var completedWorkouts: [CompletedWorkout]

    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?

    private var stats: UserStats {
        UserStats(completedWorkouts: completedWorkouts)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Shareable Card Hero
                    ShareCardView(stats: stats) {
                        shareProgress()
                    }
                    .padding(.top, 20)

                    // This Week
                    weekSection
                        .padding(.horizontal, 20)
                        .padding(.top, 48)

                    // Milestones
                    milestonesSection
                        .padding(.horizontal, 20)
                        .padding(.top, 40)

                    // Recent
                    recentSection
                        .padding(.horizontal, 20)
                        .padding(.top, 40)
                }
                .padding(.bottom, 100)
            }
            .background(Color.theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Progress")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let image = shareImage {
                    ShareSheet(items: [image])
                }
            }
        }
    }

    // MARK: - Week Section

    private var weekSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionLabel(title: "This Week")

            WeekDots(
                completedDays: stats.completedDaysThisWeek,
                todayIndex: stats.todayDayIndex
            )
        }
    }

    // MARK: - Milestones Section

    private var milestonesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(title: "Milestones")

            GlassEffectContainer(spacing: 12) {
                VStack(spacing: 12) {
                    MilestoneBar(
                        title: "First Workout",
                        current: stats.totalWorkouts,
                        target: 1,
                        color: Color.theme.primary
                    )

                    MilestoneBar(
                        title: "7-Day Streak",
                        current: stats.bestStreak,
                        target: 7,
                        color: .orange
                    )

                    MilestoneBar(
                        title: "25 Workouts",
                        current: stats.totalWorkouts,
                        target: 25,
                        color: .yellow
                    )

                    MilestoneBar(
                        title: "Century",
                        current: stats.totalWorkouts,
                        target: 100,
                        color: .purple
                    )
                }
            }
        }
    }

    // MARK: - Recent Section

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(title: "Recent")

            if completedWorkouts.isEmpty {
                EmptyState(
                    icon: "figure.run",
                    title: "No workouts yet",
                    subtitle: "Complete a workout to see your history"
                )
            } else {
                VStack(spacing: 0) {
                    ForEach(completedWorkouts.prefix(5)) { workout in
                        ActivityItem(workout: workout)

                        if workout.id != completedWorkouts.prefix(5).last?.id {
                            Divider()
                                .padding(.leading, 18)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .glassEffect(.regular, in: .rect(cornerRadius: 16))
            }
        }
    }

    // MARK: - Share

    private func shareProgress() {
        let cardView = ShareableCardForExport(stats: stats)
        if let image = cardView.renderAsImage() {
            shareImage = image
            showingShareSheet = true
        }
    }
}

// MARK: - Section Label

private struct SectionLabel: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 11, weight: .semibold))
            .tracking(1.5)
            .foregroundStyle(.tertiary)
    }
}

// MARK: - Exportable Card (for image rendering)

private struct ShareableCardForExport: View {
    let stats: UserStats

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("PIETRO")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(3)
                    .foregroundStyle(.white.opacity(0.5))
                Spacer()
            }
            .padding(.top, 24)

            Spacer()

            VStack(spacing: 12) {
                Text("\(stats.totalWorkouts)")
                    .font(.system(size: 96, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("WORKOUTS")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(4)
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()

            HStack(spacing: 0) {
                ExportStatItem(value: "\(stats.currentStreak)", label: "STREAK")

                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 1, height: 32)

                ExportStatItem(value: "\(stats.totalMinutes)", label: "MINUTES")

                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 1, height: 32)

                ExportStatItem(value: "\(stats.bestStreak)", label: "BEST")
            }
            .padding(.bottom, 32)
        }
        .frame(width: 280, height: 400)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.12),
                    Color(red: 0.05, green: 0.05, blue: 0.07)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 32))
    }
}

private struct ExportStatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(label)
                .font(.system(size: 8, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProgressView()
        .modelContainer(previewContainer)
}

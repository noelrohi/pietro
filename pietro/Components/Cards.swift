//
//  Cards.swift
//  pietro
//
//  Minimal card components with restrained glass effects
//

import SwiftUI

// MARK: - Minimal Workout Card

struct MinimalWorkoutCard: View {
    let workout: Workout
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 20) {
                // Category indicator - just a subtle line
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(workout.category.categoryColor)
                        .frame(width: 16, height: 2)

                    Text(workout.category.rawValue.uppercased())
                        .font(.system(size: 10, weight: .medium))
                        .tracking(1.5)
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                // Workout name - typography as design
                Text(workout.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)

                // Duration - understated
                Text("\(workout.durationMinutes) min")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            .padding(20)
            .frame(width: 160, height: 160)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - List Workout Row

struct WorkoutListRow: View {
    let workout: Workout
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Category line
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(workout.category.categoryColor)
                    .frame(width: 3, height: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.primary)

                    Text("\(workout.durationMinutes) min · \(workout.exerciseCount) exercises")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.quaternary)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Featured Card (Minimal)

struct FeaturedCard: View {
    let workout: Workout
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    // Label
                    Text("TODAY")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(2)
                        .foregroundStyle(.secondary)

                    // Workout name
                    Text(workout.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.primary)

                    // Meta
                    Text("\(workout.durationMinutes) min")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Play button - minimal
                Circle()
                    .fill(workout.category.categoryColor)
                    .frame(width: 48, height: 48)
                    .overlay {
                        Image(systemName: "play.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .offset(x: 2)
                    }
            }
            .padding(24)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 24))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Empty State

struct EmptyState: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32, weight: .light))
                .foregroundStyle(.tertiary)

            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)

                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

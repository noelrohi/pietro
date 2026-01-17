//
//  Stats.swift
//  pietro
//
//  Minimal stat display components
//

import SwiftUI

// MARK: - Hero Number

struct HeroNumber: View {
    let value: String
    let label: String
    let size: CGFloat

    init(_ value: String, label: String, size: CGFloat = 72) {
        self.value = value
        self.label = label
        self.size = size
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: size, weight: .bold, design: .rounded))
                .tracking(-2)

            Text(label.uppercased())
                .font(.system(size: 11, weight: .medium))
                .tracking(2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Stat Row

struct StatRow: View {
    let items: [(value: String, label: String)]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                if index > 0 {
                    Rectangle()
                        .fill(.quaternary)
                        .frame(width: 1, height: 32)
                }

                VStack(spacing: 4) {
                    Text(item.value)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))

                    Text(item.label.uppercased())
                        .font(.system(size: 9, weight: .medium))
                        .tracking(1)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 20)
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
    }
}

// MARK: - Minimal Progress Ring

struct MinimalRing: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat

    init(progress: Double, size: CGFloat = 64, lineWidth: CGFloat = 4) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(.quaternary, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(
                    Color.theme.primary,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Week Dots

struct WeekDots: View {
    let completedDays: Set<Int>
    let todayIndex: Int

    private let days = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<7, id: \.self) { index in
                VStack(spacing: 8) {
                    Text(days[index])
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.tertiary)

                    Circle()
                        .fill(dotColor(for: index))
                        .frame(width: 8, height: 8)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 20)
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
    }

    private func dotColor(for index: Int) -> Color {
        if completedDays.contains(index) {
            return Color.theme.primary
        } else if index == todayIndex {
            return Color.theme.primary.opacity(0.3)
        } else {
            return Color.gray.opacity(0.2)
        }
    }
}

// MARK: - Milestone Bar

struct MilestoneBar: View {
    let title: String
    let current: Int
    let target: Int
    let color: Color

    private var progress: Double {
        min(Double(current) / Double(target), 1.0)
    }

    private var isComplete: Bool {
        current >= target
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(isComplete ? .primary : .secondary)

                Spacer()

                if isComplete {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(color)
                } else {
                    Text("\(current)/\(target)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.tertiary)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.quaternary)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(isComplete ? color : color.opacity(0.5))
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 3)
        }
        .padding(16)
        .glassEffect(.regular, in: .rect(cornerRadius: 14))
    }
}

// MARK: - Activity Item

struct ActivityItem: View {
    let workout: CompletedWorkout

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(workout.category.categoryColor)
                .frame(width: 6, height: 6)

            Text(workout.workoutName)
                .font(.system(size: 14, weight: .medium))

            Spacer()

            Text(workout.dayLabel)
                .font(.system(size: 12))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 12)
    }
}

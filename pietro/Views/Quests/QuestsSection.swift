//
//  QuestsSection.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct QuestsSection: View {
    let quests: [Quest]

    private var dailyQuests: [Quest] {
        quests.filter { $0.type == .daily && !$0.isExpired }
    }

    private var weeklyQuests: [Quest] {
        quests.filter { $0.type == .weekly && !$0.isExpired }
    }

    private var completedCount: Int {
        dailyQuests.filter { $0.isCompleted }.count
    }

    private var totalCount: Int {
        dailyQuests.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "scroll.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.theme.accent)

                    Text("DAILY QUESTS")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(1.5)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Completion count
                if totalCount > 0 {
                    Text("\(completedCount)/\(totalCount)")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundStyle(completedCount == totalCount ? Color.theme.success : Color.theme.muted)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            completedCount == totalCount
                            ? Color.theme.success.opacity(0.15)
                            : Color.theme.secondary
                        )
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 20)

            // Quest cards - horizontal scroll
            if dailyQuests.isEmpty {
                emptyState
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(dailyQuests) { quest in
                            QuestCard(quest: quest)
                        }

                        // Show weekly quests if there's room
                        if !weeklyQuests.isEmpty {
                            // Divider
                            Rectangle()
                                .fill(Color.theme.border)
                                .frame(width: 1, height: 100)
                                .padding(.horizontal, 8)

                            ForEach(weeklyQuests) { quest in
                                WeeklyQuestCard(quest: quest)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }

    private var emptyState: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "scroll")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.theme.muted)

                Text("New quests tomorrow")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.theme.muted)
            }
            .padding(.vertical, 40)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Weekly Quest Card

struct WeeklyQuestCard: View {
    let quest: Quest

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Badge
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 10))
                    Text("WEEKLY")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(1)
                }
                .foregroundStyle(Color.theme.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.theme.primary.opacity(0.15))
                .clipShape(Capsule())

                Spacer()

                if quest.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.theme.success)
                } else {
                    Text("+\(quest.xpReward)")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.theme.primary)
                }
            }

            Spacer()

            // Title
            Text(quest.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(quest.isCompleted ? Color.theme.muted : Color.theme.foreground)
                .lineLimit(2)

            // Progress
            if quest.isCompleted {
                Text("Completed")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color.theme.success)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.1))

                            RoundedRectangle(cornerRadius: 3)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.theme.primary, Color.theme.primary.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * quest.progress)
                        }
                    }
                    .frame(height: 6)

                    HStack {
                        Text(quest.progressText)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(Color.theme.muted)

                        Spacer()

                        Text(quest.timeRemaining)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(Color.theme.muted)
                    }
                }
            }
        }
        .padding(14)
        .frame(width: 160, height: 140)
        .background {
            if quest.isCompleted {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.theme.success.opacity(0.1))
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.theme.primary.opacity(0.05))
            }
        }
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
        .overlay {
            if quest.isCompleted {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.theme.success.opacity(0.3), lineWidth: 1)
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.theme.primary.opacity(0.2), lineWidth: 1)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        QuestsSection(quests: [
            Quest.completeWorkouts(count: 1, expiresAt: Date().addingTimeInterval(86400)),
            {
                let q = Quest.categoryWorkout(.push, expiresAt: Date().addingTimeInterval(86400))
                q.currentProgress = 1
                q.isCompleted = true
                return q
            }(),
            {
                let q = Quest.exerciseCollector(count: 5, expiresAt: Date().addingTimeInterval(86400))
                q.currentProgress = 2
                return q
            }(),
            {
                let q = Quest.weeklyWorkouts(count: 5, expiresAt: Date().addingTimeInterval(86400 * 5))
                q.currentProgress = 2
                return q
            }()
        ])
    }
    .background(Color.theme.background)
    .preferredColorScheme(.dark)
}

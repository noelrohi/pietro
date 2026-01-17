//
//  QuestCard.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct QuestCard: View {
    let quest: Quest

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon and type badge
            HStack {
                // Quest icon
                ZStack {
                    Circle()
                        .fill(iconBackgroundColor.opacity(0.2))
                        .frame(width: 36, height: 36)

                    Image(systemName: quest.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(iconColor)
                }

                Spacer()

                // Completed checkmark or XP badge
                if quest.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.theme.success)
                } else {
                    Text("+\(quest.xpReward)")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.theme.accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.theme.accent.opacity(0.15))
                        .clipShape(Capsule())
                }
            }

            Spacer()

            // Quest title
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
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.1))

                            RoundedRectangle(cornerRadius: 3)
                                .fill(progressGradient)
                                .frame(width: geometry.size.width * quest.progress)
                        }
                    }
                    .frame(height: 6)

                    // Progress text
                    Text(quest.progressText)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color.theme.muted)
                }
            }
        }
        .padding(14)
        .frame(width: 140, height: 140)
        .background {
            if quest.isCompleted {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.theme.success.opacity(0.1))
            }
        }
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
        .overlay {
            if quest.isCompleted {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.theme.success.opacity(0.3), lineWidth: 1)
            }
        }
    }

    private var iconColor: Color {
        if let category = quest.category {
            return category.categoryColor
        }
        return quest.type == .daily ? Color.theme.accent : Color.theme.primary
    }

    private var iconBackgroundColor: Color {
        iconColor
    }

    private var progressGradient: LinearGradient {
        if let category = quest.category {
            return LinearGradient(
                colors: [category.categoryColor, category.categoryColor.opacity(0.7)],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
        return LinearGradient(
            colors: [Color.theme.accent, Color.theme.accent.opacity(0.7)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 12) {
        QuestCard(quest: {
            let quest = Quest.completeWorkouts(count: 1, expiresAt: Date().addingTimeInterval(86400))
            return quest
        }())

        QuestCard(quest: {
            let quest = Quest.categoryWorkout(.push, expiresAt: Date().addingTimeInterval(86400))
            quest.currentProgress = 1
            quest.isCompleted = true
            return quest
        }())

        QuestCard(quest: {
            let quest = Quest.exerciseCollector(count: 5, expiresAt: Date().addingTimeInterval(86400))
            quest.currentProgress = 2
            return quest
        }())
    }
    .padding()
    .background(Color.theme.background)
    .preferredColorScheme(.dark)
}

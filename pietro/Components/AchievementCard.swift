//
//  AchievementCard.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct AchievementCard: View {
    let achievement: Achievement
    var showProgress: Bool = true

    var body: some View {
        VStack(spacing: 12) {
            // Icon
            ZStack {
                // Glow for unlocked gold achievements
                if achievement.isUnlocked && achievement.tier.hasGlow {
                    Circle()
                        .fill(achievement.tier.color.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .blur(radius: 15)
                }

                Circle()
                    .fill(
                        achievement.isUnlocked
                        ? achievement.tier.color.opacity(0.2)
                        : Color.theme.muted.opacity(0.1)
                    )
                    .frame(width: 56, height: 56)

                Circle()
                    .stroke(
                        achievement.isUnlocked
                        ? achievement.tier.gradient
                        : LinearGradient(colors: [Color.theme.muted.opacity(0.3)], startPoint: .top, endPoint: .bottom),
                        lineWidth: 2
                    )
                    .frame(width: 56, height: 56)

                Image(systemName: achievement.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(
                        achievement.isUnlocked
                        ? achievement.tier.color
                        : Color.theme.muted.opacity(0.5)
                    )
            }

            // Title
            Text(achievement.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(
                    achievement.isUnlocked
                    ? Color.theme.foreground
                    : Color.theme.muted
                )
                .multilineTextAlignment(.center)
                .lineLimit(2)

            // Progress or unlocked state
            if achievement.isUnlocked {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 10))
                    Text("Unlocked")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundStyle(achievement.tier.color)
            } else if showProgress {
                // Progress bar
                VStack(spacing: 4) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.white.opacity(0.1))

                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.theme.muted.opacity(0.5))
                                .frame(width: geometry.size.width * achievement.progressPercent)
                        }
                    }
                    .frame(height: 4)
                    .frame(maxWidth: 60)

                    Text(achievement.progressText)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(Color.theme.muted)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background {
            if achievement.isUnlocked {
                RoundedRectangle(cornerRadius: 16)
                    .fill(achievement.tier.color.opacity(0.05))
            }
        }
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    achievement.isUnlocked
                    ? achievement.tier.color.opacity(0.3)
                    : Color.theme.border,
                    lineWidth: 1
                )
        }
        .opacity(achievement.isUnlocked ? 1 : 0.7)
    }
}

// MARK: - Compact Achievement Card (for horizontal lists)

struct CompactAchievementCard: View {
    let achievement: Achievement

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        achievement.isUnlocked
                        ? achievement.tier.color.opacity(0.2)
                        : Color.theme.muted.opacity(0.1)
                    )
                    .frame(width: 44, height: 44)

                Image(systemName: achievement.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(
                        achievement.isUnlocked
                        ? achievement.tier.color
                        : Color.theme.muted.opacity(0.5)
                    )
            }

            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(achievement.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(
                        achievement.isUnlocked
                        ? Color.theme.foreground
                        : Color.theme.muted
                    )

                if achievement.isUnlocked {
                    HStack(spacing: 4) {
                        Text(achievement.tier.rawValue)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(achievement.tier.color)

                        Text("•")
                            .foregroundStyle(Color.theme.muted)

                        Text("+\(achievement.xpReward) XP")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color.theme.muted)
                    }
                } else {
                    Text(achievement.progressText)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color.theme.muted)
                }
            }

            Spacer()

            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(achievement.tier.color)
            } else {
                // Progress ring
                ZStack {
                    Circle()
                        .stroke(Color.theme.muted.opacity(0.2), lineWidth: 3)
                        .frame(width: 28, height: 28)

                    Circle()
                        .trim(from: 0, to: achievement.progressPercent)
                        .stroke(Color.theme.muted.opacity(0.5), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 28, height: 28)
                        .rotationEffect(.degrees(-90))
                }
            }
        }
        .padding(12)
        .background(Color.theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    achievement.isUnlocked
                    ? achievement.tier.color.opacity(0.2)
                    : Color.theme.border,
                    lineWidth: 1
                )
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            AchievementCard(achievement: {
                let a = Achievement(
                    key: "first_workout",
                    title: "First Blood",
                    descriptionText: "Complete your first workout",
                    tier: .bronze,
                    category: .workout,
                    icon: "bolt.fill",
                    targetProgress: 1
                )
                a.unlock()
                return a
            }())

            AchievementCard(achievement: {
                let a = Achievement(
                    key: "streak_7",
                    title: "Week Warrior",
                    descriptionText: "Maintain a 7-day streak",
                    tier: .silver,
                    category: .streak,
                    icon: "flame.fill",
                    targetProgress: 7
                )
                a.progress = 4
                return a
            }())

            AchievementCard(achievement: {
                let a = Achievement(
                    key: "rank_s",
                    title: "Shadow Monarch",
                    descriptionText: "Reach Rank S",
                    tier: .gold,
                    category: .rank,
                    icon: "crown.fill",
                    targetProgress: 1
                )
                a.unlock()
                return a
            }())
        }

        CompactAchievementCard(achievement: {
            let a = Achievement(
                key: "workouts_10",
                title: "Dedicated",
                descriptionText: "Complete 10 workouts",
                tier: .bronze,
                category: .workout,
                icon: "dumbbell.fill",
                targetProgress: 10
            )
            a.progress = 6
            return a
        }())
    }
    .padding()
    .background(Color.theme.background)
    .preferredColorScheme(.dark)
}

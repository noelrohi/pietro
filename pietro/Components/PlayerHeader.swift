//
//  PlayerHeader.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

// MARK: - Player Header (Compact)

struct PlayerHeaderCompact: View {
    let profile: PlayerProfile

    var body: some View {
        HStack(spacing: 12) {
            // Rank badge
            RankBadgeSmall(rank: profile.rank)

            // Level and XP
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text("Lv. \(profile.currentLevel)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.theme.foreground)

                    Text("•")
                        .foregroundStyle(Color.theme.muted)

                    Text("\(profile.totalXP) XP")
                        .font(.system(size: 13, weight: .medium, design: .monospaced))
                        .foregroundStyle(Color.theme.muted)
                }

                // XP Progress bar
                XPProgressBar(
                    progress: LevelConfig.levelProgress(forTotalXP: profile.totalXP),
                    height: 6
                )
            }

            Spacer()
        }
        .padding(12)
        .background(Color.theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.theme.border, lineWidth: 1)
        )
    }
}

// MARK: - XP Progress Bar

struct XPProgressBar: View {
    let progress: Double
    var height: CGFloat = 8
    var showLabel: Bool = false

    @State private var animatedProgress: CGFloat = 0

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(Color.theme.secondary)

                    // Progress fill
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(
                            LinearGradient(
                                colors: [Color.theme.primary.opacity(0.8), Color.theme.primary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(geometry.size.width * animatedProgress, height))
                }
            }
            .frame(height: height)

            if showLabel {
                HStack {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(Color.theme.muted)

                    Spacer()

                    Text("Next Level")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.theme.muted)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                animatedProgress = newValue
            }
        }
    }
}

// MARK: - Rank Badge Small

struct RankBadgeSmall: View {
    let rank: HunterRank

    var body: some View {
        ZStack {
            if rank.hasGlow {
                Circle()
                    .fill(rank.color.opacity(0.3))
                    .frame(width: 44, height: 44)
                    .blur(radius: 8)
            }

            Circle()
                .fill(Color.theme.card)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(rank.color.opacity(0.5), lineWidth: 2)
                )

            Text(rank.rawValue)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(rank.color)
        }
    }
}

// MARK: - Detailed XP Card

struct XPDetailCard: View {
    let profile: PlayerProfile

    private var xpToNext: Int {
        LevelConfig.xpToNextLevel(forTotalXP: profile.totalXP)
    }

    private var progress: Double {
        LevelConfig.levelProgress(forTotalXP: profile.totalXP)
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        RankBadgeSmall(rank: profile.rank)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(profile.rank.title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.theme.foreground)

                            Text("Level \(profile.currentLevel)")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.theme.muted)
                        }
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(profile.totalXP)")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.theme.foreground)

                    Text("Total XP")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.theme.muted)
                }
            }

            // Progress section
            VStack(spacing: 8) {
                XPProgressBar(progress: progress, height: 10)

                HStack {
                    Text("\(xpToNext) XP to level \(profile.currentLevel + 1)")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.theme.muted)

                    Spacer()

                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(Color.theme.primary)
                }
            }
        }
        .padding(16)
        .background(Color.theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.theme.border, lineWidth: 1)
        )
    }
}

// MARK: - XP Gain Animation Modifier

struct XPGainModifier: ViewModifier {
    let amount: Int
    @Binding var isShowing: Bool

    @State private var offset: CGFloat = 0
    @State private var opacity: CGFloat = 1

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if isShowing {
                    Text("+\(amount) XP")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.theme.accent)
                        .offset(y: offset)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1)) {
                                offset = -40
                                opacity = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isShowing = false
                                offset = 0
                                opacity = 1
                            }
                        }
                }
            }
    }
}

extension View {
    func xpGain(amount: Int, isShowing: Binding<Bool>) -> some View {
        modifier(XPGainModifier(amount: amount, isShowing: isShowing))
    }
}

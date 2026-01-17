//
//  AchievementUnlockOverlay.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct AchievementUnlockOverlay: View {
    let achievement: Achievement
    let onDismiss: () -> Void

    @State private var showContent = false
    @State private var showGlow = false
    @State private var iconScale: CGFloat = 0.5
    @State private var glowOpacity: CGFloat = 0

    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.85)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            VStack(spacing: 32) {
                Spacer()

                // Achievement icon with glow
                ZStack {
                    // Outer glow
                    if achievement.tier.hasGlow {
                        Circle()
                            .fill(achievement.tier.color.opacity(0.3))
                            .frame(width: 180, height: 180)
                            .blur(radius: 40)
                            .opacity(glowOpacity)
                    }

                    // Inner glow
                    Circle()
                        .fill(achievement.tier.color.opacity(0.2))
                        .frame(width: 140, height: 140)
                        .blur(radius: 20)
                        .opacity(glowOpacity)

                    // Icon container
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        achievement.tier.color.opacity(0.4),
                                        achievement.tier.color.opacity(0.1)
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 60
                                )
                            )
                            .frame(width: 120, height: 120)

                        Circle()
                            .stroke(achievement.tier.gradient, lineWidth: 3)
                            .frame(width: 120, height: 120)

                        Image(systemName: achievement.icon)
                            .font(.system(size: 48))
                            .foregroundStyle(achievement.tier.gradient)
                    }
                    .scaleEffect(iconScale)
                }

                // Content
                if showContent {
                    VStack(spacing: 16) {
                        // Tier badge
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                            Text(achievement.tier.rawValue.uppercased())
                                .font(.system(size: 11, weight: .bold))
                                .tracking(1.5)
                        }
                        .foregroundStyle(achievement.tier.color)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(achievement.tier.color.opacity(0.15))
                        .clipShape(Capsule())

                        // Title
                        Text(achievement.title)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(Color.theme.foreground)
                            .multilineTextAlignment(.center)

                        // Description
                        Text(achievement.descriptionText)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.theme.muted)
                            .multilineTextAlignment(.center)

                        // XP reward
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.theme.accent)

                            Text("+\(achievement.xpReward) XP")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundStyle(Color.theme.accent)
                        }
                        .padding(.top, 8)
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Spacer()

                // Dismiss button
                if showContent {
                    Button {
                        dismiss()
                    } label: {
                        Text("Continue")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.theme.foreground)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(achievement.tier.color.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(achievement.tier.color.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .transition(.opacity)
                }
            }
        }
        .onAppear {
            // Animate icon scale
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
                iconScale = 1.0
            }

            // Animate glow
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                glowOpacity = 1
            }

            // Show content
            withAnimation(.easeOut(duration: 0.4).delay(0.5)) {
                showContent = true
            }

            // Pulse glow effect
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(1)) {
                showGlow = true
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeIn(duration: 0.2)) {
            showContent = false
            iconScale = 0.8
            glowOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            onDismiss()
        }
    }
}

// MARK: - Preview

#Preview {
    AchievementUnlockOverlay(
        achievement: {
            let a = Achievement(
                key: "first_workout",
                title: "First Blood",
                descriptionText: "Complete your first workout",
                tier: .gold,
                category: .workout,
                icon: "bolt.fill",
                targetProgress: 1
            )
            a.unlock()
            return a
        }()
    ) { }
    .preferredColorScheme(.dark)
}

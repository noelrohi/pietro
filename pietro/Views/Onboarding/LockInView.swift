//
//  LockInView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct LockInView: View {
    let profile: PlayerProfile
    let onComplete: () -> Void

    @State private var showContent = false
    @State private var showRank = false
    @State private var showButton = false
    @State private var isConfirming = false
    @State private var confirmProgress: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 40) {
                // Rank badge
                rankBadgeView

                // Stats summary
                statsSummaryView
                    .opacity(showContent ? 1 : 0)
            }
            .padding(.horizontal, 24)

            Spacer()

            // Confirm button
            confirmButtonView
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
                .opacity(showButton ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3)) {
                showRank = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.8)) {
                showContent = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(1.2)) {
                showButton = true
            }
        }
    }

    @ViewBuilder
    private var rankBadgeView: some View {
        VStack(spacing: 16) {
            ZStack {
                // Glow effect
                Circle()
                    .fill(profile.rank.color.opacity(0.2))
                    .frame(width: 140, height: 140)
                    .blur(radius: 20)

                if #available(iOS 26, *) {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 120, height: 120)
                        .glassEffect(
                            .regular.tint(profile.rank.color.opacity(0.1)),
                            in: .circle
                        )
                } else {
                    Circle()
                        .fill(Color.theme.card)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(profile.rank.color.opacity(0.5), lineWidth: 2)
                        )
                }

                Text(profile.rank.rawValue)
                    .font(.system(size: 56, weight: .bold))
                    .foregroundStyle(profile.rank.color)
            }
            .scaleEffect(showRank ? 1 : 0.5)
            .opacity(showRank ? 1 : 0)

            VStack(spacing: 4) {
                Text(profile.rank.title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.theme.foreground)

                Text("Starting Rank")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.theme.muted)
            }
            .opacity(showRank ? 1 : 0)
        }
    }

    @ViewBuilder
    private var statsSummaryView: some View {
        let content = VStack(spacing: 16) {
            Text("PLAYER REGISTERED")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundStyle(Color.theme.success)
                .tracking(3)

            HStack(spacing: 24) {
                StatSummary(label: "STR", value: profile.strength, color: Color.theme.strength)
                StatSummary(label: "VIT", value: profile.vitality, color: Color.theme.vitality)
                StatSummary(label: "AGI", value: profile.agility, color: Color.theme.agility)
                StatSummary(label: "REC", value: profile.recovery, color: Color.theme.recovery)
            }
        }
        .padding(20)

        if #available(iOS 26, *) {
            content
                .glassEffect(
                    .regular.tint(Color.theme.success.opacity(0.1)),
                    in: .rect(cornerRadius: 16)
                )
        } else {
            content
                .background(Color.theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.theme.success.opacity(0.3), lineWidth: 1)
                )
        }
    }

    @ViewBuilder
    private var confirmButtonView: some View {
        VStack(spacing: 12) {
            Text("Hold to confirm")
                .font(.system(size: 13))
                .foregroundStyle(Color.theme.muted)

            // Hold button
            GeometryReader { geometry in
                ZStack {
                    if #available(iOS 26, *) {
                        // Glass background
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.clear)
                            .glassEffect(.regular, in: .rect(cornerRadius: 12))

                        // Progress fill
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.theme.primary)
                            .frame(width: geometry.size.width * confirmProgress)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        // Background
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.theme.secondary)

                        // Progress fill
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.theme.primary)
                            .frame(width: geometry.size.width * confirmProgress)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Label
                    HStack(spacing: 8) {
                        Image(systemName: isConfirming ? "hand.tap.fill" : "hand.tap")
                            .font(.system(size: 16))

                        Text(confirmProgress >= 1 ? "Confirmed!" : "Hold to Begin")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(confirmProgress > 0.5 ? Color.theme.primaryForeground : Color.theme.foreground)
                }
            }
            .frame(height: 56)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isConfirming {
                            isConfirming = true
                            startConfirmation()
                        }
                    }
                    .onEnded { _ in
                        if confirmProgress < 1 {
                            cancelConfirmation()
                        }
                    }
            )
        }
    }

    private func startConfirmation() {
        withAnimation(.linear(duration: 1.5)) {
            confirmProgress = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if isConfirming {
                onComplete()
            }
        }
    }

    private func cancelConfirmation() {
        isConfirming = false
        withAnimation(.easeOut(duration: 0.2)) {
            confirmProgress = 0
        }
    }
}

struct StatSummary: View {
    let label: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundStyle(color)

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color.theme.muted)
        }
    }
}

#Preview {
    let profile = PlayerProfile()
    return LockInView(profile: profile) { }
        .background(Color.theme.background)
}

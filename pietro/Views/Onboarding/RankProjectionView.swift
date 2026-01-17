//
//  RankProjectionView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct RankProjectionView: View {
    let onContinue: () -> Void

    @State private var showHeader = false
    @State private var animatedRanks: Set<HunterRank> = []
    @State private var showMessage = false

    private let projectionData: [(HunterRank, String, Int)] = [
        (.e, "Now", 0),
        (.d, "Week 2", 14),
        (.c, "Week 6", 42),
        (.b, "Week 12", 84)
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 12) {
                        Text("RANK PROGRESSION")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.theme.accent)
                            .tracking(3)

                        Text("Your Journey")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(Color.theme.foreground)

                        Text("Based on your profile and goals")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.theme.muted)
                    }
                    .opacity(showHeader ? 1 : 0)

                    // Rank progression
                    VStack(spacing: 0) {
                        ForEach(Array(projectionData.enumerated()), id: \.1.0) { index, data in
                            let (rank, label, _) = data
                            let isAnimated = animatedRanks.contains(rank)

                            HStack(spacing: 16) {
                                // Timeline
                                VStack(spacing: 0) {
                                    Circle()
                                        .fill(isAnimated ? rank.color : Color.theme.muted.opacity(0.3))
                                        .frame(width: 12, height: 12)

                                    if index < projectionData.count - 1 {
                                        Rectangle()
                                            .fill(isAnimated ? rank.color.opacity(0.5) : Color.theme.muted.opacity(0.2))
                                            .frame(width: 2, height: 60)
                                    }
                                }

                                // Rank card
                                rankCardView(rank: rank, label: label, isAnimated: isAnimated, index: index)
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    // Message
                    SystemMessage(
                        "Consistent training unlocks higher ranks. Each rank brings new challenges and rewards.",
                        icon: "trophy.fill"
                    )
                    .opacity(showMessage ? 1 : 0)
                    .padding(.horizontal, 24)
                }
                .padding(.top, 32)
            }

            VStack(spacing: 0) {
                PrimaryButton("I'm Ready", icon: "arrow.right") {
                    onContinue()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
                .opacity(showMessage ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                showHeader = true
            }

            // Animate ranks sequentially
            for (index, data) in projectionData.enumerated() {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.5 + Double(index) * 0.3)) {
                    animatedRanks.insert(data.0)
                }
            }

            withAnimation(.easeOut(duration: 0.5).delay(2.0)) {
                showMessage = true
            }
        }
    }

    @ViewBuilder
    private func rankCardView(rank: HunterRank, label: String, isAnimated: Bool, index: Int) -> some View {
        let content = HStack(spacing: 12) {
            Text(rank.rawValue)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(rank.color)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(rank.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.theme.foreground)

                Text(label)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.theme.muted)
            }

            Spacer()

            if isAnimated {
                Image(systemName: index == 0 ? "checkmark.circle.fill" : "circle.dotted")
                    .font(.system(size: 20))
                    .foregroundStyle(index == 0 ? Color.theme.success : rank.color.opacity(0.5))
            }
        }
        .padding(16)

        if #available(iOS 26, *) {
            content
                .background(isAnimated ? Color.clear : Color.theme.card.opacity(0.3))
                .glassEffect(
                    isAnimated ? .regular.tint(rank.color.opacity(0.1)) : .regular,
                    in: .rect(cornerRadius: 12)
                )
                .opacity(isAnimated ? 1 : 0.5)
                .scaleEffect(isAnimated ? 1 : 0.95)
        } else {
            content
                .background(isAnimated ? Color.theme.card : Color.theme.card.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isAnimated ? rank.color.opacity(0.3) : Color.theme.border, lineWidth: 1)
                )
                .opacity(isAnimated ? 1 : 0.5)
                .scaleEffect(isAnimated ? 1 : 0.95)
        }
    }
}

#Preview {
    RankProjectionView { }
        .background(Color.theme.background)
}

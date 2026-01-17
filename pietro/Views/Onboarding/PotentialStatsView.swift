//
//  PotentialStatsView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct PotentialStatsView: View {
    let profile: PlayerProfile
    let onContinue: () -> Void

    @State private var showHeader = false
    @State private var showStats = false
    @State private var showTotal = false
    @State private var showMessage = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 12) {
                        Text("90 DAY PROJECTION")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.theme.success)
                            .tracking(3)

                        Text("Your Potential")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(Color.theme.foreground)
                    }
                    .opacity(showHeader ? 1 : 0)

                    // Stats comparison
                    statsComparisonView
                        .opacity(showStats ? 1 : 0)

                    // Total comparison
                    totalComparisonView
                        .opacity(showTotal ? 1 : 0)

                    // Message
                    SystemMessage(
                        "This isn't a fantasy. Players who follow their training consistently see these gains in 90 days.",
                        icon: "chart.line.uptrend.xyaxis"
                    )
                    .opacity(showMessage ? 1 : 0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
            }

            VStack(spacing: 0) {
                PrimaryButton("View Rank Projection", icon: "arrow.right") {
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
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                showStats = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(1.5)) {
                showTotal = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(2.0)) {
                showMessage = true
            }
        }
    }

    @ViewBuilder
    private var statsComparisonView: some View {
        let content = VStack(spacing: 20) {
            StatComparisonBar(
                label: "STRENGTH",
                current: profile.strength,
                potential: profile.potentialStrength
            )

            StatComparisonBar(
                label: "VITALITY",
                current: profile.vitality,
                potential: profile.potentialVitality
            )

            StatComparisonBar(
                label: "AGILITY",
                current: profile.agility,
                potential: profile.potentialAgility
            )

            StatComparisonBar(
                label: "RECOVERY",
                current: profile.recovery,
                potential: profile.potentialRecovery
            )
        }
        .padding(20)

        if #available(iOS 26, *) {
            content
                .glassEffect(.regular, in: .rect(cornerRadius: 16))
        } else {
            content
                .background(Color.theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.theme.border, lineWidth: 1)
                )
        }
    }

    @ViewBuilder
    private var totalComparisonView: some View {
        let content = HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Power Growth")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.theme.muted)

                Text("\(profile.totalStats) → \(profile.potentialTotalStats)")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.theme.foreground)
            }

            Spacer()

            Text("+\(profile.potentialTotalStats - profile.totalStats)")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundStyle(Color.theme.success)
        }
        .padding(16)

        if #available(iOS 26, *) {
            content
                .background(Color.theme.success.opacity(0.1))
                .glassEffect(
                    .regular.tint(Color.theme.success.opacity(0.1)),
                    in: .rect(cornerRadius: 12)
                )
        } else {
            content
                .background(
                    LinearGradient(
                        colors: [Color.theme.success.opacity(0.15), Color.theme.card],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.theme.success.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

#Preview {
    let profile = PlayerProfile()
    return PotentialStatsView(profile: profile) { }
        .background(Color.theme.background)
}

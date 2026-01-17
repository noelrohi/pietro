//
//  StatsRevealView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct StatsRevealView: View {
    let profile: PlayerProfile
    let onContinue: () -> Void

    @State private var showHeader = false
    @State private var showStats = false
    @State private var showMessage = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 12) {
                        Text("PLAYER STATUS")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.theme.accent)
                            .tracking(3)

                        Text("Current Stats")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(Color.theme.foreground)
                    }
                    .opacity(showHeader ? 1 : 0)

                    // Stats grid
                    statsGridView
                        .opacity(showStats ? 1 : 0)

                    // Total
                    totalPowerView
                        .opacity(showStats ? 1 : 0)

                    // Message
                    SystemMessage(
                        "Your current stats reflect where you're starting. Every Player begins somewhere. What matters is where you're going.",
                        icon: "info.circle.fill"
                    )
                    .opacity(showMessage ? 1 : 0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
            }

            VStack(spacing: 0) {
                PrimaryButton("See Your Potential", icon: "arrow.right") {
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
            withAnimation(.easeOut(duration: 0.5).delay(0.6)) {
                showStats = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(1.8)) {
                showMessage = true
            }
        }
    }

    @ViewBuilder
    private var statsGridView: some View {
        let statsContent = VStack(spacing: 20) {
            StatBar(
                label: "STRENGTH",
                value: profile.strength,
                color: Color.theme.strength,
                animated: showStats
            )

            StatBar(
                label: "VITALITY",
                value: profile.vitality,
                color: Color.theme.vitality,
                animated: showStats
            )

            StatBar(
                label: "AGILITY",
                value: profile.agility,
                color: Color.theme.agility,
                animated: showStats
            )

            StatBar(
                label: "RECOVERY",
                value: profile.recovery,
                color: Color.theme.recovery,
                animated: showStats
            )
        }
        .padding(20)

        if #available(iOS 26, *) {
            statsContent
                .glassEffect(.regular, in: .rect(cornerRadius: 16))
        } else {
            statsContent
                .background(Color.theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.theme.border, lineWidth: 1)
                )
        }
    }

    @ViewBuilder
    private var totalPowerView: some View {
        let content = HStack {
            Text("Total Power")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.theme.muted)

            Spacer()

            Text("\(profile.totalStats)")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundStyle(Color.theme.destructive)
        }
        .padding(16)

        if #available(iOS 26, *) {
            content
                .glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            content
                .background(Color.theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    let profile = PlayerProfile()
    return StatsRevealView(profile: profile) { }
        .background(Color.theme.background)
}

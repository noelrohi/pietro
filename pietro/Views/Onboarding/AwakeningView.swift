//
//  AwakeningView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct AwakeningView: View {
    let onContinue: () -> Void

    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showMessage = false
    @State private var showButton = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                // Icon with glass effect
                iconView
                    .opacity(showTitle ? 1 : 0)
                    .scaleEffect(showTitle ? 1 : 0.8)

                VStack(spacing: 12) {
                    Text("SYSTEM")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.theme.accent)
                        .tracking(4)
                        .opacity(showTitle ? 1 : 0)

                    Text("You have been chosen")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Color.theme.foreground)
                        .multilineTextAlignment(.center)
                        .opacity(showSubtitle ? 1 : 0)
                        .offset(y: showSubtitle ? 0 : 10)
                }

                SystemMessage(
                    "You have acquired the qualifications to become a Player. Complete your registration to begin.",
                    icon: "person.badge.plus"
                )
                .opacity(showMessage ? 1 : 0)
                .offset(y: showMessage ? 0 : 20)
                .padding(.horizontal, 24)
            }

            Spacer()

            VStack(spacing: 16) {
                PrimaryButton("Begin Registration", icon: "arrow.right") {
                    onContinue()
                }

                Text("Your journey to strength awaits")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.theme.muted)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
            .opacity(showButton ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                showTitle = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                showSubtitle = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.9)) {
                showMessage = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(1.3)) {
                showButton = true
            }
        }
    }

    @ViewBuilder
    private var iconView: some View {
        if #available(iOS 26, *) {
            ZStack {
                // Glow behind the icon
                Circle()
                    .fill(Color.theme.accent.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)

                Image(systemName: "bolt.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Color.theme.accent)
                    .frame(width: 80, height: 80)
                    .glassEffect(
                        .regular.tint(Color.theme.accent.opacity(0.1)),
                        in: .circle
                    )
            }
        } else {
            Image(systemName: "bolt.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.theme.accent)
        }
    }
}

#Preview {
    AwakeningView { }
        .background(Color.theme.background)
}

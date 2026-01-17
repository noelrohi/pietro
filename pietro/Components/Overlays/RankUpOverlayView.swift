//
//  RankUpOverlayView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct RankUpOverlayView: View {
    let newRank: HunterRank
    let onDismiss: () -> Void

    @State private var showBackground = false
    @State private var showRank = false
    @State private var showContent = false
    @State private var showButton = false
    @State private var glowOpacity: CGFloat = 0.3

    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(showBackground ? 0.85 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            // Content
            VStack(spacing: 40) {
                Spacer()

                // Rank badge
                ZStack {
                    // Glow effect
                    if newRank.hasGlow {
                        Circle()
                            .fill(newRank.color.opacity(glowOpacity))
                            .frame(width: 200, height: 200)
                            .blur(radius: 40)
                    }

                    // Outer ring
                    Circle()
                        .stroke(
                            newRank.gradient,
                            lineWidth: 4
                        )
                        .frame(width: 160, height: 160)

                    // Inner fill
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [newRank.color.opacity(0.2), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)

                    // Rank letter
                    Text(newRank.rawValue)
                        .font(.system(size: 72, weight: .heavy))
                        .foregroundStyle(newRank.gradient)
                }
                .scaleEffect(showRank ? 1 : 0.3)
                .opacity(showRank ? 1 : 0)

                // Text content
                VStack(spacing: 16) {
                    Text("RANK UP")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .tracking(4)
                        .foregroundStyle(newRank.color)

                    Text(newRank.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Color.theme.foreground)

                    Text(newRank.subtitle)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.theme.muted)
                        .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)

                Spacer()

                // Continue button
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Text("Accept")
                            .font(.system(size: 16, weight: .semibold))

                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(Color.theme.background)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(newRank.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
                .opacity(showButton ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                showBackground = true
            }
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.2)) {
                showRank = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.6)) {
                showContent = true
            }
            withAnimation(.easeOut(duration: 0.3).delay(1.0)) {
                showButton = true
            }

            // Glow pulse animation
            if newRank.hasGlow {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(0.5)) {
                    glowOpacity = 0.5
                }
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeIn(duration: 0.2)) {
            showBackground = false
            showContent = false
            showRank = false
            showButton = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            onDismiss()
        }
    }
}

#Preview {
    RankUpOverlayView(newRank: .d) {}
        .preferredColorScheme(.dark)
}

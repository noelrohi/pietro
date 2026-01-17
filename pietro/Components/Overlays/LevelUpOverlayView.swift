//
//  LevelUpOverlayView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct LevelUpOverlayView: View {
    let newLevel: Int
    let onDismiss: () -> Void

    @State private var showBackground = false
    @State private var showContent = false
    @State private var showLevel = false
    @State private var showButton = false
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(showBackground ? 0.8 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            // Content
            VStack(spacing: 32) {
                Spacer()

                // Level badge
                ZStack {
                    // Outer glow rings
                    ForEach(0..<3) { i in
                        Circle()
                            .stroke(Color.theme.primary.opacity(0.1 - Double(i) * 0.03), lineWidth: 2)
                            .frame(width: CGFloat(160 + i * 30), height: CGFloat(160 + i * 30))
                            .scaleEffect(pulseScale + CGFloat(i) * 0.05)
                    }

                    // Main circle
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.theme.primary.opacity(0.3), Color.theme.primary.opacity(0.1)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 70
                            )
                        )
                        .frame(width: 140, height: 140)

                    Circle()
                        .stroke(Color.theme.primary, lineWidth: 3)
                        .frame(width: 140, height: 140)

                    VStack(spacing: 4) {
                        Text("LV")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.theme.primary.opacity(0.7))

                        Text("\(newLevel)")
                            .font(.system(size: 56, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color.theme.primary)
                    }
                }
                .scaleEffect(showLevel ? 1 : 0.5)
                .opacity(showLevel ? 1 : 0)

                // Text
                VStack(spacing: 12) {
                    Text("LEVEL UP")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .tracking(4)
                        .foregroundStyle(Color.theme.primary)

                    Text("You've grown stronger")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.theme.muted)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                Spacer()

                // Continue button
                Button {
                    dismiss()
                } label: {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.theme.foreground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.theme.secondary)
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
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                showLevel = true
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.5)) {
                showContent = true
            }
            withAnimation(.easeOut(duration: 0.3).delay(0.8)) {
                showButton = true
            }

            // Pulse animation
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.5)) {
                pulseScale = 1.1
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeIn(duration: 0.2)) {
            showBackground = false
            showContent = false
            showLevel = false
            showButton = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            onDismiss()
        }
    }
}

#Preview {
    LevelUpOverlayView(newLevel: 5) {}
        .preferredColorScheme(.dark)
}

//
//  XPGainToast.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct XPGainToast: View {
    let result: XPAwardResult
    let onDismiss: () -> Void

    @State private var isVisible = false
    @State private var showBreakdown = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                // Total XP header
                HStack(spacing: 12) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.theme.accent)

                    Text("+\(result.totalXPAwarded) XP")
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.theme.accent)

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.theme.muted)
                            .frame(width: 28, height: 28)
                            .background(Color.theme.secondary)
                            .clipShape(Circle())
                    }
                }

                // Breakdown
                if showBreakdown {
                    VStack(spacing: 8) {
                        ForEach(Array(result.breakdown.enumerated()), id: \.offset) { _, item in
                            HStack(spacing: 10) {
                                Image(systemName: item.icon)
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.theme.muted)
                                    .frame(width: 20)

                                Text(item.source)
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.theme.foreground)

                                Spacer()

                                Text("+\(item.amount)")
                                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                    .foregroundStyle(Color.theme.success)
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(20)
            .background(Color.theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.theme.accent.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.theme.accent.opacity(0.2), radius: 20, y: 10)
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
            .offset(y: isVisible ? 0 : 200)
            .opacity(isVisible ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isVisible = true
            }
            withAnimation(.easeOut(duration: 0.3).delay(0.3)) {
                showBreakdown = true
            }

            // Auto dismiss after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                dismiss()
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeIn(duration: 0.2)) {
            isVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            onDismiss()
        }
    }
}

// MARK: - Simple XP Toast (for quick notifications)

struct SimpleXPToast: View {
    let amount: Int
    let source: String

    @State private var isVisible = false

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 14))
                .foregroundStyle(Color.theme.accent)

            Text("+\(amount) XP")
                .font(.system(size: 15, weight: .bold, design: .monospaced))
                .foregroundStyle(Color.theme.accent)

            Text("•")
                .foregroundStyle(Color.theme.muted)

            Text(source)
                .font(.system(size: 14))
                .foregroundStyle(Color.theme.muted)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.theme.card)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.theme.accent.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
        .scaleEffect(isVisible ? 1 : 0.8)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isVisible = true
            }
        }
    }
}

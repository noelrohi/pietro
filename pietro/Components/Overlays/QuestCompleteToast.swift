//
//  QuestCompleteToast.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct QuestCompleteToast: View {
    let quest: Quest
    let xpAwarded: Int
    let onDismiss: () -> Void

    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.theme.success.opacity(0.2))
                        .frame(width: 44, height: 44)

                    Image(systemName: "scroll.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.theme.success)
                }

                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text("QUEST COMPLETE")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(1)
                        .foregroundStyle(Color.theme.success)

                    Text(quest.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.theme.foreground)
                }

                Spacer()

                // XP Badge
                VStack(spacing: 0) {
                    Text("+\(xpAwarded)")
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.theme.accent)

                    Text("XP")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.theme.accent.opacity(0.7))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.theme.accent.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(20)
            .background(Color.theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.theme.success.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.theme.success.opacity(0.2), radius: 20, y: 10)
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
            .offset(y: isVisible ? 0 : 200)
            .opacity(isVisible ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isVisible = true
            }

            // Auto dismiss after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                dismiss()
            }
        }
        .onTapGesture {
            dismiss()
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

// MARK: - Multiple Quests Toast

struct MultipleQuestsToast: View {
    let completions: [QuestCompletionResult]
    let onDismiss: () -> Void

    @State private var isVisible = false

    private var totalXP: Int {
        completions.reduce(0) { $0 + $1.xpAwarded }
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                // Header
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.theme.success.opacity(0.2))
                            .frame(width: 44, height: 44)

                        Image(systemName: "scroll.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.theme.success)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("QUESTS COMPLETE")
                            .font(.system(size: 10, weight: .bold))
                            .tracking(1)
                            .foregroundStyle(Color.theme.success)

                        Text("\(completions.count) quests completed!")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.theme.foreground)
                    }

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.theme.muted)
                            .frame(width: 24, height: 24)
                            .background(Color.theme.secondary)
                            .clipShape(Circle())
                    }
                }

                // Quest list
                VStack(spacing: 8) {
                    ForEach(completions, id: \.quest.id) { completion in
                        HStack {
                            Image(systemName: completion.quest.icon)
                                .font(.system(size: 12))
                                .foregroundStyle(Color.theme.muted)
                                .frame(width: 20)

                            Text(completion.quest.title)
                                .font(.system(size: 13))
                                .foregroundStyle(Color.theme.foreground)

                            Spacer()

                            Text("+\(completion.xpAwarded)")
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .foregroundStyle(Color.theme.success)
                        }
                    }
                }

                // Total
                HStack {
                    Text("Total")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.theme.muted)

                    Spacer()

                    Text("+\(totalXP) XP")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.theme.accent)
                }
                .padding(.top, 4)
            }
            .padding(20)
            .background(Color.theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.theme.success.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.theme.success.opacity(0.2), radius: 20, y: 10)
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
            .offset(y: isVisible ? 0 : 200)
            .opacity(isVisible ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isVisible = true
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

// MARK: - Preview

#Preview {
    ZStack {
        Color.theme.background
            .ignoresSafeArea()

        QuestCompleteToast(
            quest: Quest.completeWorkouts(count: 1, expiresAt: Date()),
            xpAwarded: 30
        ) { }
    }
    .preferredColorScheme(.dark)
}

//
//  CommitmentView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct CommitmentView: View {
    let onContinue: () -> Void

    @State private var answers: [Bool?] = [nil, nil, nil]
    @State private var currentQuestion = 0

    private let questions = [
        "Are you willing to show up even when motivation fades?",
        "Will you push through discomfort to grow stronger?",
        "Are you ready to become the strongest version of yourself?"
    ]

    private var allAnswered: Bool {
        answers.allSatisfy { $0 != nil }
    }

    private var allYes: Bool {
        answers.allSatisfy { $0 == true }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 12) {
                        Text("COMMITMENT")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.theme.primary)
                            .tracking(3)

                        Text("Before You Begin")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(Color.theme.foreground)
                    }

                    // Questions
                    VStack(spacing: 16) {
                        ForEach(0..<questions.count, id: \.self) { index in
                            QuestionCard(
                                question: questions[index],
                                answer: answers[index],
                                isActive: index <= currentQuestion
                            ) { isYes in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    answers[index] = isYes
                                    if index < questions.count - 1 {
                                        currentQuestion = index + 1
                                    }
                                }
                            }
                        }
                    }

                    if allAnswered {
                        if allYes {
                            SystemMessage(
                                "Your resolve is clear. You have the mindset of a true Player.",
                                icon: "flame.fill"
                            )
                        } else {
                            SystemMessage(
                                "Transformation requires commitment. When you're truly ready, your answers will reflect it.",
                                icon: "exclamationmark.triangle.fill"
                            )
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
            }

            VStack(spacing: 0) {
                PrimaryButton("Lock In", icon: "lock.fill", isEnabled: allYes) {
                    onContinue()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
}

struct QuestionCard: View {
    let question: String
    let answer: Bool?
    let isActive: Bool
    let onAnswer: (Bool) -> Void

    var body: some View {
        questionCardContent
    }

    @ViewBuilder
    private var questionCardContent: some View {
        let content = VStack(alignment: .leading, spacing: 16) {
            Text(question)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(isActive ? Color.theme.foreground : Color.theme.muted)

            if isActive {
                HStack(spacing: 12) {
                    AnswerButton(title: "Yes", isSelected: answer == true) {
                        onAnswer(true)
                    }

                    AnswerButton(title: "No", isSelected: answer == false, isNegative: true) {
                        onAnswer(false)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)

        if #available(iOS 26, *) {
            let tintColor: Color = {
                if answer == true {
                    return Color.theme.success.opacity(0.15)
                } else if answer == false {
                    return Color.theme.destructive.opacity(0.15)
                } else {
                    return Color.clear
                }
            }()

            content
                .background(tintColor)
                .glassEffect(
                    .regular.tint(tintColor),
                    in: .rect(cornerRadius: 12)
                )
                .opacity(isActive ? 1 : 0.5)
        } else {
            content
                .background(Color.theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            answer == true ? Color.theme.success.opacity(0.5) :
                                answer == false ? Color.theme.destructive.opacity(0.5) :
                                Color.theme.border,
                            lineWidth: 1
                        )
                )
                .opacity(isActive ? 1 : 0.5)
        }
    }
}

struct AnswerButton: View {
    let title: String
    let isSelected: Bool
    var isNegative: Bool = false
    let action: () -> Void

    var body: some View {
        answerButtonContent
    }

    @ViewBuilder
    private var answerButtonContent: some View {
        if #available(iOS 26, *) {
            Button(action: action) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .foregroundStyle(
                        isSelected
                            ? (isNegative ? Color.theme.destructiveForeground : Color.theme.successForeground)
                            : Color.theme.foreground
                    )
                    .background(
                        isSelected
                            ? (isNegative ? Color.theme.destructive : Color.theme.success)
                            : Color.clear
                    )
                    .glassEffect(
                        isSelected
                            ? .regular.tint(isNegative ? Color.theme.destructive : Color.theme.success).interactive()
                            : .regular.interactive(),
                        in: .rect(cornerRadius: 8)
                    )
            }
            .buttonStyle(.plain)
        } else {
            Button(action: action) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .foregroundStyle(
                        isSelected
                            ? (isNegative ? Color.theme.destructiveForeground : Color.theme.successForeground)
                            : Color.theme.foreground
                    )
                    .background(
                        isSelected
                            ? (isNegative ? Color.theme.destructive : Color.theme.success)
                            : Color.theme.secondary
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    CommitmentView { }
        .background(Color.theme.background)
}

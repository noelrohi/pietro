//
//  FitnessLevelView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct FitnessLevelView: View {
    @Binding var selected: FitnessLevel?
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                OnboardingPage(
                    title: "What's your fitness level?",
                    subtitle: "Be honest - this affects your starting point"
                ) {
                    VStack(spacing: 12) {
                        ForEach(FitnessLevel.allCases, id: \.self) { level in
                            IconSelectionCard(
                                icon: iconFor(level),
                                title: level.rawValue,
                                subtitle: level.description,
                                isSelected: selected == level
                            ) {
                                selected = level
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }

            VStack(spacing: 0) {
                PrimaryButton("Continue", icon: "arrow.right", isEnabled: selected != nil) {
                    onContinue()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }

    private func iconFor(_ level: FitnessLevel) -> String {
        switch level {
        case .beginner: return "figure.walk"
        case .intermediate: return "figure.run"
        case .advanced: return "figure.strengthtraining.traditional"
        }
    }
}

#Preview {
    FitnessLevelView(selected: .constant(nil)) { }
        .background(Color.theme.background)
}

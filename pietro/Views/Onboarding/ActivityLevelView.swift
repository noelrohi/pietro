//
//  ActivityLevelView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct ActivityLevelView: View {
    @Binding var selected: ActivityLevel?
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                OnboardingPage(
                    title: "How active are you daily?",
                    subtitle: "Outside of planned workouts"
                ) {
                    VStack(spacing: 12) {
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
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

    private func iconFor(_ level: ActivityLevel) -> String {
        switch level {
        case .sedentary: return "chair.fill"
        case .lightlyActive: return "figure.walk"
        case .moderatelyActive: return "figure.run"
        case .veryActive: return "figure.highintensity.intervaltraining"
        }
    }
}

#Preview {
    ActivityLevelView(selected: .constant(nil)) { }
        .background(Color.theme.background)
}

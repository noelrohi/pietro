//
//  GoalSelectionView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct GoalSelectionView: View {
    @Binding var selected: FitnessGoal?
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                OnboardingPage(
                    title: "What's your primary goal?",
                    subtitle: "We'll design your path to achieve it"
                ) {
                    VStack(spacing: 12) {
                        ForEach(FitnessGoal.allCases, id: \.self) { goal in
                            IconSelectionCard(
                                icon: goal.icon,
                                title: goal.rawValue,
                                subtitle: goal.description,
                                isSelected: selected == goal
                            ) {
                                selected = goal
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
}

#Preview {
    GoalSelectionView(selected: .constant(nil)) { }
        .background(Color.theme.background)
}

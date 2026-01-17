//
//  GenderSelectionView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct GenderSelectionView: View {
    @Binding var selected: Gender?
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                OnboardingPage(
                    title: "How do you identify?",
                    subtitle: "This helps us personalize your experience"
                ) {
                    VStack(spacing: 12) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            IconSelectionCard(
                                icon: gender.icon,
                                title: gender.rawValue,
                                isSelected: selected == gender
                            ) {
                                selected = gender
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
    GenderSelectionView(selected: .constant(nil)) { }
        .background(Color.theme.background)
}

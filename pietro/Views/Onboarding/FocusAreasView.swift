//
//  FocusAreasView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct FocusAreasView: View {
    @Binding var selected: Set<FocusArea>
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                OnboardingPage(
                    title: "Where do you want to focus?",
                    subtitle: "Select the areas you want to improve"
                ) {
                    VStack(spacing: 10) {
                        ForEach(FocusArea.allCases, id: \.self) { area in
                            MultiSelectCard(
                                icon: area.icon,
                                title: area.rawValue,
                                isSelected: selected.contains(area)
                            ) {
                                if selected.contains(area) {
                                    selected.remove(area)
                                } else {
                                    selected.insert(area)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }

            VStack(spacing: 0) {
                PrimaryButton("Continue", icon: "arrow.right", isEnabled: !selected.isEmpty) {
                    onContinue()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
}

#Preview {
    FocusAreasView(selected: .constant([])) { }
        .background(Color.theme.background)
}

//
//  EquipmentAccessView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct EquipmentAccessView: View {
    @Binding var selected: Set<EquipmentType>
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                OnboardingPage(
                    title: "What equipment do you have?",
                    subtitle: "Select all that you have access to"
                ) {
                    VStack(spacing: 12) {
                        ForEach(EquipmentType.allCases, id: \.self) { equipment in
                            SelectionCard(isSelected: selected.contains(equipment)) {
                                if selected.contains(equipment) {
                                    selected.remove(equipment)
                                } else {
                                    selected.insert(equipment)
                                }
                            } content: {
                                HStack(spacing: 14) {
                                    Image(systemName: equipment.icon)
                                        .font(.system(size: 20))
                                        .foregroundStyle(selected.contains(equipment) ? Color.theme.accent : Color.theme.muted)
                                        .frame(width: 28)

                                    Text(equipment.rawValue)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(Color.theme.foreground)

                                    Spacer()

                                    if selected.contains(equipment) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundStyle(Color.theme.accent)
                                    }
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
    EquipmentAccessView(selected: .constant([])) { }
        .background(Color.theme.background)
}

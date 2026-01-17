//
//  PersonalInfoView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct PersonalInfoView: View {
    @Binding var age: Int
    @Binding var heightCm: Int
    @Binding var weightKg: Int
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                OnboardingPage(
                    title: "About you",
                    subtitle: "This helps us calculate your stats accurately"
                ) {
                    VStack(spacing: 16) {
                        NumberStepper("Age", value: $age, range: 13...100)

                        NumberStepper("Height (cm)", value: $heightCm, range: 100...250)

                        NumberStepper("Weight (kg)", value: $weightKg, range: 30...200)
                    }
                }
                .padding(.horizontal, 24)
            }

            VStack(spacing: 0) {
                PrimaryButton("Continue", icon: "arrow.right") {
                    onContinue()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
}

#Preview {
    PersonalInfoView(age: .constant(25), heightCm: .constant(170), weightKg: .constant(70)) { }
        .background(Color.theme.background)
}

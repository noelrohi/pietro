//
//  WorkoutFrequencyView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct WorkoutFrequencyView: View {
    @Binding var selectedDays: Set<Int>
    @Binding var weeklyGoal: Int
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                OnboardingPage(
                    title: "When will you train?",
                    subtitle: "Set your weekly schedule"
                ) {
                    VStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Preferred days")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.theme.muted)

                            DaySelector(selectedDays: $selectedDays)
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Weekly goal")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.theme.muted)

                            HStack(spacing: 12) {
                                ForEach(2...6, id: \.self) { count in
                                    Button {
                                        weeklyGoal = count
                                    } label: {
                                        Text("\(count)")
                                            .font(.system(size: 18, weight: .semibold))
                                            .frame(width: 52, height: 52)
                                            .foregroundStyle(weeklyGoal == count ? Color.theme.accentForeground : Color.theme.foreground)
                                            .background(weeklyGoal == count ? Color.theme.accent : Color.theme.card)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(weeklyGoal == count ? Color.clear : Color.theme.border, lineWidth: 1)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }

                            Text("\(weeklyGoal) workouts per week")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.theme.muted)
                        }

                        if !selectedDays.isEmpty {
                            SystemMessage(
                                "Great choice! Training \(selectedDays.count) days per week is \(selectedDays.count >= 4 ? "ambitious" : "a solid start").",
                                icon: "checkmark.circle.fill"
                            )
                        }
                    }
                }
                .padding(.horizontal, 24)
            }

            VStack(spacing: 0) {
                PrimaryButton("Calculate My Stats", icon: "sparkles", isEnabled: !selectedDays.isEmpty) {
                    onContinue()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
}

#Preview {
    WorkoutFrequencyView(selectedDays: .constant([0, 2, 4]), weeklyGoal: .constant(3)) { }
        .background(Color.theme.background)
}

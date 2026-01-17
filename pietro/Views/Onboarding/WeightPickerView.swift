//
//  WeightPickerView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

enum WeightUnit: String, CaseIterable {
    case kg = "kg"
    case lbs = "lbs"
}

struct WeightPickerView: View {
    @Binding var weightKg: Int
    let onContinue: () -> Void

    @State private var selectedUnit: WeightUnit = .kg
    @State private var weightLbs: Int = 154

    // Convert kg to lbs
    private var lbsFromKg: Int {
        Int(Double(weightKg) * 2.20462)
    }

    // Convert lbs to kg
    private func kgFromLbs(_ lbs: Int) -> Int {
        Int(Double(lbs) / 2.20462)
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Text("What's your weight?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.theme.foreground)

                    Text("Used to track your progress")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.theme.muted)
                }

                // Unit Toggle
                unitToggle

                // Wheel Picker
                wheelPicker
            }
            .padding(.horizontal, 24)

            Spacer()

            VStack(spacing: 0) {
                PrimaryButton("Continue", icon: "arrow.right") {
                    onContinue()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .onAppear {
            weightLbs = lbsFromKg
        }
    }

    @ViewBuilder
    private var unitToggle: some View {
        Picker("Unit", selection: $selectedUnit) {
            ForEach(WeightUnit.allCases, id: \.self) { unit in
                Text(unit.rawValue).tag(unit)
            }
        }
        .pickerStyle(.segmented)
        .frame(width: 160)
        .onChange(of: selectedUnit) { _, newValue in
            if newValue == .lbs {
                weightLbs = lbsFromKg
            }
        }
    }

    @ViewBuilder
    private var wheelPicker: some View {
        if #available(iOS 26, *) {
            ZStack {
                // Glass background
                RoundedRectangle(cornerRadius: 20)
                    .fill(.clear)
                    .glassEffect(.regular, in: .rect(cornerRadius: 20))

                // Picker content
                Group {
                    if selectedUnit == .kg {
                        Picker("Weight", selection: $weightKg) {
                            ForEach(30...200, id: \.self) { kg in
                                Text("\(kg) kg")
                                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.theme.foreground)
                                    .tag(kg)
                            }
                        }
                        .pickerStyle(.wheel)
                        .scrollContentBackground(.hidden)
                    } else {
                        Picker("Weight", selection: $weightLbs) {
                            ForEach(66...440, id: \.self) { lbs in
                                Text("\(lbs) lbs")
                                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.theme.foreground)
                                    .tag(lbs)
                            }
                        }
                        .pickerStyle(.wheel)
                        .scrollContentBackground(.hidden)
                        .onChange(of: weightLbs) { _, newValue in
                            weightKg = kgFromLbs(newValue)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .frame(height: 200)
        } else {
            Group {
                if selectedUnit == .kg {
                    Picker("Weight", selection: $weightKg) {
                        ForEach(30...200, id: \.self) { kg in
                            Text("\(kg) kg")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .tag(kg)
                        }
                    }
                    .pickerStyle(.wheel)
                } else {
                    Picker("Weight", selection: $weightLbs) {
                        ForEach(66...440, id: \.self) { lbs in
                            Text("\(lbs) lbs")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .tag(lbs)
                        }
                    }
                    .pickerStyle(.wheel)
                    .onChange(of: weightLbs) { _, newValue in
                        weightKg = kgFromLbs(newValue)
                    }
                }
            }
            .frame(height: 200)
            .padding(.horizontal, 24)
            .background(Color.theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    WeightPickerView(weightKg: .constant(70)) { }
        .background(Color.theme.background)
}

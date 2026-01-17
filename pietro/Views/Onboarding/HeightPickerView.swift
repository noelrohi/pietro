//
//  HeightPickerView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

enum HeightUnit: String, CaseIterable {
    case cm = "cm"
    case ft = "ft"
}

struct HeightPickerView: View {
    @Binding var heightCm: Int
    let onContinue: () -> Void

    @State private var selectedUnit: HeightUnit = .cm
    @State private var feet: Int = 5
    @State private var inches: Int = 7

    // Convert cm to feet/inches
    private var feetFromCm: Int {
        let totalInches = Double(heightCm) / 2.54
        return Int(totalInches / 12)
    }

    private var inchesFromCm: Int {
        let totalInches = Double(heightCm) / 2.54
        return Int(totalInches.truncatingRemainder(dividingBy: 12))
    }

    // Convert feet/inches to cm
    private func cmFromFeetInches(_ ft: Int, _ inch: Int) -> Int {
        let totalInches = Double(ft * 12 + inch)
        return Int(totalInches * 2.54)
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Text("How tall are you?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.theme.foreground)

                    Text("Used to calculate your body metrics")
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
            feet = feetFromCm
            inches = inchesFromCm
        }
    }

    @ViewBuilder
    private var unitToggle: some View {
        Picker("Unit", selection: $selectedUnit) {
            ForEach(HeightUnit.allCases, id: \.self) { unit in
                Text(unit.rawValue).tag(unit)
            }
        }
        .pickerStyle(.segmented)
        .frame(width: 160)
        .onChange(of: selectedUnit) { _, newValue in
            if newValue == .ft {
                feet = feetFromCm
                inches = inchesFromCm
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
                    if selectedUnit == .cm {
                        Picker("Height", selection: $heightCm) {
                            ForEach(100...250, id: \.self) { cm in
                                Text("\(cm) cm")
                                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.theme.foreground)
                                    .tag(cm)
                            }
                        }
                        .pickerStyle(.wheel)
                        .scrollContentBackground(.hidden)
                    } else {
                        HStack(spacing: 0) {
                            Picker("Feet", selection: $feet) {
                                ForEach(3...8, id: \.self) { ft in
                                    Text("\(ft)'")
                                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                                        .foregroundStyle(Color.theme.foreground)
                                        .tag(ft)
                                }
                            }
                            .pickerStyle(.wheel)
                            .scrollContentBackground(.hidden)
                            .onChange(of: feet) { _, newValue in
                                heightCm = cmFromFeetInches(newValue, inches)
                            }

                            Picker("Inches", selection: $inches) {
                                ForEach(0...11, id: \.self) { inch in
                                    Text("\(inch)\"")
                                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                                        .foregroundStyle(Color.theme.foreground)
                                        .tag(inch)
                                }
                            }
                            .pickerStyle(.wheel)
                            .scrollContentBackground(.hidden)
                            .onChange(of: inches) { _, newValue in
                                heightCm = cmFromFeetInches(feet, newValue)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .frame(height: 200)
        } else {
            Group {
                if selectedUnit == .cm {
                    Picker("Height", selection: $heightCm) {
                        ForEach(100...250, id: \.self) { cm in
                            Text("\(cm) cm")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .tag(cm)
                        }
                    }
                    .pickerStyle(.wheel)
                } else {
                    HStack(spacing: 0) {
                        Picker("Feet", selection: $feet) {
                            ForEach(3...8, id: \.self) { ft in
                                Text("\(ft)'")
                                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                                    .tag(ft)
                            }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: feet) { _, newValue in
                            heightCm = cmFromFeetInches(newValue, inches)
                        }

                        Picker("Inches", selection: $inches) {
                            ForEach(0...11, id: \.self) { inch in
                                Text("\(inch)\"")
                                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                                    .tag(inch)
                            }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: inches) { _, newValue in
                            heightCm = cmFromFeetInches(feet, newValue)
                        }
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
    HeightPickerView(heightCm: .constant(170)) { }
        .background(Color.theme.background)
}

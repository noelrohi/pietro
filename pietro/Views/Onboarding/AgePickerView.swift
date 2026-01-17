//
//  AgePickerView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct AgePickerView: View {
    @Binding var age: Int
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Text("How old are you?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.theme.foreground)

                    Text("This helps us personalize your experience")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.theme.muted)
                }

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
                Picker("Age", selection: $age) {
                    ForEach(13...100, id: \.self) { year in
                        Text("\(year)")
                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.theme.foreground)
                            .tag(year)
                    }
                }
                .pickerStyle(.wheel)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 40)
            }
            .frame(height: 200)
        } else {
            Picker("Age", selection: $age) {
                ForEach(13...100, id: \.self) { year in
                    Text("\(year)")
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                        .tag(year)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 200)
            .padding(.horizontal, 40)
            .background(Color.theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    AgePickerView(age: .constant(25)) { }
        .background(Color.theme.background)
}

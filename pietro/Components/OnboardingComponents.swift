//
//  OnboardingComponents.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

// MARK: - Progress Indicator

struct OnboardingProgress: View {
    let current: Int
    let total: Int

    private var progress: CGFloat {
        CGFloat(current) / CGFloat(total)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                if #available(iOS 26, *) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.ultraThinMaterial)
                        .frame(height: 4)
                } else {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.theme.secondary)
                        .frame(height: 4)
                }

                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.theme.accent)
                    .frame(width: geometry.size.width * progress, height: 4)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: progress)
            }
        }
        .frame(height: 4)
    }
}

// MARK: - Selection Card

struct SelectionCard<Content: View>: View {
    let isSelected: Bool
    let action: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        selectionCardContent
    }

    @ViewBuilder
    private var selectionCardContent: some View {
        if #available(iOS 26, *) {
            Button(action: action) {
                HStack(spacing: 14) {
                    // Selection indicator
                    SelectionIndicator(isSelected: isSelected)

                    content()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .background(isSelected ? Color.theme.accent.opacity(0.15) : Color.clear)
                .glassEffect(
                    isSelected ? .regular.tint(Color.theme.accent.opacity(0.3)).interactive() : .regular.interactive(),
                    in: .rect(cornerRadius: 16)
                )
                .shadow(color: isSelected ? Color.theme.accent.opacity(0.3) : Color.clear, radius: 8, y: 2)
            }
            .buttonStyle(.plain)
            .animation(.easeOut(duration: 0.2), value: isSelected)
        } else {
            Button(action: action) {
                HStack(spacing: 14) {
                    // Selection indicator
                    SelectionIndicator(isSelected: isSelected)

                    content()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .background(isSelected ? Color.theme.accent.opacity(0.1) : Color.theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isSelected ? Color.theme.accent : Color.theme.border,
                            lineWidth: isSelected ? 2 : 1
                        )
                )
            }
            .buttonStyle(.plain)
            .animation(.easeOut(duration: 0.2), value: isSelected)
        }
    }
}

// MARK: - Selection Indicator

struct SelectionIndicator: View {
    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.theme.accent : Color.theme.muted.opacity(0.5), lineWidth: 2)
                .frame(width: 24, height: 24)

            if isSelected {
                Circle()
                    .fill(Color.theme.accent)
                    .frame(width: 14, height: 14)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Icon Selection Card

struct IconSelectionCard: View {
    let icon: String
    let title: String
    let subtitle: String?
    let isSelected: Bool
    let action: () -> Void

    init(icon: String, title: String, subtitle: String? = nil, isSelected: Bool, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        SelectionCard(isSelected: isSelected, action: action) {
            HStack(spacing: 12) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(isSelected ? Color.theme.accent : Color.theme.muted)
                    .frame(width: 28, height: 28)

                // Text content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.theme.foreground)

                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.theme.muted)
                            .lineLimit(2)
                    }
                }
            }
        }
    }
}

// MARK: - Checkbox Indicator (for multi-select)

struct CheckboxIndicator: View {
    let isSelected: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .stroke(isSelected ? Color.theme.accent : Color.theme.muted.opacity(0.5), lineWidth: 2)
                .frame(width: 24, height: 24)

            if isSelected {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.theme.accent)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color.white)
                    )
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Multi-Select Card

struct MultiSelectCard: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        multiSelectCardContent
    }

    @ViewBuilder
    private var multiSelectCardContent: some View {
        if #available(iOS 26, *) {
            Button(action: action) {
                HStack(spacing: 14) {
                    // Checkbox indicator
                    CheckboxIndicator(isSelected: isSelected)

                    // Icon
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(isSelected ? Color.theme.accent : Color.theme.muted)
                        .frame(width: 24, height: 24)

                    // Title
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.theme.foreground)

                    Spacer()
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .background(isSelected ? Color.theme.accent.opacity(0.15) : Color.clear)
                .glassEffect(
                    isSelected ? .regular.tint(Color.theme.accent.opacity(0.3)).interactive() : .regular.interactive(),
                    in: .rect(cornerRadius: 16)
                )
                .shadow(color: isSelected ? Color.theme.accent.opacity(0.3) : Color.clear, radius: 8, y: 2)
            }
            .buttonStyle(.plain)
            .animation(.easeOut(duration: 0.2), value: isSelected)
        } else {
            Button(action: action) {
                HStack(spacing: 14) {
                    // Checkbox indicator
                    CheckboxIndicator(isSelected: isSelected)

                    // Icon
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(isSelected ? Color.theme.accent : Color.theme.muted)
                        .frame(width: 24, height: 24)

                    // Title
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.theme.foreground)

                    Spacer()
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .background(isSelected ? Color.theme.accent.opacity(0.1) : Color.theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isSelected ? Color.theme.accent : Color.theme.border,
                            lineWidth: isSelected ? 2 : 1
                        )
                )
            }
            .buttonStyle(.plain)
            .animation(.easeOut(duration: 0.2), value: isSelected)
        }
    }
}

// MARK: - Multi-Select Chip

struct SelectionChip: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: () -> Void

    init(_ title: String, icon: String? = nil, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        selectionChipContent
    }

    @ViewBuilder
    private var selectionChipContent: some View {
        if #available(iOS 26, *) {
            Button(action: action) {
                HStack(spacing: 6) {
                    // Checkmark indicator for multi-select
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                    }

                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 14))
                    }
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .foregroundStyle(isSelected ? Color.theme.accentForeground : Color.theme.foreground)
                .background(isSelected ? Color.theme.accent.opacity(0.25) : Color.clear)
                .glassEffect(
                    isSelected ? .regular.tint(Color.theme.accent.opacity(0.4)).interactive() : .regular.interactive(),
                    in: .capsule
                )
                .shadow(color: isSelected ? Color.theme.accent.opacity(0.25) : Color.clear, radius: 6, y: 2)
            }
            .buttonStyle(.plain)
            .animation(.easeOut(duration: 0.15), value: isSelected)
        } else {
            Button(action: action) {
                HStack(spacing: 6) {
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                    }

                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 14))
                    }
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .foregroundStyle(isSelected ? Color.theme.accentForeground : Color.theme.foreground)
                .background(isSelected ? Color.theme.accent : Color.theme.card)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.theme.border, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            .animation(.easeOut(duration: 0.15), value: isSelected)
        }
    }
}

// MARK: - Stat Bar

struct StatBar: View {
    let label: String
    let value: Int
    let maxValue: Int
    let color: Color
    let animated: Bool

    @State private var animatedValue: CGFloat = 0

    init(label: String, value: Int, maxValue: Int = 100, color: Color, animated: Bool = true) {
        self.label = label
        self.value = value
        self.maxValue = maxValue
        self.color = color
        self.animated = animated
    }

    private var progress: CGFloat {
        CGFloat(value) / CGFloat(maxValue)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.theme.muted)

                Spacer()

                Text("\(value)")
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundStyle(color)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.theme.secondary)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * (animated ? animatedValue : progress))
                }
            }
            .frame(height: 8)
        }
        .onAppear {
            if animated {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                    animatedValue = progress
                }
            }
        }
    }
}

// MARK: - Stat Comparison Bar

struct StatComparisonBar: View {
    let label: String
    let currentValue: Int
    let potentialValue: Int
    let maxValue: Int

    @State private var showPotential = false

    init(label: String, current: Int, potential: Int, maxValue: Int = 100) {
        self.label = label
        self.currentValue = current
        self.potentialValue = potential
        self.maxValue = maxValue
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.theme.muted)

                Spacer()

                HStack(spacing: 4) {
                    Text("\(currentValue)")
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundStyle(Color.theme.destructive)

                    if showPotential {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.theme.muted)

                        Text("\(potentialValue)")
                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Color.theme.success)
                    }
                }
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.theme.secondary)

                    if showPotential {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.theme.success.opacity(0.3))
                            .frame(width: geometry.size.width * CGFloat(potentialValue) / CGFloat(maxValue))
                    }

                    RoundedRectangle(cornerRadius: 4)
                        .fill(showPotential ? Color.theme.destructive : Color.theme.destructive)
                        .frame(width: geometry.size.width * CGFloat(currentValue) / CGFloat(maxValue))
                }
            }
            .frame(height: 8)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.8)) {
                showPotential = true
            }
        }
    }
}

// MARK: - System Message Box

struct SystemMessage: View {
    let message: String
    let icon: String

    init(_ message: String, icon: String = "info.circle.fill") {
        self.message = message
        self.icon = icon
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.theme.accent)

            Text(message)
                .font(.system(size: 15))
                .foregroundStyle(Color.theme.foreground.opacity(0.9))
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .systemMessageBackground()
    }
}

// MARK: - System Message Background Modifier

private struct SystemMessageBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content
                .background(Color.theme.accent.opacity(0.1))
                .glassEffect(
                    .regular.tint(Color.theme.accent.opacity(0.15)),
                    in: .rect(cornerRadius: 12)
                )
        } else {
            content
                .background(LinearGradient.accentGradient)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.theme.accent.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

private extension View {
    func systemMessageBackground() -> some View {
        modifier(SystemMessageBackgroundModifier())
    }
}

// MARK: - Primary Button

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let isEnabled: Bool
    let action: () -> Void

    init(_ title: String, icon: String? = nil, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        if #available(iOS 26, *) {
            Button(action: action) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))

                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .buttonStyle(.glassProminent)
            .tint(isEnabled ? Color.theme.primary : Color.theme.secondary)
            .disabled(!isEnabled)
            .animation(.easeOut(duration: 0.2), value: isEnabled)
        } else {
            Button(action: action) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))

                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(isEnabled ? Color.theme.primaryForeground : Color.theme.muted)
                .background(isEnabled ? Color.theme.primary : Color.theme.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .disabled(!isEnabled)
            .animation(.easeOut(duration: 0.2), value: isEnabled)
        }
    }
}

// MARK: - Secondary Button

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        if #available(iOS 26, *) {
            Button(action: action) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.glass)
        } else {
            Button(action: action) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(Color.theme.foreground)
                    .background(Color.theme.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Onboarding Page Container

struct OnboardingPage<Content: View>: View {
    let title: String
    let subtitle: String?
    @ViewBuilder let content: () -> Content

    init(title: String, subtitle: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.theme.foreground)

                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.theme.muted)
                }
            }
            .padding(.bottom, 32)

            content()
        }
    }
}

// MARK: - Day Selector

struct DaySelector: View {
    @Binding var selectedDays: Set<Int>

    private let days = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        daySelectorContent
    }

    @ViewBuilder
    private var daySelectorContent: some View {
        if #available(iOS 26, *) {
            GlassEffectContainer(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(0..<7, id: \.self) { index in
                        let isSelected = selectedDays.contains(index)

                        Button {
                            if isSelected {
                                selectedDays.remove(index)
                            } else {
                                selectedDays.insert(index)
                            }
                        } label: {
                            Text(days[index])
                                .font(.system(size: 14, weight: .semibold))
                                .frame(width: 40, height: 40)
                                .foregroundStyle(isSelected ? Color.theme.accentForeground : Color.theme.foreground)
                                .background(isSelected ? Color.theme.accent : Color.clear)
                                .glassEffect(
                                    isSelected ? .regular.tint(Color.theme.accent).interactive() : .regular.interactive(),
                                    in: .circle
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        } else {
            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { index in
                    let isSelected = selectedDays.contains(index)

                    Button {
                        if isSelected {
                            selectedDays.remove(index)
                        } else {
                            selectedDays.insert(index)
                        }
                    } label: {
                        Text(days[index])
                            .font(.system(size: 14, weight: .semibold))
                            .frame(width: 40, height: 40)
                            .foregroundStyle(isSelected ? Color.theme.accentForeground : Color.theme.foreground)
                            .background(isSelected ? Color.theme.accent : Color.theme.card)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(isSelected ? Color.clear : Color.theme.border, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Number Stepper

struct NumberStepper: View {
    let label: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int

    init(_ label: String, value: Binding<Int>, range: ClosedRange<Int>, step: Int = 1) {
        self.label = label
        self._value = value
        self.range = range
        self.step = step
    }

    var body: some View {
        numberStepperContent
    }

    @ViewBuilder
    private var numberStepperContent: some View {
        if #available(iOS 26, *) {
            HStack {
                Text(label)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.theme.foreground)

                Spacer()

                GlassEffectContainer(spacing: 16) {
                    HStack(spacing: 16) {
                        Button {
                            if value - step >= range.lowerBound {
                                value -= step
                            }
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 14, weight: .semibold))
                                .frame(width: 32, height: 32)
                                .foregroundStyle(value > range.lowerBound ? Color.theme.foreground : Color.theme.muted)
                                .glassEffect(.regular.interactive(), in: .circle)
                        }
                        .buttonStyle(.plain)
                        .disabled(value <= range.lowerBound)

                        Text("\(value)")
                            .font(.system(size: 18, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Color.theme.foreground)
                            .frame(width: 50)

                        Button {
                            if value + step <= range.upperBound {
                                value += step
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .semibold))
                                .frame(width: 32, height: 32)
                                .foregroundStyle(value < range.upperBound ? Color.theme.foreground : Color.theme.muted)
                                .glassEffect(.regular.interactive(), in: .circle)
                        }
                        .buttonStyle(.plain)
                        .disabled(value >= range.upperBound)
                    }
                }
            }
            .padding(16)
            .glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            HStack {
                Text(label)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.theme.foreground)

                Spacer()

                HStack(spacing: 16) {
                    Button {
                        if value - step >= range.lowerBound {
                            value -= step
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(width: 32, height: 32)
                            .foregroundStyle(value > range.lowerBound ? Color.theme.foreground : Color.theme.muted)
                            .background(Color.theme.card)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .disabled(value <= range.lowerBound)

                    Text("\(value)")
                        .font(.system(size: 18, weight: .semibold, design: .monospaced))
                        .foregroundStyle(Color.theme.foreground)
                        .frame(width: 50)

                    Button {
                        if value + step <= range.upperBound {
                            value += step
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(width: 32, height: 32)
                            .foregroundStyle(value < range.upperBound ? Color.theme.foreground : Color.theme.muted)
                            .background(Color.theme.card)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .disabled(value >= range.upperBound)
                }
            }
            .padding(16)
            .background(Color.theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

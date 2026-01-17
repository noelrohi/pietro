//
//  Theme.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

// MARK: - Color Theme

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let background = Color(hex: "0a0a0b")
    let foreground = Color(hex: "fafafa")
    let card = Color(hex: "161618")
    let cardElevated = Color(hex: "1c1c1f")
    let primary = Color(hex: "38bdf8")
    let secondary = Color(hex: "0ea5e9")
    let muted = Color(hex: "71717a")
    let border = Color.white.opacity(0.06)
    let success = Color(hex: "22c55e")
    let amber = Color(hex: "f59e0b")
    let orange = Color(hex: "fb923c")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Gradients

extension LinearGradient {
    static let heroGradient = LinearGradient(
        colors: [Color(hex: "0ea5e9"), Color(hex: "38bdf8"), Color(hex: "7dd3fc")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "0ea5e9"), Color(hex: "38bdf8")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color(hex: "1c1c1f"), Color(hex: "161618")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let streakGradient = LinearGradient(
        colors: [Color(hex: "2d1f1a"), Color(hex: "1c1816")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static func categoryGradient(for category: WorkoutCategory) -> LinearGradient {
        switch category {
        case .push:
            return LinearGradient(
                colors: [Color(hex: "1a2a30"), Color(hex: "14191a")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .core:
            return LinearGradient(
                colors: [Color(hex: "2a2518"), Color(hex: "1a1814")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .pull:
            return LinearGradient(
                colors: [Color(hex: "1a2520"), Color(hex: "141a18")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - Category Colors

extension WorkoutCategory {
    var categoryColor: Color {
        switch self {
        case .push: return Color.theme.primary
        case .pull: return Color.theme.success
        case .core: return Color.theme.amber
        }
    }
    
    var borderColor: Color {
        categoryColor.opacity(0.15)
    }
}

// MARK: - View Modifiers

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(LinearGradient.cardGradient)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.theme.border, lineWidth: 1)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

// MARK: - Font Styles

extension Font {
    static let spaceGrotesk = Font.custom("SpaceGrotesk-Regular", size: 16)
    static let spaceGroteskMedium = Font.custom("SpaceGrotesk-Medium", size: 16)
    static let spaceGroteskSemiBold = Font.custom("SpaceGrotesk-SemiBold", size: 16)
    static let spaceGroteskBold = Font.custom("SpaceGrotesk-Bold", size: 16)
}

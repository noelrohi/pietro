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
    // MARK: - Base Colors

    let background = Color(hex: "0a0a0b")
    let foreground = Color(hex: "fafafa")
    let card = Color(hex: "161618")
    let cardElevated = Color(hex: "1c1c1f")
    let border = Color.white.opacity(0.06)

    // MARK: - Semantic Colors

    let primary = Color(hex: "7c3aed") // Purple accent
    let primaryForeground = Color(hex: "fafafa")
    let secondary = Color(hex: "27272a")
    let secondaryForeground = Color(hex: "fafafa")
    let accent = Color(hex: "3b82f6") // Blue system accent
    let accentForeground = Color(hex: "fafafa")
    let muted = Color(hex: "71717a")
    let mutedForeground = Color(hex: "a1a1aa")

    // MARK: - Status Colors

    let success = Color(hex: "22c55e")
    let successForeground = Color(hex: "052e16")
    let warning = Color(hex: "f59e0b")
    let warningForeground = Color(hex: "451a03")
    let destructive = Color(hex: "ef4444")
    let destructiveForeground = Color(hex: "fafafa")

    // MARK: - Stat Colors (RPG-inspired)

    let strength = Color(hex: "ef4444") // Red
    let vitality = Color(hex: "22c55e") // Green
    let agility = Color(hex: "3b82f6") // Blue
    let recovery = Color(hex: "a855f7") // Purple

    // MARK: - Rank Colors

    func rankColor(_ rank: HunterRank) -> Color {
        switch rank {
        case .e: return Color(hex: "6b7280") // Gray
        case .d: return Color(hex: "cd7f32") // Bronze
        case .c: return Color(hex: "c0c0c0") // Silver
        case .b: return Color(hex: "3b82f6") // Blue
        case .a: return Color(hex: "8b5cf6") // Purple
        case .s: return Color(hex: "fbbf24") // Gold
        }
    }
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

    // MARK: - Semantic Gradients

    static let accentGradient = LinearGradient(
        colors: [Color(hex: "1e3a5f"), Color(hex: "0f172a")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accentBorderGradient = LinearGradient(
        colors: [Color(hex: "3b82f6").opacity(0.5), Color(hex: "3b82f6").opacity(0.2)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let primaryGlowGradient = LinearGradient(
        colors: [Color(hex: "5b21b6"), Color(hex: "7c3aed")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let destructiveGradient = LinearGradient(
        colors: [Color(hex: "dc2626"), Color(hex: "ef4444")],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let successGradient = LinearGradient(
        colors: [Color(hex: "16a34a"), Color(hex: "22c55e")],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let warningGradient = LinearGradient(
        colors: [Color(hex: "d97706"), Color(hex: "fbbf24")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Category Colors

extension WorkoutCategory {
    var categoryColor: Color {
        switch self {
        case .push: return Color.theme.accent
        case .pull: return Color.theme.success
        case .core: return Color.theme.warning
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

//
//  HunterRank.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

// MARK: - Hunter Rank

enum HunterRank: String, Codable, CaseIterable, Comparable {
    case e = "E"
    case d = "D"
    case c = "C"
    case b = "B"
    case a = "A"
    case s = "S"

    // MARK: - Comparable

    static func < (lhs: HunterRank, rhs: HunterRank) -> Bool {
        lhs.numericValue < rhs.numericValue
    }

    private var numericValue: Int {
        switch self {
        case .e: return 0
        case .d: return 1
        case .c: return 2
        case .b: return 3
        case .a: return 4
        case .s: return 5
        }
    }

    // MARK: - XP Thresholds

    /// Total XP required to reach this rank
    var xpThreshold: Int {
        switch self {
        case .e: return 0
        case .d: return 500
        case .c: return 2000
        case .b: return 5000
        case .a: return 12000
        case .s: return 25000
        }
    }

    /// XP needed to advance from this rank to the next
    var xpToNextRank: Int? {
        guard let next = nextRank else { return nil }
        return next.xpThreshold - xpThreshold
    }

    /// The next rank after this one
    var nextRank: HunterRank? {
        switch self {
        case .e: return .d
        case .d: return .c
        case .c: return .b
        case .b: return .a
        case .a: return .s
        case .s: return nil
        }
    }

    /// Determine rank based on total XP
    static func rank(forTotalXP xp: Int) -> HunterRank {
        if xp >= HunterRank.s.xpThreshold { return .s }
        if xp >= HunterRank.a.xpThreshold { return .a }
        if xp >= HunterRank.b.xpThreshold { return .b }
        if xp >= HunterRank.c.xpThreshold { return .c }
        if xp >= HunterRank.d.xpThreshold { return .d }
        return .e
    }

    // MARK: - Display Properties

    var displayName: String {
        "Rank \(rawValue)"
    }

    var title: String {
        switch self {
        case .e: return "Awakened"
        case .d: return "Hunter"
        case .c: return "Warrior"
        case .b: return "Elite"
        case .a: return "Champion"
        case .s: return "Shadow Monarch"
        }
    }

    var subtitle: String {
        switch self {
        case .e: return "Your journey begins"
        case .d: return "Rising through the ranks"
        case .c: return "Proving your strength"
        case .b: return "Among the best"
        case .a: return "Near the pinnacle"
        case .s: return "The apex of power"
        }
    }

    // MARK: - Styling

    var color: Color {
        switch self {
        case .e: return Color(hex: "6b7280") // Gray
        case .d: return Color(hex: "cd7f32") // Bronze
        case .c: return Color(hex: "c0c0c0") // Silver
        case .b: return Color(hex: "3b82f6") // Blue
        case .a: return Color(hex: "8b5cf6") // Purple
        case .s: return Color(hex: "fbbf24") // Gold
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .e:
            return LinearGradient(
                colors: [Color(hex: "4b5563"), Color(hex: "6b7280")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .d:
            return LinearGradient(
                colors: [Color(hex: "b45309"), Color(hex: "cd7f32")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .c:
            return LinearGradient(
                colors: [Color(hex: "9ca3af"), Color(hex: "d1d5db")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .b:
            return LinearGradient(
                colors: [Color(hex: "2563eb"), Color(hex: "60a5fa")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .a:
            return LinearGradient(
                colors: [Color(hex: "7c3aed"), Color(hex: "a78bfa")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .s:
            return LinearGradient(
                colors: [Color(hex: "d97706"), Color(hex: "fbbf24"), Color(hex: "fde68a")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    var glowColor: Color {
        color.opacity(0.6)
    }

    var hasGlow: Bool {
        self == .s || self == .a
    }

    var backgroundGradient: LinearGradient {
        switch self {
        case .e:
            return LinearGradient(
                colors: [Color(hex: "1f1f1f"), Color(hex: "171717")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .d:
            return LinearGradient(
                colors: [Color(hex: "2a1f14"), Color(hex: "1a1410")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .c:
            return LinearGradient(
                colors: [Color(hex: "242428"), Color(hex: "1a1a1c")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .b:
            return LinearGradient(
                colors: [Color(hex: "141a2a"), Color(hex: "10141f")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .a:
            return LinearGradient(
                colors: [Color(hex: "1a142a"), Color(hex: "14101f")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .s:
            return LinearGradient(
                colors: [Color(hex: "2a2014"), Color(hex: "1f1810")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

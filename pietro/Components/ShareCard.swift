//
//  ShareCard.swift
//  pietro
//
//  Viral shareable achievement card - designed for Instagram stories
//

import SwiftUI

// MARK: - Share Card View

struct ShareCardView: View {
    let stats: UserStats
    let onShare: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            // The shareable card
            shareableCard
                .shadow(color: .black.opacity(0.2), radius: 40, y: 20)

            // Share button
            Button(action: onShare) {
                HStack(spacing: 10) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .semibold))

                    Text("Share")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundStyle(Color.theme.primary)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
            }
            .buttonStyle(.glass)
        }
    }

    // MARK: - The Shareable Card

    private var shareableCard: some View {
        VStack(spacing: 0) {
            // Top section with logo
            HStack {
                Spacer()

                Text("PIETRO")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(3)
                    .foregroundStyle(.white.opacity(0.5))

                Spacer()
            }
            .padding(.top, 24)

            Spacer()

            // Main stat - the hero
            VStack(spacing: 12) {
                Text("\(stats.totalWorkouts)")
                    .font(.system(size: 96, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("WORKOUTS")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(4)
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()

            // Bottom stats row
            HStack(spacing: 0) {
                ShareStatItem(value: "\(stats.currentStreak)", label: "STREAK")

                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 1, height: 32)

                ShareStatItem(value: "\(stats.totalMinutes)", label: "MINUTES")

                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 1, height: 32)

                ShareStatItem(value: "\(stats.bestStreak)", label: "BEST")
            }
            .padding(.bottom, 32)
        }
        .frame(width: 280, height: 400)
        .background {
            // Gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.12),
                    Color(red: 0.05, green: 0.05, blue: 0.07)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .overlay {
            // Subtle border
            RoundedRectangle(cornerRadius: 32)
                .strokeBorder(
                    LinearGradient(
                        colors: [.white.opacity(0.15), .white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
    }
}

// MARK: - Share Stat Item

private struct ShareStatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(label)
                .font(.system(size: 8, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Streak Share Card (Alternative)

struct StreakShareCard: View {
    let streak: Int

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Flame icon
            Image(systemName: "flame.fill")
                .font(.system(size: 48))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            // Streak number
            Text("\(streak)")
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.top, 8)

            Text("DAY STREAK")
                .font(.system(size: 11, weight: .bold))
                .tracking(3)
                .foregroundStyle(.white.opacity(0.5))
                .padding(.top, 4)

            Spacer()

            // Branding
            Text("PIETRO")
                .font(.system(size: 10, weight: .bold))
                .tracking(3)
                .foregroundStyle(.white.opacity(0.3))
                .padding(.bottom, 24)
        }
        .frame(width: 280, height: 360)
        .background {
            LinearGradient(
                colors: [
                    Color(red: 0.15, green: 0.08, blue: 0.05),
                    Color(red: 0.08, green: 0.04, blue: 0.02)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .strokeBorder(
                    LinearGradient(
                        colors: [.orange.opacity(0.3), .orange.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
    }
}

// MARK: - Milestone Share Card

struct MilestoneShareCard: View {
    let milestone: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Icon with glow
            ZStack {
                Image(systemName: icon)
                    .font(.system(size: 56))
                    .foregroundStyle(color.opacity(0.3))
                    .blur(radius: 20)

                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundStyle(color)
            }

            // Milestone text
            Text(milestone)
                .font(.system(size: 13, weight: .bold))
                .tracking(2)
                .foregroundStyle(.white)
                .padding(.top, 24)

            Text("UNLOCKED")
                .font(.system(size: 10, weight: .medium))
                .tracking(2)
                .foregroundStyle(.white.opacity(0.4))
                .padding(.top, 4)

            Spacer()

            // Branding
            Text("PIETRO")
                .font(.system(size: 10, weight: .bold))
                .tracking(3)
                .foregroundStyle(.white.opacity(0.3))
                .padding(.bottom, 24)
        }
        .frame(width: 280, height: 320)
        .background {
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.12),
                    Color(red: 0.05, green: 0.05, blue: 0.07)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .strokeBorder(
                    LinearGradient(
                        colors: [color.opacity(0.3), color.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
    }
}

// MARK: - Share Sheet Helper

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Render View to Image

extension View {
    @MainActor
    func renderAsImage() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = 3.0
        return renderer.uiImage
    }
}

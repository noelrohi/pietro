//
//  MotivationSelectionView.swift
//  pietro
//
//  Created by Noel Rohi on 1/17/26.
//

import SwiftUI

struct MotivationSelectionView: View {
    @Binding var selected: Set<String>
    let onContinue: () -> Void

    private let motivations = [
        ("Feel more confident", "sparkles"),
        ("Improve my health", "heart.fill"),
        ("Build strength", "dumbbell.fill"),
        ("Reduce stress", "leaf.fill"),
        ("Sleep better", "moon.fill"),
        ("Have more energy", "bolt.fill"),
        ("Look better", "person.fill"),
        ("Challenge myself", "flame.fill")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                OnboardingPage(
                    title: "What motivates you?",
                    subtitle: "Select all that apply"
                ) {
                    VStack(spacing: 10) {
                        ForEach(motivations, id: \.0) { motivation in
                            MultiSelectCard(
                                icon: motivation.1,
                                title: motivation.0,
                                isSelected: selected.contains(motivation.0)
                            ) {
                                if selected.contains(motivation.0) {
                                    selected.remove(motivation.0)
                                } else {
                                    selected.insert(motivation.0)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }

            VStack(spacing: 0) {
                PrimaryButton("Continue", icon: "arrow.right", isEnabled: !selected.isEmpty) {
                    onContinue()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
}

// MARK: - Flow Layout for chips

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                       y: bounds.minY + result.positions[index].y),
                          proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + rowHeight)
        }
    }
}

#Preview {
    MotivationSelectionView(selected: .constant([])) { }
        .background(Color.theme.background)
}

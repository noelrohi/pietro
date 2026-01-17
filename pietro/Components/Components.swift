//
//  Components.swift
//  pietro
//
//  Shared utility components
//

import SwiftUI

// MARK: - Grain Overlay

struct GrainOverlay: View {
    var body: some View {
        Canvas { context, size in
            for _ in 0..<Int(size.width * size.height * 0.03) {
                let x = Double.random(in: 0..<size.width)
                let y = Double.random(in: 0..<size.height)
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: 1, height: 1)),
                    with: .color(.white.opacity(Double.random(in: 0.02...0.05)))
                )
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

import SwiftUI

struct PathHelper {
    /// Creates a flowing S-curve path from bottom to top within the given rect.
    /// Returns the path and an array of 4 node positions along it.
    static func createMapPath(in rect: CGRect, nodeCount: Int = 4) -> (Path, [CGPoint]) {
        let path = Path { p in
            let w = rect.width
            let h = rect.height
            let topPadding: CGFloat = 50
            let bottomPadding: CGFloat = 100 // Extra room for labels below bottom node
            let startY = h - bottomPadding
            let endY = topPadding

            // Start at bottom center
            p.move(to: CGPoint(x: w * 0.5, y: startY))

            // Curve 1: bottom-center to right
            p.addCurve(
                to: CGPoint(x: w * 0.70, y: h * 0.62),
                control1: CGPoint(x: w * 0.5, y: h * 0.78),
                control2: CGPoint(x: w * 0.82, y: h * 0.70)
            )

            // Curve 2: right to left
            p.addCurve(
                to: CGPoint(x: w * 0.28, y: h * 0.36),
                control1: CGPoint(x: w * 0.55, y: h * 0.52),
                control2: CGPoint(x: w * 0.12, y: h * 0.45)
            )

            // Curve 3: left to top-center
            p.addCurve(
                to: CGPoint(x: w * 0.5, y: endY),
                control1: CGPoint(x: w * 0.42, y: h * 0.26),
                control2: CGPoint(x: w * 0.5, y: h * 0.15)
            )
        }

        // Calculate node positions along the path
        let fractions: [CGFloat] = [0.0, 0.33, 0.66, 1.0]
        var positions: [CGPoint] = []

        for frac in fractions {
            let pt = pointOnPath(path, at: frac)
            positions.append(pt)
        }

        return (path, positions)
    }

    /// Approximate a point on a path at a given fraction (0...1)
    static func pointOnPath(_ path: Path, at fraction: CGFloat) -> CGPoint {
        let trimmed = path.trimmedPath(from: 0, to: max(0.001, min(fraction, 1.0)))
        return trimmed.currentPoint ?? .zero
    }
}

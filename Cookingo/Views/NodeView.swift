import SwiftUI

struct NodeView: View {
    let node: CookingNode
    let stepNumber: Int
    let onTap: () -> Void

    @State private var ring1Scale: CGFloat = 1.0
    @State private var ring1Opacity: Double = 0.6
    @State private var ring2Scale: CGFloat = 1.0
    @State private var ring2Opacity: Double = 0.4
    @State private var sparkAngle: Double = 0
    @State private var tapBounce: CGFloat = 0
    @State private var completedScale: CGFloat = 0.5
    @State private var pressScale: CGFloat = 1.0

    private let nodeSize: CGFloat = 62
    private let greenColor = Color(red: 0.180, green: 0.800, blue: 0.443)
    private let darkGreen = Color(red: 0.133, green: 0.545, blue: 0.329)

    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                switch node.state {
                case .active:
                    activeNodeContent
                case .locked:
                    lockedNodeContent
                case .completed:
                    completedNodeContent
                }
            }
            .scaleEffect(pressScale)
            .onTapGesture {
                if node.state == .active {
                    withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
                        pressScale = 0.93
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            pressScale = 1.0
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        onTap()
                    }
                }
            }

            nodeLabel
        }
        .onAppear {
            if node.state == .active { startActiveAnimations() }
            if node.state == .completed { completedScale = 1.0 }
        }
        .onChange(of: node.state) { _, newState in
            if newState == .active { startActiveAnimations() }
            if newState == .completed {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    completedScale = 1.0
                }
            }
        }
    }

    // MARK: - Active Node
    private var activeNodeContent: some View {
        ZStack {
            Circle()
                .fill(greenColor.opacity(0.12))
                .frame(width: nodeSize + 40, height: nodeSize + 40)
                .blur(radius: 12)

            Circle()
                .stroke(greenColor.opacity(ring1Opacity), lineWidth: 2.5)
                .frame(width: nodeSize + 20, height: nodeSize + 20)
                .scaleEffect(ring1Scale)

            Circle()
                .stroke(greenColor.opacity(ring2Opacity), lineWidth: 2)
                .frame(width: nodeSize + 30, height: nodeSize + 30)
                .scaleEffect(ring2Scale)

            ForEach(0..<4, id: \.self) { i in
                sparkParticle(index: i)
            }

            // Node circle with gradient
            Circle()
                .fill(
                    LinearGradient(
                        colors: [greenColor, darkGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: nodeSize, height: nodeSize)
                .shadow(color: greenColor.opacity(0.4), radius: 8, y: 3)

            Circle()
                .fill(greenColor)
                .frame(width: nodeSize - 8, height: nodeSize - 8)

            Image(systemName: node.icon)
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(.white)

            // Play button
            Circle()
                .fill(Color.white)
                .frame(width: 20, height: 20)
                .overlay(
                    Image(systemName: "play.fill")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(greenColor)
                )
                .shadow(color: Color.black.opacity(0.12), radius: 3, y: 1)
                .offset(x: nodeSize / 2 - 6, y: -nodeSize / 2 + 6)
        }
    }

    // MARK: - Locked Node
    private var lockedNodeContent: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.08))
                .frame(width: nodeSize + 4, height: nodeSize + 4)

            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.88, green: 0.90, blue: 0.89), Color(red: 0.82, green: 0.85, blue: 0.83)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: nodeSize, height: nodeSize)
                .shadow(color: Color.gray.opacity(0.1), radius: 4, y: 2)

            Image(systemName: "lock.fill")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.gray.opacity(0.40))
        }
    }

    // MARK: - Completed Node
    private var completedNodeContent: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [greenColor, darkGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: nodeSize, height: nodeSize)
                .shadow(color: greenColor.opacity(0.3), radius: 6, y: 2)

            Image(systemName: "checkmark")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
        }
        .scaleEffect(completedScale)
    }

    // MARK: - Label
    private var nodeLabel: some View {
        VStack(spacing: 2) {
            Text(node.title)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(node.state == .locked ? Color.gray.opacity(0.40) : darkGreen)

            if node.state == .active {
                Text("Step \(stepNumber) · \(node.location)")
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .foregroundColor(greenColor.opacity(0.65))

                HStack(spacing: 3) {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 9))
                    Text("Tap to cook")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                }
                .foregroundColor(greenColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(greenColor.opacity(0.08))
                )
                .offset(y: tapBounce)
            } else if node.state == .completed {
                HStack(spacing: 2) {
                    Text("Step \(stepNumber)")
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 8))
                }
                .foregroundColor(darkGreen.opacity(0.5))
            } else {
                Text("Step \(stepNumber) · Locked")
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundColor(Color.gray.opacity(0.35))
            }
        }
    }

    // MARK: - Spark Particle
    private func sparkParticle(index: Int) -> some View {
        let colors: [Color] = [.green, .yellow, .orange, .mint]
        let baseAngle = Double(index) * 90.0
        let radius: CGFloat = nodeSize / 2 + 18

        return Circle()
            .fill(colors[index])
            .frame(width: 5, height: 5)
            .offset(
                x: cos((baseAngle + sparkAngle) * .pi / 180) * radius,
                y: sin((baseAngle + sparkAngle) * .pi / 180) * radius
            )
            .opacity(0.6 + 0.3 * sin((sparkAngle + Double(index) * 45) * .pi / 180))
    }

    // MARK: - Animations
    private func startActiveAnimations() {
        withAnimation(.easeInOut(duration: 1.9).repeatForever(autoreverses: true)) {
            ring1Scale = 1.25
            ring1Opacity = 0.0
        }
        withAnimation(.easeInOut(duration: 1.9).repeatForever(autoreverses: true).delay(0.4)) {
            ring2Scale = 1.35
            ring2Opacity = 0.0
        }
        withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
            sparkAngle = 360
        }
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            tapBounce = -4
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        NodeView(node: CookingNode.allNodes[0], stepNumber: 1, onTap: {})
        NodeView(node: CookingNode.allNodes[1], stepNumber: 2, onTap: {})
    }
    .padding()
    .background(Color(red: 0.941, green: 0.980, blue: 0.957))
}

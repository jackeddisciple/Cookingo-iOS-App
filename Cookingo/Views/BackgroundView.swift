import SwiftUI

struct BackgroundView: View {
    let currentNodeIndex: Int

    @State private var floatOffset1: CGFloat = 0
    @State private var floatOffset2: CGFloat = 0
    @State private var shimmer: Double = 0

    private let greenColor = Color(red: 0.180, green: 0.800, blue: 0.443)

    // Progression-based gradient colors
    private var gradientColors: [Color] {
        switch currentNodeIndex {
        case 0: // Home Kitchen — warm, cozy
            return [
                Color(red: 0.96, green: 0.97, blue: 0.94),
                Color(red: 0.95, green: 0.96, blue: 0.92),
                Color(red: 0.97, green: 0.95, blue: 0.91),
                Color(red: 0.96, green: 0.94, blue: 0.90)
            ]
        case 1: // Street Stall — fresh, vibrant
            return [
                Color(red: 0.93, green: 0.97, blue: 0.94),
                Color(red: 0.94, green: 0.98, blue: 0.95),
                Color(red: 0.92, green: 0.97, blue: 0.93),
                Color(red: 0.93, green: 0.96, blue: 0.92)
            ]
        case 2: // Restaurant — refined, cool
            return [
                Color(red: 0.94, green: 0.93, blue: 0.97),
                Color(red: 0.95, green: 0.94, blue: 0.98),
                Color(red: 0.93, green: 0.92, blue: 0.96),
                Color(red: 0.94, green: 0.93, blue: 0.97)
            ]
        default: // Fine Dining — warm gold, premium
            return [
                Color(red: 0.97, green: 0.95, blue: 0.91),
                Color(red: 0.96, green: 0.94, blue: 0.90),
                Color(red: 0.97, green: 0.93, blue: 0.88),
                Color(red: 0.96, green: 0.92, blue: 0.87)
            ]
        }
    }

    var body: some View {
        ZStack {
            // Base gradient — shifts with progression
            LinearGradient(
                colors: gradientColors,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 1.2), value: currentNodeIndex)

            // Soft color blobs
            Circle()
                .fill(
                    RadialGradient(
                        colors: [greenColor.opacity(0.12), greenColor.opacity(0.0)],
                        center: .center,
                        startRadius: 20,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)
                .offset(x: -60, y: -220)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.yellow.opacity(0.10), Color.yellow.opacity(0.0)],
                        center: .center,
                        startRadius: 20,
                        endRadius: 130
                    )
                )
                .frame(width: 260, height: 260)
                .offset(x: 100, y: 80)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.orange.opacity(0.08), Color.orange.opacity(0.0)],
                        center: .center,
                        startRadius: 15,
                        endRadius: 110
                    )
                )
                .frame(width: 220, height: 220)
                .offset(x: -80, y: 300)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.mint.opacity(0.08), Color.mint.opacity(0.0)],
                        center: .center,
                        startRadius: 15,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)
                .offset(x: 130, y: -100)

            // Kitchen icons
            kitchenIcon("fork.knife", x: -130, y: -300, rotation: -15, size: 24)
            kitchenIcon("frying.pan", x: 140, y: -200, rotation: 20, size: 22)
            kitchenIcon("cup.and.saucer", x: -110, y: 30, rotation: -10, size: 20)
            kitchenIcon("carrot", x: 150, y: 230, rotation: 25, size: 22)
            kitchenIcon("fork.knife", x: -90, y: 160, rotation: 15, size: 18)
            kitchenIcon("frying.pan", x: 110, y: -60, rotation: -20, size: 22)
            kitchenIcon("leaf", x: 160, y: 350, rotation: 30, size: 16)
            kitchenIcon("flame", x: -50, y: -150, rotation: -5, size: 18)

            // Floating particles
            floatingParticle(size: 5, x: -60, startY: 300, opacity: 0.08, offset: floatOffset1)
            floatingParticle(size: 4, x: 80, startY: 200, opacity: 0.07, offset: floatOffset2)
            floatingParticle(size: 5, x: -120, startY: 100, opacity: 0.06, offset: floatOffset1 * 0.8)
            floatingParticle(size: 6, x: 140, startY: 350, opacity: 0.07, offset: floatOffset2 * 0.9)

            // Top shimmer
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.06 + shimmer * 0.03),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
                .ignoresSafeArea()
        }
        .onAppear {
            startAnimations()
        }
    }

    private func kitchenIcon(_ name: String, x: CGFloat, y: CGFloat, rotation: Double, size: CGFloat) -> some View {
        Image(systemName: name)
            .font(.system(size: size, weight: .light))
            .foregroundColor(greenColor)
            .rotationEffect(.degrees(rotation))
            .opacity(0.07)
            .offset(x: x, y: y)
    }

    private func floatingParticle(size: CGFloat, x: CGFloat, startY: CGFloat, opacity: Double, offset: CGFloat) -> some View {
        Circle()
            .fill(greenColor)
            .frame(width: size, height: size)
            .opacity(opacity)
            .offset(x: x, y: startY + offset)
    }

    private func startAnimations() {
        withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
            floatOffset1 = -35
        }
        withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true).delay(1.0)) {
            floatOffset2 = -30
        }
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            shimmer = 1.0
        }
    }
}

#Preview {
    BackgroundView(currentNodeIndex: 0)
}

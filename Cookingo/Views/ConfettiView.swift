import SwiftUI

struct ConfettiView: View {
    let origin: CGPoint
    @State private var particles: [ConfettiParticle] = []
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                ConfettiPiece(particle: particle)
                    .rotationEffect(.degrees(animate ? particle.endRotation : 0))
                    .position(
                        x: animate ? origin.x + particle.endX : origin.x,
                        y: animate ? origin.y + particle.endY : origin.y
                    )
                    .opacity(animate ? 0 : 1)
            }
        }
        .onAppear {
            generateParticles()
            withAnimation(.easeOut(duration: 1.1)) {
                animate = true
            }
        }
        .allowsHitTesting(false)
    }

    private func generateParticles() {
        let colors: [Color] = [
            Color(red: 0.180, green: 0.800, blue: 0.443),
            Color.yellow,
            Color.orange,
            Color.blue,
            Color.purple,
            Color.red,
            Color.mint,
            Color.pink
        ]

        particles = (0..<18).map { i in
            let angle = Double.random(in: 0...(2 * .pi))
            let distance = CGFloat.random(in: 60...160)

            return ConfettiParticle(
                id: i,
                color: colors[i % colors.count],
                size: CGFloat.random(in: 5...10),
                endX: cos(angle) * distance,
                endY: sin(angle) * distance - 30,
                endRotation: Double.random(in: 180...720),
                isCircle: Bool.random()
            )
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id: Int
    let color: Color
    let size: CGFloat
    let endX: CGFloat
    let endY: CGFloat
    let endRotation: Double
    let isCircle: Bool
}

struct ConfettiPiece: View {
    let particle: ConfettiParticle

    var body: some View {
        Group {
            if particle.isCircle {
                Circle()
                    .fill(particle.color)
            } else {
                RoundedRectangle(cornerRadius: 1)
                    .fill(particle.color)
            }
        }
        .frame(width: particle.size, height: particle.size)
    }
}

#Preview {
    ConfettiView(origin: CGPoint(x: 200, y: 400))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.941, green: 0.980, blue: 0.957))
}

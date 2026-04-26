import SwiftUI

struct ChefAvatarView: View {
    let isRunning: Bool

    // Idle
    @State private var bobOffset: CGFloat = 0

    // Running
    @State private var leftLegAngle: Double = 0
    @State private var rightLegAngle: Double = 0
    @State private var leftArmAngle: Double = 0
    @State private var rightArmAngle: Double = 0
    @State private var runBounce: CGFloat = 0
    @State private var bodyTilt: Double = 0

    // Dust particles
    @State private var showDust: Bool = false
    @State private var dustOpacity1: Double = 0
    @State private var dustOpacity2: Double = 0
    @State private var dustOpacity3: Double = 0
    @State private var dustOffset1: CGFloat = 0
    @State private var dustOffset2: CGFloat = 0
    @State private var dustOffset3: CGFloat = 0

    private let greenColor = Color(red: 0.180, green: 0.800, blue: 0.443)

    var body: some View {
        ZStack {
            // Dust trail (behind chef)
            if isRunning {
                dustTrail
            }

            VStack(spacing: 0) {
                // Chef body
                chefBody
                    .offset(y: isRunning ? runBounce : bobOffset)
                    .rotationEffect(.degrees(isRunning ? bodyTilt : 0), anchor: .bottom)

                // Shadow
                Ellipse()
                    .fill(Color.black.opacity(isRunning ? 0.06 : 0.1))
                    .frame(width: isRunning ? 26 : 32, height: isRunning ? 6 : 8)
                    .blur(radius: 2)
                    .offset(y: -2)
            }
        }
        .onAppear {
            startIdleAnimation()
        }
        .onChange(of: isRunning) { _, running in
            if running {
                startRunAnimation()
            } else {
                stopRunAnimation()
                startIdleAnimation()
            }
        }
    }

    // MARK: - Dust Trail
    private var dustTrail: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 8, height: 8)
                .offset(x: dustOffset1, y: 35)
                .opacity(dustOpacity1)

            Circle()
                .fill(Color.gray.opacity(0.15))
                .frame(width: 6, height: 6)
                .offset(x: dustOffset2, y: 38)
                .opacity(dustOpacity2)

            Circle()
                .fill(Color.gray.opacity(0.12))
                .frame(width: 5, height: 5)
                .offset(x: dustOffset3, y: 32)
                .opacity(dustOpacity3)
        }
    }

    // MARK: - Chef Body
    private var chefBody: some View {
        VStack(spacing: 0) {
            // Chef hat
            ZStack {
                // Hat puff (taller, more visible)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 28, height: 14)
                    .offset(y: -3)
                    .shadow(color: Color.gray.opacity(0.1), radius: 2, y: 1)

                Ellipse()
                    .fill(Color.white)
                    .frame(width: 34, height: 14)
                    .shadow(color: Color.gray.opacity(0.12), radius: 2, y: 1)

                // Hat band
                Rectangle()
                    .fill(greenColor)
                    .frame(width: 32, height: 4)
                    .offset(y: 5)
            }
            .offset(y: 2)

            // Face
            ZStack {
                // Head
                Circle()
                    .fill(Color(red: 1.0, green: 0.87, blue: 0.77))
                    .frame(width: 32, height: 32)
                    .shadow(color: Color(red: 1.0, green: 0.87, blue: 0.77).opacity(0.3), radius: 2, y: 1)

                // Eyes — change expression when running
                if isRunning {
                    // Determined eyes (slightly squinted)
                    HStack(spacing: 8) {
                        Capsule()
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .frame(width: 5, height: 3)
                        Capsule()
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .frame(width: 5, height: 3)
                    }
                    .offset(y: -2)
                } else {
                    // Normal eyes
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .frame(width: 4.5, height: 4.5)
                        Circle()
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .frame(width: 4.5, height: 4.5)
                    }
                    .offset(y: -2)
                }

                // Rosy cheeks
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color.pink.opacity(0.3))
                        .frame(width: 7, height: 7)
                    Circle()
                        .fill(Color.pink.opacity(0.3))
                        .frame(width: 7, height: 7)
                }
                .offset(y: 3)

                // Smile — wider when running (excited)
                Path { path in
                    let smileWidth: CGFloat = isRunning ? 7 : 5
                    path.addArc(
                        center: CGPoint(x: 16, y: 18),
                        radius: smileWidth,
                        startAngle: .degrees(10),
                        endAngle: .degrees(170),
                        clockwise: true
                    )
                }
                .stroke(Color(red: 0.3, green: 0.2, blue: 0.2), lineWidth: 1.5)
                .frame(width: 32, height: 32)
            }

            // Body with arms
            ZStack {
                // Torso / Apron
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color.white)
                    .frame(width: 26, height: 18)
                    .shadow(color: Color.gray.opacity(0.08), radius: 1, y: 1)

                // Apron detail
                VStack(spacing: 2) {
                    Rectangle()
                        .fill(greenColor.opacity(0.5))
                        .frame(width: 18, height: 2)
                    Rectangle()
                        .fill(greenColor.opacity(0.3))
                        .frame(width: 14, height: 1)
                }
                .offset(y: -2)

                // Left arm
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 1.0, green: 0.87, blue: 0.77))
                    .frame(width: 6, height: 14)
                    .rotationEffect(.degrees(leftArmAngle), anchor: .top)
                    .offset(x: -16, y: 0)

                // Right arm
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 1.0, green: 0.87, blue: 0.77))
                    .frame(width: 6, height: 14)
                    .rotationEffect(.degrees(rightArmAngle), anchor: .top)
                    .offset(x: 16, y: 0)
            }

            // Legs (bigger, more visible)
            HStack(spacing: 5) {
                // Left leg
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 0.25, green: 0.25, blue: 0.35))
                    .frame(width: 7, height: 14)
                    .rotationEffect(.degrees(leftLegAngle), anchor: .top)

                // Right leg
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 0.25, green: 0.25, blue: 0.35))
                    .frame(width: 7, height: 14)
                    .rotationEffect(.degrees(rightLegAngle), anchor: .top)
            }

            // Shoes
            HStack(spacing: isRunning ? 14 : 5) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 0.45, green: 0.30, blue: 0.20))
                    .frame(width: 9, height: 5)
                    .rotationEffect(.degrees(leftLegAngle * 0.5), anchor: .top)

                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 0.45, green: 0.30, blue: 0.20))
                    .frame(width: 9, height: 5)
                    .rotationEffect(.degrees(rightLegAngle * 0.5), anchor: .top)
            }
        }
    }

    // MARK: - Animations
    private func startIdleAnimation() {
        withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
            bobOffset = -7
        }
    }

    private func startRunAnimation() {
        bobOffset = 0

        // Legs — wide, fast swing
        withAnimation(.easeInOut(duration: 0.12).repeatForever(autoreverses: true)) {
            leftLegAngle = 35
            rightLegAngle = -35
        }

        // Arms — swing opposite to legs
        withAnimation(.easeInOut(duration: 0.12).repeatForever(autoreverses: true)) {
            leftArmAngle = -30
            rightArmAngle = 30
        }

        // Body bounce — small vertical oscillation
        withAnimation(.easeInOut(duration: 0.12).repeatForever(autoreverses: true)) {
            runBounce = -3
        }

        // Body tilt forward
        withAnimation(.easeOut(duration: 0.2)) {
            bodyTilt = -8
        }

        // Dust particles
        showDust = true
        startDustAnimation()
    }

    private func stopRunAnimation() {
        withAnimation(.easeOut(duration: 0.25)) {
            leftLegAngle = 0
            rightLegAngle = 0
            leftArmAngle = 0
            rightArmAngle = 0
            runBounce = 0
            bodyTilt = 0
        }
        showDust = false
        dustOpacity1 = 0
        dustOpacity2 = 0
        dustOpacity3 = 0
    }

    private func startDustAnimation() {
        // Dust puff 1
        withAnimation(.easeOut(duration: 0.4).repeatForever(autoreverses: false)) {
            dustOpacity1 = 0.5
            dustOffset1 = -12
        }
        // Dust puff 2 (delayed)
        withAnimation(.easeOut(duration: 0.4).repeatForever(autoreverses: false).delay(0.13)) {
            dustOpacity2 = 0.4
            dustOffset2 = 8
        }
        // Dust puff 3 (more delayed)
        withAnimation(.easeOut(duration: 0.4).repeatForever(autoreverses: false).delay(0.26)) {
            dustOpacity3 = 0.3
            dustOffset3 = -6
        }
    }
}

#Preview {
    VStack(spacing: 60) {
        Text("Idle").font(.caption)
        ChefAvatarView(isRunning: false)
        Text("Running").font(.caption)
        ChefAvatarView(isRunning: true)
    }
    .padding()
    .background(Color(red: 0.941, green: 0.980, blue: 0.957))
}

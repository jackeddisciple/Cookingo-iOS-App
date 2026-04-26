import SwiftUI

struct TopBarView: View {
    let xp: Int
    let streak: Int
    let xpPulse: Bool
    let levelTitle: String
    let location: String

    private let greenColor = Color(red: 0.180, green: 0.800, blue: 0.443)
    private let darkGreen = Color(red: 0.133, green: 0.545, blue: 0.329)

    var body: some View {
        VStack(spacing: 0) {
            // Main bar
            HStack(spacing: 0) {
                // Left: Logo + Level
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 0) {
                        Text("Cook")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        Text("ingo")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(red: 1.0, green: 0.85, blue: 0.40))
                    }
                    .fixedSize()

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 9, weight: .semibold))
                        Text(location)
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                // Right: Stats + Avatar
                HStack(spacing: 8) {
                    // XP Badge
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(red: 1.0, green: 0.85, blue: 0.35))
                        Text("\(xp)")
                            .font(.system(size: 13, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                    )
                    .scaleEffect(xpPulse ? 1.12 : 1.0)

                    // Streak Badge
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.2))
                        Text("\(streak)")
                            .font(.system(size: 13, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                    )

                    // Avatar
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 36, height: 36)

                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.9), Color.white.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 32, height: 32)

                        Image(systemName: "person.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(darkGreen)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                ZStack {
                    // Rich gradient background
                    RoundedRectangle(cornerRadius: 22)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.15, green: 0.65, blue: 0.38),
                                    Color(red: 0.12, green: 0.55, blue: 0.32),
                                    Color(red: 0.10, green: 0.48, blue: 0.28)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    // Subtle inner highlight
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.25), Color.white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
                .shadow(color: darkGreen.opacity(0.4), radius: 12, y: 6)
            )
        }
        .padding(.horizontal, 14)
    }
}

#Preview {
    ZStack {
        Color(red: 0.941, green: 0.980, blue: 0.957).ignoresSafeArea()
        VStack {
            TopBarView(xp: 1240, streak: 7, xpPulse: false, levelTitle: "Home Chef", location: "Home Kitchen")
                .padding(.top, 50)
            Spacer()
        }
    }
}

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    private let greenColor = Color(red: 0.180, green: 0.800, blue: 0.443)
    private let darkGreen = Color(red: 0.133, green: 0.545, blue: 0.329)

    var body: some View {
        ZStack {
            // Background — world-aware
            BackgroundView(currentNodeIndex: viewModel.currentNodeIndex)

            // Main layout
            VStack(spacing: 0) {
                // Top Bar
                TopBarView(
                    xp: viewModel.xp,
                    streak: viewModel.streak,
                    xpPulse: viewModel.xpPulse,
                    levelTitle: viewModel.currentLevelTitle,
                    location: viewModel.currentLocation
                )
                .padding(.top, 8)

                // Map Area
                MapView(viewModel: viewModel)
                    .padding(.top, 4)

                // Bottom Tab Bar
                BottomTabBar(selectedTab: $viewModel.selectedTab)
                    .padding(.bottom, 8)
            }

            // MARK: - Overlays

            if viewModel.showConfetti {
                ConfettiView(origin: viewModel.confettiOrigin)
                    .ignoresSafeArea()
            }

            if viewModel.showXPFloat {
                XPFloatView(origin: viewModel.xpFloatOrigin)
                    .ignoresSafeArea()
            }

            if viewModel.showChallenge {
                ChallengeSheet(
                    viewModel: viewModel,
                    challenge: viewModel.nodes[viewModel.currentNodeIndex].challenge,
                    stepNumber: viewModel.currentNodeIndex + 1
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(10)
            }

            if viewModel.allCompleted {
                allCompletedOverlay
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(20)
            }
        }
        .animation(.spring(response: 0.38, dampingFraction: 0.85), value: viewModel.showChallenge)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.allCompleted)
    }

    // MARK: - Completion Overlay
    private var allCompletedOverlay: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Trophy icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.85, blue: 0.35), Color(red: 0.95, green: 0.70, blue: 0.20)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: Color.orange.opacity(0.3), radius: 12, y: 4)

                    Image(systemName: "trophy.fill")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(spacing: 6) {
                    Text("Master Chef!")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))

                    Text("You completed the entire cooking journey!")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }

                // XP Summary
                HStack(spacing: 16) {
                    statBadge(icon: "star.fill", value: "\(viewModel.xp) XP", color: Color(red: 0.85, green: 0.70, blue: 0.20))
                    statBadge(icon: "flame.fill", value: "\(viewModel.streak) Day", color: Color.orange)
                    statBadge(icon: "checkmark.seal.fill", value: "4/4", color: greenColor)
                }

                // Play Again Button
                Button {
                    viewModel.resetGame()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 14, weight: .bold))
                        Text("Play Again")
                            .font(.system(size: 16, weight: .heavy, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [greenColor, darkGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: greenColor.opacity(0.4), radius: 8, y: 4)
                    )
                }
                .padding(.top, 4)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.15), radius: 24, y: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.gray.opacity(0.08), lineWidth: 1)
            )
            .padding(.horizontal, 32)
        }
    }

    private func statBadge(icon: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
        .frame(width: 70, height: 55)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(color.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.15), lineWidth: 0.5)
        )
    }
}

#Preview {
    ContentView()
}

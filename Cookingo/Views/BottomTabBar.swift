import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: Int

    private let greenColor = Color(red: 0.180, green: 0.800, blue: 0.443)
    private let darkGreen = Color(red: 0.133, green: 0.545, blue: 0.329)

    var body: some View {
        HStack(spacing: 0) {
            tabItem(icon: "map.fill", label: "Map", index: 0)
            tabItem(icon: "fork.knife", label: "Kitchen", index: 1)
            tabItem(icon: "person.fill", label: "Profile", index: 2)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 6)
        .padding(.bottom, 2)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 26)
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

                RoundedRectangle(cornerRadius: 26)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
            .shadow(color: darkGreen.opacity(0.4), radius: 12, y: 6)
        )
        .padding(.horizontal, 14)
    }

    private func tabItem(icon: String, label: String, index: Int) -> some View {
        let isActive = selectedTab == index

        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: isActive ? .bold : .medium))
                    .foregroundColor(isActive ? .white : .white.opacity(0.45))

                Text(label)
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundColor(isActive ? .white : .white.opacity(0.40))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                Group {
                    if isActive {
                        Capsule()
                            .fill(Color.white.opacity(0.18))
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color(red: 0.941, green: 0.980, blue: 0.957).ignoresSafeArea()
        VStack {
            Spacer()
            BottomTabBar(selectedTab: .constant(0))
                .padding(.bottom, 20)
        }
    }
}

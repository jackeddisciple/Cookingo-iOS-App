import SwiftUI

struct XPFloatView: View {
    let origin: CGPoint
    @State private var opacity: Double = 0
    @State private var offsetY: CGFloat = 0

    var body: some View {
        HStack(spacing: 4) {
            Text("+10 XP")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundColor(Color(red: 0.55, green: 0.45, blue: 0.0))
            Image(systemName: "star.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(red: 0.75, green: 0.60, blue: 0.0))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.yellow.opacity(0.25))
        )
        .position(x: origin.x, y: origin.y - 40)
        .offset(y: offsetY)
        .opacity(opacity)
        .onAppear {
            // Fade in
            withAnimation(.easeIn(duration: 0.3)) {
                opacity = 1.0
            }
            // Move up
            withAnimation(.easeOut(duration: 1.6)) {
                offsetY = -50
            }
            // Fade out
            withAnimation(.easeIn(duration: 0.5).delay(1.1)) {
                opacity = 0
            }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    XPFloatView(origin: CGPoint(x: 200, y: 400))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.941, green: 0.980, blue: 0.957))
}

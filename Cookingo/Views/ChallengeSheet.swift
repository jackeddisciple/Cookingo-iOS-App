import SwiftUI

struct ChallengeSheet: View {
    @ObservedObject var viewModel: GameViewModel
    let challenge: Challenge
    let stepNumber: Int

    @State private var shakeWrongId: Int? = nil
    @State private var offset: CGFloat = 0

    private let greenColor = Color(red: 0.180, green: 0.800, blue: 0.443)
    private let darkGreen = Color(red: 0.153, green: 0.682, blue: 0.376)

    var body: some View {
        ZStack(alignment: .bottom) {
            // Dimmed backdrop
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.dismissChallenge()
                }

            // Sheet content
            VStack(spacing: 0) {
                // Drag handle
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)
                    .padding(.bottom, 16)

                // Step chip
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12, weight: .bold))
                    Text("STEP \(stepNumber)")
                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                }
                .foregroundColor(greenColor)
                .padding(.horizontal, 14)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(greenColor.opacity(0.1))
                )
                .padding(.bottom, 8)

                // Section label
                Text("CURRENT CHALLENGE")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(Color.gray.opacity(0.5))
                    .tracking(1.5)
                    .padding(.bottom, 6)

                // Title
                Text(viewModel.nodes[viewModel.currentNodeIndex].title)
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .padding(.bottom, 6)

                // Question
                Text(challenge.question)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)

                // Answer choices
                VStack(spacing: 12) {
                    ForEach(challenge.choices) { choice in
                        choiceButton(choice)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.12), radius: 20, y: -5)
            )
            .offset(y: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            offset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > 100 {
                            viewModel.dismissChallenge()
                        } else {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                offset = 0
                            }
                        }
                    }
            )
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private func choiceButton(_ choice: ChoiceOption) -> some View {
        let isSelected = viewModel.selectedChoiceId == choice.id
        let isCorrect = viewModel.answerResult == .correct && isSelected
        let isWrong = viewModel.answerResult == .wrong && isSelected

        return Button {
            viewModel.selectAnswer(choice.id)
            if viewModel.answerResult == .wrong {
                shakeWrongId = choice.id
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    shakeWrongId = nil
                }
            }
        } label: {
            HStack(spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            isCorrect ? Color.white.opacity(0.25) :
                            isWrong ? Color.white.opacity(0.25) :
                            greenColor.opacity(0.12)
                        )
                        .frame(width: 36, height: 36)

                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: choice.icon)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(
                                isWrong ? .white : greenColor
                            )
                    }
                }

                Text(choice.text)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(
                        isCorrect ? Color.white :
                        isWrong ? Color.white :
                        Color(red: 0.2, green: 0.2, blue: 0.2)
                    )

                Spacer()

                // Arrow indicator
                if !isSelected {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.gray.opacity(0.3))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isCorrect ? greenColor :
                        isWrong ? Color.red.opacity(0.85) :
                        Color(red: 0.941, green: 0.980, blue: 0.957)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isCorrect ? greenColor :
                        isWrong ? Color.red :
                        greenColor.opacity(0.3),
                        lineWidth: isSelected ? 2.5 : 1.5
                    )
            )
        }
        .buttonStyle(.plain)
        .offset(x: shakeWrongId == choice.id ? shakeOffset() : 0)
        .animation(
            shakeWrongId == choice.id ?
                .default.speed(4).repeatCount(4, autoreverses: true) : .default,
            value: shakeWrongId
        )
    }

    private func shakeOffset() -> CGFloat {
        return 8
    }
}

#Preview {
    ZStack {
        Color(red: 0.941, green: 0.980, blue: 0.957)
            .ignoresSafeArea()

        ChallengeSheet(
            viewModel: GameViewModel(),
            challenge: CookingNode.allNodes[0].challenge,
            stepNumber: 1
        )
    }
}

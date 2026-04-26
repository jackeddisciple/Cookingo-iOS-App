import SwiftUI

@MainActor
final class GameViewModel: ObservableObject {
    // MARK: - Published State
    @Published var nodes: [CookingNode] = CookingNode.allNodes
    @Published var currentNodeIndex: Int = 0
    @Published var xp: Int = 0
    @Published var streak: Int = 7
    @Published var selectedTab: Int = 0

    // Challenge sheet
    @Published var showChallenge: Bool = false
    @Published var selectedChoiceId: Int? = nil
    @Published var answerResult: AnswerResult? = nil

    // Celebration
    @Published var showConfetti: Bool = false
    @Published var confettiOrigin: CGPoint = .zero
    @Published var showXPFloat: Bool = false
    @Published var xpFloatOrigin: CGPoint = .zero

    // Avatar
    @Published var avatarNodeIndex: Int = 0
    @Published var isAvatarRunning: Bool = false

    // XP pulse
    @Published var xpPulse: Bool = false

    // Path progress (0.0 to 1.0)
    @Published var pathProgress: CGFloat = 0.0

    // All nodes completed
    @Published var allCompleted: Bool = false

    enum AnswerResult {
        case correct
        case wrong
    }

    // MARK: - Node Positions (set by MapView)
    var nodePositions: [CGPoint] = []

    // MARK: - Computed
    var currentNode: CookingNode {
        nodes[currentNodeIndex]
    }

    var currentLevelTitle: String {
        nodes[currentNodeIndex].levelTitle
    }

    var currentLocation: String {
        nodes[currentNodeIndex].location
    }

    // MARK: - Actions

    func tapActiveNode() {
        guard nodes[currentNodeIndex].state == .active else { return }
        showChallenge = true
        selectedChoiceId = nil
        answerResult = nil
    }

    func selectAnswer(_ choiceId: Int) {
        guard answerResult == nil else { return }
        selectedChoiceId = choiceId

        let challenge = nodes[currentNodeIndex].challenge
        if choiceId == challenge.choices[challenge.correctIndex].id {
            answerResult = .correct
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.dismissAndCelebrate()
            }
        } else {
            answerResult = .wrong
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.selectedChoiceId = nil
                self.answerResult = nil
            }
        }
    }

    func dismissChallenge() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            showChallenge = false
        }
    }

    func resetGame() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            allCompleted = false
            nodes = CookingNode.allNodes
            currentNodeIndex = 0
            avatarNodeIndex = 0
            pathProgress = 0.0
            xp = 0
        }
    }

    private func dismissAndCelebrate() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            showChallenge = false
        }

        if nodePositions.count > currentNodeIndex {
            confettiOrigin = nodePositions[currentNodeIndex]
            xpFloatOrigin = nodePositions[currentNodeIndex]
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.showConfetti = true
            self.showXPFloat = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                self.xp += 10
                self.xpPulse = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.xpPulse = false
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.moveAvatarToNextNode()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showConfetti = false
            self.showXPFloat = false
        }
    }

    private func moveAvatarToNextNode() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            nodes[currentNodeIndex].state = .completed
        }

        let nextProgress = CGFloat(currentNodeIndex + 1) / CGFloat(max(nodes.count - 1, 1))
        withAnimation(.easeOut(duration: 0.7)) {
            pathProgress = min(nextProgress, 1.0)
        }

        isAvatarRunning = true
        withAnimation(.spring(response: 0.9, dampingFraction: 0.72)) {
            if currentNodeIndex + 1 < nodes.count {
                avatarNodeIndex = currentNodeIndex + 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
            self.isAvatarRunning = false

            if self.currentNodeIndex + 1 < self.nodes.count {
                self.currentNodeIndex += 1
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    self.nodes[self.currentNodeIndex].state = .active
                }
            } else {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    self.allCompleted = true
                }
            }
        }
    }
}

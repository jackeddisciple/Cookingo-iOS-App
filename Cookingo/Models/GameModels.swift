import SwiftUI

// MARK: - Node State
enum NodeState: Equatable {
    case active
    case locked
    case completed
}

// MARK: - Challenge
struct Challenge: Identifiable, Equatable {
    let id: Int
    let question: String
    let choices: [ChoiceOption]
    let correctIndex: Int
}

struct ChoiceOption: Identifiable, Equatable {
    let id: Int
    let icon: String
    let text: String
}

// MARK: - Cooking Node
struct CookingNode: Identifiable, Equatable {
    let id: Int
    let title: String
    let icon: String
    var state: NodeState
    let challenge: Challenge
    // Location-based progression
    let location: String
    let locationIcon: String
    let levelTitle: String
    let environmentTint: EnvironmentTint
}

// MARK: - Environment Tint
struct EnvironmentTint: Equatable {
    let primary: Color
    let secondary: Color
    let accent: Color
}

// MARK: - Hardcoded Data
extension CookingNode {
    static let allNodes: [CookingNode] = [
        CookingNode(
            id: 0,
            title: "Crack Eggs",
            icon: "oval.portrait",
            state: .active,
            challenge: Challenge(
                id: 0,
                question: "Crack 2 eggs into a bowl. Which is correct?",
                choices: [
                    ChoiceOption(id: 0, icon: "oval.portrait", text: "Crack eggs into bowl"),
                    ChoiceOption(id: 1, icon: "frying.pan", text: "Fry directly in pan"),
                    ChoiceOption(id: 2, icon: "cup.and.saucer", text: "Mix with milk first")
                ],
                correctIndex: 0
            ),
            location: "Home Kitchen",
            locationIcon: "house.fill",
            levelTitle: "Home Chef",
            environmentTint: EnvironmentTint(
                primary: Color(red: 0.95, green: 0.92, blue: 0.85),
                secondary: Color(red: 0.85, green: 0.78, blue: 0.65),
                accent: Color.orange.opacity(0.15)
            )
        ),
        CookingNode(
            id: 1,
            title: "Mix Ingredients",
            icon: "takeoutbag.and.cup.and.straw",
            state: .locked,
            challenge: Challenge(
                id: 1,
                question: "Mix eggs and flour. What tool is best?",
                choices: [
                    ChoiceOption(id: 0, icon: "takeoutbag.and.cup.and.straw", text: "Whisk in bowl"),
                    ChoiceOption(id: 1, icon: "hand.raised", text: "Use hands only"),
                    ChoiceOption(id: 2, icon: "frying.pan", text: "Shake the pan")
                ],
                correctIndex: 0
            ),
            location: "Street Stall",
            locationIcon: "cart.fill",
            levelTitle: "Street Cook",
            environmentTint: EnvironmentTint(
                primary: Color(red: 0.92, green: 0.95, blue: 0.88),
                secondary: Color(red: 0.70, green: 0.82, blue: 0.60),
                accent: Color.green.opacity(0.12)
            )
        ),
        CookingNode(
            id: 2,
            title: "Cook It",
            icon: "frying.pan",
            state: .locked,
            challenge: Challenge(
                id: 2,
                question: "Cook the mixture. What heat level is correct?",
                choices: [
                    ChoiceOption(id: 0, icon: "flame", text: "Medium heat"),
                    ChoiceOption(id: 1, icon: "snowflake", text: "Freezing cold"),
                    ChoiceOption(id: 2, icon: "bolt.fill", text: "Max flame only")
                ],
                correctIndex: 0
            ),
            location: "Restaurant",
            locationIcon: "building.2.fill",
            levelTitle: "Restaurant Chef",
            environmentTint: EnvironmentTint(
                primary: Color(red: 0.90, green: 0.88, blue: 0.95),
                secondary: Color(red: 0.65, green: 0.60, blue: 0.82),
                accent: Color.purple.opacity(0.10)
            )
        ),
        CookingNode(
            id: 3,
            title: "Serve It",
            icon: "fork.knife",
            state: .locked,
            challenge: Challenge(
                id: 3,
                question: "Plate the dish. Where does garnish go?",
                choices: [
                    ChoiceOption(id: 0, icon: "leaf", text: "On top of the dish"),
                    ChoiceOption(id: 1, icon: "arrow.down", text: "Under the plate"),
                    ChoiceOption(id: 2, icon: "drop", text: "Inside the sauce")
                ],
                correctIndex: 0
            ),
            location: "Fine Dining",
            locationIcon: "wineglass.fill",
            levelTitle: "Master Chef",
            environmentTint: EnvironmentTint(
                primary: Color(red: 0.95, green: 0.90, blue: 0.85),
                secondary: Color(red: 0.82, green: 0.68, blue: 0.50),
                accent: Color(red: 0.85, green: 0.70, blue: 0.40).opacity(0.15)
            )
        )
    ]
}

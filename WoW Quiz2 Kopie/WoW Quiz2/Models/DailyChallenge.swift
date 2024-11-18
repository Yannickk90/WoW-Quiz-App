import Foundation

class DailyChallenge: ObservableObject {
    static let shared = DailyChallenge()
    
    @Published var currentChallenge: Challenge
    @Published var isCompleted: Bool = false
    @Published var lastCompletionDate: Date?
    
    private init() {
        currentChallenge = Self.generateChallenge()
        checkAndResetDaily()
    }
    
    private static func generateChallenge() -> Challenge {
        let challenges = [
            Challenge(
                title: "Lore Meister",
                description: "Beantworte 3 Lore-Fragen richtig",
                reward: 500,
                category: .lore
            ),
            Challenge(
                title: "PvP Experte",
                description: "Beantworte 3 PvP-Fragen richtig",
                reward: 500,
                category: .pvp
            ),
            Challenge(
                title: "Raid Taktiker",
                description: "Beantworte 3 Raid-Fragen richtig",
                reward: 500,
                category: .raids
            ),
            Challenge(
                title: "Mechanik Profi",
                description: "Beantworte 3 Mechanik-Fragen richtig",
                reward: 500,
                category: .mechanics
            )
        ]
        return challenges.randomElement()!
    }
    
    func checkAndResetDaily() {
        if let lastDate = lastCompletionDate {
            let calendar = Calendar.current
            if !calendar.isDateInToday(lastDate) {
                // Neuer Tag - Reset der Challenge
                isCompleted = false
                currentChallenge = Self.generateChallenge()
            }
        }
    }
    
    func completeChallenge() {
        isCompleted = true
        lastCompletionDate = Date()
        PlayerProfile.shared.addExperience(currentChallenge.reward)
    }
    
    func checkProgress(correctAnswers: Int, category: Category) {
        if category == currentChallenge.category && correctAnswers >= 3 && !isCompleted {
            completeChallenge()
        }
    }
}

struct Challenge {
    let title: String
    let description: String
    let reward: Int
    let category: Category
} 

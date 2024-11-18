import Foundation
import UIKit

class PlayerProfile: ObservableObject {
    static let shared = PlayerProfile()
    
    @Published var name: String = "Player1"
    @Published var level: Int = 3
    @Published var experience: Int = 2345
    @Published var totalQuizzes: Int = 15
    @Published var correctAnswers: Int = 110
    @Published var showLevelUp: Bool = false
    
    let experiencePerLevel = 2500
    
    var experienceToNextLevel: Int {
        experiencePerLevel - (experience % experiencePerLevel)
    }
    
    var experienceProgress: Double {
        Double(experience % experiencePerLevel) / Double(experiencePerLevel)
    }
    
    private init() {}
    
    func addExperience(_ amount: Int) {
        let oldLevel = (experience / experiencePerLevel) + 1
        experience += amount
        let newLevel = (experience / experiencePerLevel) + 1
        
        if newLevel > oldLevel {
            level = newLevel
            showLevelUp = true
            
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        }
    }
} 
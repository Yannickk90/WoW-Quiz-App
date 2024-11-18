import Foundation

struct HighscoreEntry: Identifiable {
    let id = UUID()
    let name: String
    let correctAnswers: Int
    let totalQuestions: Int
    let level: Int
    let difficulty: Difficulty
    let date: Date
    
    var successRate: Double {
        return Double(correctAnswers) / Double(totalQuestions) * 100
    }
}

class HighscoreManager: ObservableObject {
    static let shared = HighscoreManager()
    @Published var highscores: [HighscoreEntry] = []
    
    private init() {
        // Mock-Daten
        highscores = [
            // Anfänger Highscores
            HighscoreEntry(name: "Michael", correctAnswers: 85, totalQuestions: 100, level: 15, difficulty: .easy, date: Date()),
            HighscoreEntry(name: "Sophie", correctAnswers: 72, totalQuestions: 90, level: 13, difficulty: .easy, date: Date()),
            HighscoreEntry(name: "Jonas", correctAnswers: 65, totalQuestions: 85, level: 11, difficulty: .easy, date: Date()),
            HighscoreEntry(name: "Emma", correctAnswers: 55, totalQuestions: 75, level: 9, difficulty: .easy, date: Date()),
            HighscoreEntry(name: "Leon", correctAnswers: 45, totalQuestions: 65, level: 7, difficulty: .easy, date: Date()),
            
            // Erfahren Highscores
            HighscoreEntry(name: "Laura", correctAnswers: 95, totalQuestions: 110, level: 18, difficulty: .medium, date: Date()),
            HighscoreEntry(name: "Tim", correctAnswers: 82, totalQuestions: 100, level: 16, difficulty: .medium, date: Date()),
            HighscoreEntry(name: "Nina", correctAnswers: 75, totalQuestions: 95, level: 14, difficulty: .medium, date: Date()),
            HighscoreEntry(name: "Felix", correctAnswers: 68, totalQuestions: 90, level: 12, difficulty: .medium, date: Date()),
            HighscoreEntry(name: "Marie", correctAnswers: 58, totalQuestions: 80, level: 10, difficulty: .medium, date: Date()),
            
            // Experten Highscores
            HighscoreEntry(name: "Daniel", correctAnswers: 110, totalQuestions: 125, level: 20, difficulty: .hard, date: Date()),
            HighscoreEntry(name: "Anna", correctAnswers: 95, totalQuestions: 115, level: 18, difficulty: .hard, date: Date()),
            HighscoreEntry(name: "Lukas", correctAnswers: 85, totalQuestions: 105, level: 16, difficulty: .hard, date: Date()),
            HighscoreEntry(name: "Sarah", correctAnswers: 75, totalQuestions: 95, level: 14, difficulty: .hard, date: Date()),
            HighscoreEntry(name: "Paul", correctAnswers: 65, totalQuestions: 85, level: 12, difficulty: .hard, date: Date())
        ]
    }
    
    func getHighscores(for difficulty: Difficulty) -> [HighscoreEntry] {
        return highscores
            .filter { $0.difficulty == difficulty }
            .sorted { $0.level > $1.level } // Sortierung nach Level
            .prefix(10)
            .map { $0 }
    }
    
    func addScore(correctAnswers: Int, totalQuestions: Int, category: Category, difficulty: Difficulty) {
        let entry = HighscoreEntry(
            name: PlayerProfile.shared.name,
            correctAnswers: correctAnswers,
            totalQuestions: totalQuestions,
            level: PlayerProfile.shared.level,
            difficulty: difficulty,
            date: Date()
        )
        highscores.append(entry)
        highscores.sort { $0.level > $1.level }
    }
} 
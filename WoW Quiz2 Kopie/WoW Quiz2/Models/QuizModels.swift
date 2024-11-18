import Foundation
import SwiftUI

enum Difficulty: String, Codable, CaseIterable {
    case easy
    case medium
    case hard
    
    var displayName: String {
        switch self {
        case .easy: return "Anfänger"
        case .medium: return "Erfahren"
        case .hard: return "Experte"
        }
    }
}

enum Category: String, Codable, CaseIterable {
    case lore = "Geschichte"
    case characters = "Charaktere"
    case mechanics = "Spielmechanik"
    case raids = "Schlachtzüge"
    case pvp = "PvP"
}

struct QuizSettings {
    var difficulty: Difficulty
    var selectedCategory: Category
}

struct Question: Identifiable {
    var id = UUID()
    let text: String
    let category: Category
    let difficulty: Difficulty
    let answers: [Answer]
    let explanation: String
}

struct Answer: Identifiable {
    var id = UUID()
    let text: String
    let isCorrect: Bool
}

@MainActor
class QuizManager: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var quizCompleted = false
    @Published var questions: [Question] = []
    
    func loadQuestions(for settings: QuizSettings) {
        questions = mockQuestions.filter { question in
            question.category == settings.selectedCategory &&
            question.difficulty == settings.difficulty
        }.shuffled()
    }
    
    func checkAnswer(_ selectedAnswer: Answer) -> Bool {
        return selectedAnswer.isCorrect
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            quizCompleted = true
        }
    }
    
    // Mock-Fragen für Testzwecke
    private let mockQuestions = [
        // LORE FRAGEN
        Question(
            text: "Wer führte die Nachtelfen während des Kriegs der Ahnen an?",
            category: .lore,
            difficulty: .medium,
            answers: [
                Answer(text: "Malfurion Sturmgrimm", isCorrect: true),
                Answer(text: "Illidan Sturmgrimm", isCorrect: false),
                Answer(text: "Tyrande Wisperwind", isCorrect: false),
                Answer(text: "Azshara", isCorrect: false)
            ],
            explanation: "Malfurion Sturmgrimm führte die Nachtelfen im Kampf gegen die Brennende Legion."
        ),
        Question(
            text: "Welches Volk gründete die Stadt Dalaran?",
            category: .lore,
            difficulty: .medium,
            answers: [
                Answer(text: "Die Menschen", isCorrect: true),
                Answer(text: "Die Hochelfen", isCorrect: false),
                Answer(text: "Die Zwerge", isCorrect: false),
                Answer(text: "Die Gnome", isCorrect: false)
            ],
            explanation: "Dalaran wurde von menschlichen Magiern als Stadt der Magie gegründet."
        ),
        Question(
            text: "Wer war der erste Lichkönig?",
            category: .lore,
            difficulty: .medium,
            answers: [
                Answer(text: "Ner'zhul", isCorrect: true),
                Answer(text: "Arthas", isCorrect: false),
                Answer(text: "Bolvar", isCorrect: false),
                Answer(text: "Sylvanas", isCorrect: false)
            ],
            explanation: "Ner'zhul wurde von Kil'jaeden zum ersten Lichkönig gemacht."
        ),
        Question(
            text: "Welches Ereignis führte zur Entstehung der Blutelfen?",
            category: .lore,
            difficulty: .medium,
            answers: [
                Answer(text: "Die Zerstörung des Sonnenbrunnens", isCorrect: true),
                Answer(text: "Der Dritte Krieg", isCorrect: false),
                Answer(text: "Die Öffnung des Dunklen Portals", isCorrect: false),
                Answer(text: "Der Fall von Lordaeron", isCorrect: false)
            ],
            explanation: "Nach der Zerstörung des Sonnenbrunnens benannten sich die Hochelfen in Blutelfen um."
        ),
        Question(
            text: "Welches Reich fiel als erstes der Brennenden Legion zum Opfer?",
            category: .lore,
            difficulty: .medium,
            answers: [
                Answer(text: "Argus", isCorrect: true),
                Answer(text: "Azeroth", isCorrect: false),
                Answer(text: "Draenor", isCorrect: false),
                Answer(text: "Xoroth", isCorrect: false)
            ],
            explanation: "Argus, die Heimatwelt der Eredar, war das erste Opfer der Legion."
        ),
        Question(
            text: "Wer erschuf den ersten Todesschwinge?",
            category: .lore,
            difficulty: .medium,
            answers: [
                Answer(text: "Die Alten Götter", isCorrect: true),
                Answer(text: "Die Titanen", isCorrect: false),
                Answer(text: "Die Brennende Legion", isCorrect: false),
                Answer(text: "Die Pandaren", isCorrect: false)
            ],
            explanation: "Die Alten Götter korrumpierten Neltharion und verwandelten ihn in Todesschwinge."
        ),
        Question(
            text: "Welches Volk schuf das erste Portal nach Azeroth?",
            category: .lore,
            difficulty: .medium,
            answers: [
                Answer(text: "Die Hochgeborenen", isCorrect: true),
                Answer(text: "Die Orcs", isCorrect: false),
                Answer(text: "Die Menschen", isCorrect: false),
                Answer(text: "Die Dämonen", isCorrect: false)
            ],
            explanation: "Die Hochgeborenen unter Königin Azshara öffneten das erste Portal nach Azeroth."
        ),
        Question(
            text: "Wer war der letzte Wächter von Tirisfal vor der Auflösung des Ordens?",
            category: .lore,
            difficulty: .medium,
            answers: [
                Answer(text: "Medivh", isCorrect: true),
                Answer(text: "Aegwynn", isCorrect: false),
                Answer(text: "Khadgar", isCorrect: false),
                Answer(text: "Meryl", isCorrect: false)
            ],
            explanation: "Medivh war der letzte Wächter, bevor der Orden aufgelöst wurde."
        ),
        Question(
            text: "Welches Ereignis führte zur Gründung der Silbernen Hand?",
            category: .lore,
            difficulty: .medium,
            answers: [
                Answer(text: "Der Erste Krieg", isCorrect: true),
                Answer(text: "Der Zweite Krieg", isCorrect: false),
                Answer(text: "Der Dritte Krieg", isCorrect: false),
                Answer(text: "Der Krieg der Ahnen", isCorrect: false)
            ],
            explanation: "Die Silberne Hand wurde nach dem Ersten Krieg als Orden der Paladine gegründet."
        ),
        Question(
            text: "Welche bedeutende Schlacht fand am Berg Hyjal statt?",
            category: .lore,
            difficulty: .medium,
            answers: [
                Answer(text: "Die Schlacht gegen die Brennende Legion", isCorrect: true),
                Answer(text: "Die Schlacht gegen den Lichkönig", isCorrect: false),
                Answer(text: "Die Schlacht gegen Todesschwinge", isCorrect: false),
                Answer(text: "Die Schlacht gegen die Eisentrolle", isCorrect: false)
            ],
            explanation: "Am Berg Hyjal kämpften die vereinten Völker Azeroths gegen die Brennende Legion und Archimonde."
        )
    ]
} 
enum Difficulty {
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

enum Category: String, CaseIterable {
    case lore = "Geschichte"
    case characters = "Charaktere"
    case mechanics = "Spielmechanik"
    case raids = "Schlachtzüge"
    case pvp = "PvP"
}

struct QuizSettings {
    var difficulty: Difficulty
    var selectedCategories: Set<Category>
} 
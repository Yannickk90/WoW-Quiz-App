import Foundation

class JokerManager: ObservableObject {
    static let shared = JokerManager()
    
    @Published var dailyJokerAvailable: Bool = true
    @Published var lastJokerUseDate: Date?
    
    private init() {
        checkDailyJoker()
    }
    
    func checkDailyJoker() {
        if let lastUse = lastJokerUseDate {
            let calendar = Calendar.current
            if !calendar.isDate(lastUse, inSameDayAs: Date()) {
                dailyJokerAvailable = true
            }
        }
    }
    
    func useJoker() -> Bool {
        if dailyJokerAvailable {
            dailyJokerAvailable = false
            lastJokerUseDate = Date()
            return true
        }
        return false
    }
} 
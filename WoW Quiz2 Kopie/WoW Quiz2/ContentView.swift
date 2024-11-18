import SwiftUI

struct ContentView: View {
    @StateObject private var playerProfile = PlayerProfile.shared
    @StateObject private var dailyChallenge = DailyChallenge.shared
    @StateObject private var jokerManager = JokerManager.shared
    @State private var isJokerBlinking = false
    @State private var quizSettings = QuizSettings(
        difficulty: .medium,
        selectedCategory: .lore
    )
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            NavigationView {
                // Sidebar für iPad (leer lassen)
                Color.clear.frame(width: 0)
                
                // Hauptinhalt
                mainContent
            }
            .navigationViewStyle(.columns)
        } else {
            NavigationView {
                mainContent
            }
        }
    }
    
    var mainContent: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 8) {
                    // App Titel
                    Text("World of Warcraft")
                        .font(.title.bold())
                        .foregroundColor(.yellow)
                    Text("Quiz")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.bottom, 4)
                    
                    // Spielerprofil
                    VStack(spacing: 10) {
                        // Name und Level
                        HStack {
                            Text(playerProfile.name)
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Level \(playerProfile.level)")
                                .font(.title3)
                                .foregroundColor(.yellow)
                        }
                        
                        // Erfahrungsleiste
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Hintergrund
                                Rectangle()
                                    .fill(Color.black.opacity(0.3))
                                    .frame(height: 20)
                                
                                // Fortschritt
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: geometry.size.width * playerProfile.experienceProgress, height: 20)
                            }
                            .cornerRadius(10)
                            .overlay(
                                Text("\(playerProfile.experience % playerProfile.experiencePerLevel)/\(playerProfile.experiencePerLevel) EP")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            )
                        }
                        .frame(height: 20)
                        
                        // Statistiken
                        HStack(spacing: 20) {
                            StatView(title: "Quizze", value: "\(playerProfile.totalQuizzes)")
                            StatView(title: "Richtige", value: "\(playerProfile.correctAnswers)")
                            if playerProfile.totalQuizzes > 0 {
                                let quote = Double(playerProfile.correctAnswers) / Double(playerProfile.totalQuizzes * 10) * 100
                                StatView(
                                    title: "Quote",
                                    value: String(format: "%.1f%%", quote)
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Tägliche Herausforderung
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Tägliche Herausforderung")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            if dailyChallenge.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(dailyChallenge.currentChallenge.title)
                                    .font(.subheadline)
                                    .foregroundColor(.yellow)
                                Text(dailyChallenge.currentChallenge.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            HStack {
                                Text("\(dailyChallenge.currentChallenge.reward)")
                                    .font(.headline)
                                    .foregroundColor(.yellow)
                                Text("EP")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        // Schnellstart-Button für die Herausforderung
                        if !dailyChallenge.isCompleted {
                            NavigationLink(destination: QuizView(settings: QuizSettings(
                                difficulty: .medium,
                                selectedCategory: dailyChallenge.currentChallenge.category
                            ))) {
                                Text("Herausforderung starten")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.5))
                                    .cornerRadius(8)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Ausgewählte Einstellungen
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "speedometer")
                                .foregroundColor(.yellow)
                            Text("Schwierigkeit:")
                                .foregroundColor(.gray)
                            Text(quizSettings.difficulty.displayName)
                                .foregroundColor(.yellow)
                                .bold()
                        }
                        
                        HStack {
                            Image(systemName: "folder")
                                .foregroundColor(.yellow)
                            Text("Kategorie:")
                                .foregroundColor(.gray)
                            Text(quizSettings.selectedCategory.rawValue)
                                .foregroundColor(.yellow)
                                .bold()
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Hauptbuttons
                    VStack(spacing: 12) {
                        NavigationLink(destination: QuizView(settings: quizSettings)) {
                            Text("Quiz Starten")
                                .font(DeviceHelper.isIPad ? .title.bold() : .title2.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: DeviceHelper.isIPad ? 70 : 55)
                                .background(Color(red: 0.2, green: 0.3, blue: 0.7))
                                .cornerRadius(14)
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: Color(red: 0.2, green: 0.3, blue: 0.7)))
                        .padding(.horizontal, AppStyleGuide.standardPadding)
                        
                        NavigationLink(destination: HighscoreView()) {
                            Text("Bestenliste")
                                .font(DeviceHelper.isIPad ? .title.bold() : .title2.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: DeviceHelper.isIPad ? 70 : 55)
                                .background(Color(red: 0.2, green: 0.5, blue: 0.3))
                                .cornerRadius(14)
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: Color(red: 0.2, green: 0.5, blue: 0.3)))
                        .padding(.horizontal, AppStyleGuide.standardPadding)
                        
                        NavigationLink(destination: FriendsListView()) {
                            Text("Freundesliste")
                                .font(DeviceHelper.isIPad ? .title.bold() : .title2.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: DeviceHelper.isIPad ? 70 : 55)
                                .background(Color(red: 0.4, green: 0.2, blue: 0.5))
                                .cornerRadius(14)
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: Color(red: 0.4, green: 0.2, blue: 0.5)))
                        .padding(.horizontal, AppStyleGuide.standardPadding)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    if jokerManager.dailyJokerAvailable {
                        HStack {
                            Image(systemName: "star.circle.fill")
                                .foregroundColor(.yellow)
                                .opacity(isJokerBlinking ? 0.3 : 1.0)
                            Text("50:50 Joker verfügbar!")
                                .foregroundColor(.yellow)
                                .opacity(isJokerBlinking ? 0.3 : 1.0)
                        }
                        .padding()
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                                isJokerBlinking.toggle()
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, DeviceHelper.defaultPadding)
            
            if playerProfile.showLevelUp {
                LevelUpView(
                    level: playerProfile.level,
                    isPresented: $playerProfile.showLevelUp
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SettingsView(settings: $quizSettings)) {
                    Image(systemName: "gear")
                        .foregroundColor(.yellow)
                }
            }
        }
        .onAppear {
            jokerManager.checkDailyJoker()
        }
    }
}

struct WoWToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                configuration.label
                    .foregroundColor(.yellow)
                Spacer()
                if configuration.isOn {
                    Image(systemName: "checkmark")
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(configuration.isOn ? Color.yellow : Color.gray.opacity(0.5), lineWidth: 1)
                    .background(configuration.isOn ? Color.yellow.opacity(0.1) : Color.black.opacity(0.3))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Hilfserweiterung für Hex-Farben
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Hilfsview für Statistiken
struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ContentView()
}

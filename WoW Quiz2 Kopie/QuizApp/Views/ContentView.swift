import SwiftUI

struct ContentView: View {
    @State private var isSettingsPresented = false
    @State private var quizSettings = QuizSettings(
        difficulty: .medium,
        selectedCategories: Set([.lore])
    )
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header mit WoW-Logo
                Image("wow-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .padding(.top, 40)
                
                Spacer()
                
                // Hauptbutton zum Starten
                Button(action: startQuiz) {
                    Text("Quiz Starten")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 20)
                
                // Ausgewählte Einstellungen anzeigen
                VStack(alignment: .leading, spacing: 10) {
                    Text("Schwierigkeit: \(quizSettings.difficulty.displayName)")
                    Text("Kategorien: \(selectedCategoriesText)")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isSettingsPresented.toggle() }) {
                        Image(systemName: "slider.horizontal.3")
                            .frame(width: 44, height: 44) // Gemäß Hit Target Guidelines
                    }
                }
            }
            .sheet(isPresented: $isSettingsPresented) {
                SettingsView(settings: $quizSettings)
            }
        }
    }
    
    private var selectedCategoriesText: String {
        quizSettings.selectedCategories
            .map { $0.rawValue }
            .joined(separator: ", ")
    }
    
    private func startQuiz() {
        // Hier kommt später die Quiz-Logik hin
    }
} 
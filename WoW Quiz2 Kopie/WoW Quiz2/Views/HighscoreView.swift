import SwiftUI

struct HighscoreView: View {
    @ObservedObject private var highscoreManager = HighscoreManager.shared
    @State private var selectedDifficulty: Difficulty = .medium
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                Picker("Schwierigkeit", selection: $selectedDifficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.displayName).tag(difficulty)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                List {
                    ForEach(Array(highscoreManager.getHighscores(for: selectedDifficulty).enumerated()), id: \.element.id) { index, entry in
                        HStack(spacing: 12) {
                            // Platzierung
                            Text("\(index + 1).")
                                .font(DeviceHelper.headlineFont)
                                .foregroundColor(.yellow)
                                .frame(width: 30)
                                .font(.headline)
                            
                            // Name und Level
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.name)
                                    .font(DeviceHelper.bodyFont)
                                    .foregroundColor(.white)
                                Text("Level \(entry.level)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // Statistiken
                            VStack(alignment: .trailing, spacing: 4) {
                                HStack(spacing: 4) {
                                    Text("\(entry.correctAnswers)")
                                        .font(DeviceHelper.bodyFont)
                                        .foregroundColor(.yellow)
                                    Text("/")
                                        .font(DeviceHelper.bodyFont)
                                        .foregroundColor(.gray)
                                    Text("\(entry.totalQuestions)")
                                        .font(DeviceHelper.bodyFont)
                                        .foregroundColor(.gray)
                                }
                                
                                Text("\(String(format: "%.1f", entry.successRate))%")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(Color.black.opacity(0.3))
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 800 : .infinity)
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 20)
        }
        .navigationTitle("Bestenliste")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Bestenliste")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
} 
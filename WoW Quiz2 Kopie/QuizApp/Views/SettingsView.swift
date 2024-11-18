import SwiftUI

struct SettingsView: View {
    @Binding var settings: QuizSettings
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Schwierigkeit")) {
                    Picker("Schwierigkeit", selection: $settings.difficulty) {
                        Text("Anfänger").tag(Difficulty.easy)
                        Text("Erfahren").tag(Difficulty.medium)
                        Text("Experte").tag(Difficulty.hard)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Kategorien")) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Toggle(category.rawValue, isOn: Binding(
                            get: { settings.selectedCategories.contains(category) },
                            set: { isSelected in
                                if isSelected {
                                    settings.selectedCategories.insert(category)
                                } else {
                                    settings.selectedCategories.remove(category)
                                }
                            }
                        ))
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                }
            }
        }
    }
} 
import SwiftUI

struct SettingsView: View {
    @Binding var settings: QuizSettings
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                Form {
                    Section(header: Text("Schwierigkeit")
                        .foregroundColor(AppStyleGuide.textSecondaryColor)) {
                        Picker("Schwierigkeit", selection: $settings.difficulty) {
                            Text("Anfänger").tag(Difficulty.easy)
                            Text("Erfahren").tag(Difficulty.medium)
                            Text("Experte").tag(Difficulty.hard)
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color.black.opacity(0.3))
                    
                    Section(header: Text("Kategorie")
                        .foregroundColor(AppStyleGuide.textSecondaryColor)) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Button(action: {
                                settings.selectedCategory = category
                            }) {
                                HStack {
                                    Text(category.rawValue)
                                        .font(DeviceHelper.bodyFont)
                                        .foregroundColor(.white)
                                    Spacer()
                                    if settings.selectedCategory == category {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(AppStyleGuide.secondaryColor)
                                    }
                                }
                            }
                            .listRowBackground(Color.black.opacity(0.3))
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .frame(maxWidth: DeviceHelper.contentMaxWidth)
                .padding(.horizontal, DeviceHelper.defaultPadding)
            }
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Einstellungen")
                        .font(.headline)
                        .foregroundColor(AppStyleGuide.textColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(AppStyleGuide.secondaryColor)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
} 
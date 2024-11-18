import SwiftUI

struct FriendsListView: View {
    @StateObject private var friendsManager = FriendsManager.shared
    @State private var showingAddFriend = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                List {
                    ForEach(friendsManager.friends) { friend in
                        HStack {
                            // Online Status
                            Circle()
                                .fill(friend.isOnline ? Color.green : Color.gray)
                                .frame(width: 10, height: 10)
                            
                            // Character Name
                            Text(friend.characterName)
                                .font(DeviceHelper.bodyFont)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            // Level und Klasse
                            VStack(alignment: .trailing) {
                                Text("Level \(friend.level)")
                                    .font(DeviceHelper.captionFont)
                                    .foregroundColor(.gray)
                                Text(friend.characterClass)
                                    .font(.caption)
                                    .foregroundColor(friend.classColor)
                            }
                        }
                        .listRowBackground(Color.black.opacity(0.3))
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 800 : nil)
                
                // Freund hinzufügen Button
                Button(action: {
                    showingAddFriend = true
                }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("Freund hinzufügen")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.5))
                    .cornerRadius(10)
                }
                .padding()
            }
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20)
        }
        .navigationTitle("Freundesliste")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Freundesliste")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $showingAddFriend) {
            AddFriendView(isPresented: $showingAddFriend)
        }
    }
}

// Neue View zum Hinzufügen eines Freundes
struct AddFriendView: View {
    @Binding var isPresented: Bool
    @StateObject private var friendsManager = FriendsManager.shared
    @State private var characterName = ""
    @State private var selectedClass = "Krieger"
    @State private var level = ""
    
    let characterClasses = ["Krieger", "Paladin", "Jäger", "Schurke", "Priester", 
                          "Todesritter", "Schamane", "Magier", "Hexenmeister", "Druide"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Charakterdetails")) {
                    TextField("Charaktername", text: $characterName)
                        .foregroundColor(.white)
                    
                    Picker("Klasse", selection: $selectedClass) {
                        ForEach(characterClasses, id: \.self) { className in
                            Text(className).tag(className)
                        }
                    }
                    
                    TextField("Level (1-60)", text: $level)
                        .keyboardType(.numberPad)
                        .foregroundColor(.white)
                }
            }
            .navigationTitle("Freund hinzufügen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Hinzufügen") {
                        addFriend()
                    }
                    .disabled(characterName.isEmpty || level.isEmpty)
                }
            }
        }
    }
    
    private func addFriend() {
        if let levelInt = Int(level), levelInt > 0 && levelInt <= 60 {
            let newFriend = Friend(
                characterName: characterName,
                characterClass: selectedClass,
                level: levelInt,
                isOnline: true
            )
            friendsManager.addFriend(newFriend)
            isPresented = false
        }
    }
}

// Modell für einen Freund
struct Friend: Identifiable {
    let id = UUID()
    let characterName: String
    let characterClass: String
    let level: Int
    let isOnline: Bool
    
    var classColor: Color {
        switch characterClass.lowercased() {
        case "krieger": return .brown
        case "paladin": return .pink
        case "jäger": return .green
        case "schurke": return .yellow
        case "priester": return .white
        case "todesritter": return .red
        case "schamane": return .blue
        case "magier": return .cyan
        case "hexenmeister": return .purple
        case "druide": return .orange
        default: return .gray
        }
    }
}

// Manager für die Freundesliste
class FriendsManager: ObservableObject {
    static let shared = FriendsManager()
    
    @Published var friends: [Friend] = [
        Friend(characterName: "Lisa", characterClass: "Magier", level: 12, isOnline: true),
        Friend(characterName: "Max", characterClass: "Krieger", level: 34, isOnline: true),
        Friend(characterName: "Sarah", characterClass: "Druide", level: 8, isOnline: false),
        Friend(characterName: "Tom", characterClass: "Jäger", level: 23, isOnline: true),
        Friend(characterName: "Julia", characterClass: "Priester", level: 15, isOnline: false),
        Friend(characterName: "David", characterClass: "Schurke", level: 28, isOnline: false),
        Friend(characterName: "Anna", characterClass: "Hexenmeister", level: 19, isOnline: true),
        Friend(characterName: "Felix", characterClass: "Paladin", level: 31, isOnline: false)
    ]
    
    private init() {}
    
    func addFriend(_ friend: Friend) {
        friends.append(friend)
    }
} 

import SwiftUI

struct AppStyleGuide {
    // Spacing
    static let standardPadding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    static let largeButtonHeight: CGFloat = 54
    
    // Corners
    static let standardCornerRadius: CGFloat = 12
    
    // Colors
    static let primaryColor = Color.blue
    static let secondaryColor = Color.yellow
    static let backgroundColor = Color("BackgroundColor")
    static let textColor = Color.white
    static let textSecondaryColor = Color.gray
}

struct PrimaryButtonStyle: ButtonStyle {
    let backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: AppStyleGuide.largeButtonHeight)
            .background(backgroundColor.opacity(configuration.isPressed ? 0.7 : 1))
            .cornerRadius(AppStyleGuide.standardCornerRadius)
    }
} 
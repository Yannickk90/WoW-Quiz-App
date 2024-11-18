import SwiftUI

struct BackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            if let image = UIImage(named: "wow-background") {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .overlay(Color.black.opacity(0.2))
            } else {
                Color("BackgroundColor")
            }
        }
        .ignoresSafeArea()
    }
} 
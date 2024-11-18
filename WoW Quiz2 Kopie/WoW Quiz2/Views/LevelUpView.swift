import SwiftUI

struct LevelUpView: View {
    let level: Int
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            VStack(spacing: 20) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                
                Text("Level Up!")
                    .font(DeviceHelper.titleFont)
                    .foregroundColor(.yellow)
                
                Text("Level \(level) erreicht!")
                    .font(DeviceHelper.subtitleFont)
                    .foregroundColor(.white)
                
                Text("Tap to continue")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top)
            }
            .padding(UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40)
            .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 500 : nil)
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1
            }
        }
    }
} 
import SwiftUI

struct TimerBarView: View {
    let duration: Double
    @Binding var isRunning: Bool
    var onTimeout: () -> Void
    
    @State private var progress: CGFloat = 1.0
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: geometry.size.width, height: 8)
                
                Rectangle()
                    .fill(timerColor)
                    .frame(width: geometry.size.width * progress, height: 8)
            }
            .cornerRadius(4)
        }
        .frame(height: 8)
        .onChange(of: isRunning) { newValue in
            if newValue {
                startTimer()
            } else {
                stopTimer()
                progress = 1.0
            }
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private var timerColor: Color {
        if progress > 0.6 {
            return .green
        } else if progress > 0.3 {
            return .yellow
        } else {
            return .red
        }
    }
    
    private func startTimer() {
        stopTimer()
        progress = 1.0
        
        withAnimation(.linear(duration: duration)) {
            progress = 0
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            if isRunning {
                onTimeout()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
} 

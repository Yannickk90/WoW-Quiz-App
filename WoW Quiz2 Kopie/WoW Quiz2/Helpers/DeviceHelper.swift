import SwiftUI
import UIKit

struct DeviceHelper {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var defaultPadding: CGFloat {
        isIPad ? 60 : 20
    }
    
    static var contentMaxWidth: CGFloat {
        isIPad ? 900 : .infinity
    }
    
    static var titleFont: Font {
        isIPad ? .system(size: 40, weight: .bold) : .title.bold()
    }
    
    static var subtitleFont: Font {
        isIPad ? .system(size: 32, weight: .semibold) : .title2
    }
    
    static var headlineFont: Font {
        isIPad ? .system(size: 28, weight: .bold) : .headline
    }
    
    static var bodyFont: Font {
        isIPad ? .system(size: 24) : .body
    }
    
    static var captionFont: Font {
        isIPad ? .system(size: 20) : .caption
    }
    
    static var buttonHeight: CGFloat {
        isIPad ? 80 : 55
    }
} 
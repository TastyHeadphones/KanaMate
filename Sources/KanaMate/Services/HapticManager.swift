import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Manages haptic feedback for correct and incorrect answers
class HapticManager: ObservableObject {
    static let shared = HapticManager()
    
    private init() {}
    
    /// Provide success haptic feedback for correct answers
    func playSuccessHaptic() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        #endif
    }
    
    /// Provide error haptic feedback for incorrect answers
    func playErrorHaptic() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        #endif
    }
    
    /// Provide light impact feedback for button presses
    func playLightImpact() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }
    
    /// Provide medium impact feedback for transitions
    func playMediumImpact() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif
    }
}
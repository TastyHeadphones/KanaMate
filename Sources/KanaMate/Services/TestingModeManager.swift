import Foundation

/// Manages different testing modes for kana learning
class TestingModeManager: ObservableObject {
    static let shared = TestingModeManager()
    
    enum TestingMode: String, CaseIterable {
        case random = "Random"
        case sequential = "Sequential" // Gojūon order
        
        var icon: String {
            switch self {
            case .random:
                return "shuffle"
            case .sequential:
                return "list.number"
            }
        }
    }
    
    @Published var currentMode: TestingMode = .random
    private var sequentialIndex: Int = 0
    
    private init() {}
    
    /// Get kana for review based on current testing mode
    func getKanaForReview(from allKana: [Kana], progressManager: ProgressManager, limit: Int = 20) -> [Kana] {
        switch currentMode {
        case .random:
            return progressManager.getKanaForReview(from: allKana, limit: limit)
        case .sequential:
            return getSequentialKana(from: allKana, limit: limit)
        }
    }
    
    /// Get kana in gojūon (sequential) order
    private func getSequentialKana(from allKana: [Kana], limit: Int) -> [Kana] {
        // Define the gojūon order for basic kana
        let gojuonOrder = [
            "a", "i", "u", "e", "o",
            "ka", "ki", "ku", "ke", "ko",
            "sa", "shi", "su", "se", "so",
            "ta", "chi", "tsu", "te", "to",
            "na", "ni", "nu", "ne", "no",
            "ha", "hi", "fu", "he", "ho",
            "ma", "mi", "mu", "me", "mo",
            "ya", "yu", "yo",
            "ra", "ri", "ru", "re", "ro",
            "wa", "wo", "n"
        ]
        
        // Create ordered basic kana list
        var orderedKana: [Kana] = []
        for romaji in gojuonOrder {
            if let kana = allKana.first(where: { $0.romaji == romaji && $0.category == .basic }) {
                orderedKana.append(kana)
            }
        }
        
        // Add other categories after basic kana
        let nonBasicKana = allKana.filter { $0.category != .basic }
        orderedKana.append(contentsOf: nonBasicKana)
        
        // Get next batch starting from current index
        let startIndex = sequentialIndex % orderedKana.count
        let endIndex = min(startIndex + limit, orderedKana.count)
        
        let result = Array(orderedKana[startIndex..<endIndex])
        
        // Update index for next session
        sequentialIndex = endIndex % orderedKana.count
        
        return result
    }
    
    /// Reset sequential index to start from beginning
    func resetSequentialMode() {
        sequentialIndex = 0
    }
    
    /// Switch to next testing mode
    func switchMode() {
        switch currentMode {
        case .random:
            currentMode = .sequential
            resetSequentialMode()
        case .sequential:
            currentMode = .random
        }
    }
}
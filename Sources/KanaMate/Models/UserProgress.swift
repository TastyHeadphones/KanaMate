import Foundation

/// Tracks user's learning progress for each kana
struct UserProgress: Codable {
    let kanaId: UUID
    var correctCount: Int = 0
    var incorrectCount: Int = 0
    var lastReviewed: Date = Date()
    var nextReviewDate: Date = Date()
    var difficulty: Double = 1.0 // Higher = more difficult
    
    /// Calculate success rate
    var successRate: Double {
        let total = correctCount + incorrectCount
        return total > 0 ? Double(correctCount) / Double(total) : 0.0
    }
    
    /// Check if this kana should be reviewed now
    var isReadyForReview: Bool {
        return Date() >= nextReviewDate
    }
}

/// Manages user's overall progress and implements spaced repetition
class ProgressManager: ObservableObject {
    static let shared = ProgressManager()
    
    @Published var userProgress: [UUID: UserProgress] = [:]
    
    private let userDefaults = UserDefaults.standard
    private let progressKey = "KanaMateUserProgress"
    
    private init() {
        loadProgress()
    }
    
    /// Load progress from UserDefaults
    func loadProgress() {
        if let data = userDefaults.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode([UUID: UserProgress].self, from: data) {
            userProgress = decoded
        }
    }
    
    /// Save progress to UserDefaults
    func saveProgress() {
        if let encoded = try? JSONEncoder().encode(userProgress) {
            userDefaults.set(encoded, forKey: progressKey)
        }
    }
    
    /// Record a correct answer for a kana
    func recordCorrectAnswer(for kanaId: UUID) {
        var progress = userProgress[kanaId] ?? UserProgress(kanaId: kanaId)
        progress.correctCount += 1
        progress.lastReviewed = Date()
        progress.difficulty = max(0.1, progress.difficulty - 0.1) // Reduce difficulty
        progress.nextReviewDate = calculateNextReviewDate(for: progress)
        userProgress[kanaId] = progress
        saveProgress()
    }
    
    /// Record an incorrect answer for a kana
    func recordIncorrectAnswer(for kanaId: UUID) {
        var progress = userProgress[kanaId] ?? UserProgress(kanaId: kanaId)
        progress.incorrectCount += 1
        progress.lastReviewed = Date()
        progress.difficulty = min(3.0, progress.difficulty + 0.2) // Increase difficulty
        progress.nextReviewDate = calculateNextReviewDate(for: progress)
        userProgress[kanaId] = progress
        saveProgress()
    }
    
    /// Calculate next review date based on spaced repetition algorithm
    private func calculateNextReviewDate(for progress: UserProgress) -> Date {
        let baseInterval: TimeInterval = 86400 // 1 day in seconds
        let difficultyMultiplier = progress.difficulty
        let successBonus = progress.successRate > 0.7 ? 2.0 : 1.0
        
        let interval = baseInterval * difficultyMultiplier / successBonus
        return Date().addingTimeInterval(interval)
    }
    
    /// Get kana that need review, prioritizing difficult ones
    func getKanaForReview(from allKana: [Kana], limit: Int = 10) -> [Kana] {
        let readyForReview = allKana.filter { kana in
            let progress = userProgress[kana.id]
            return progress?.isReadyForReview ?? true // New kana are ready for review
        }
        
        // Sort by difficulty (descending) and last reviewed (ascending)
        let sorted = readyForReview.sorted { kana1, kana2 in
            let progress1 = userProgress[kana1.id] ?? UserProgress(kanaId: kana1.id)
            let progress2 = userProgress[kana2.id] ?? UserProgress(kanaId: kana2.id)
            
            // First sort by difficulty (higher difficulty first)
            if progress1.difficulty != progress2.difficulty {
                return progress1.difficulty > progress2.difficulty
            }
            
            // Then by last reviewed (older first)
            return progress1.lastReviewed < progress2.lastReviewed
        }
        
        return Array(sorted.prefix(limit))
    }
    
    /// Get overall statistics
    func getOverallStats() -> (totalKana: Int, studiedKana: Int, averageSuccessRate: Double) {
        let totalKana = KanaData.shared.allKana.count
        let studiedKana = userProgress.count
        
        let averageSuccessRate = userProgress.values.map { $0.successRate }.reduce(0, +) / Double(max(1, studiedKana))
        
        return (totalKana, studiedKana, averageSuccessRate)
    }
}
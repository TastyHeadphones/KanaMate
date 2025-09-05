import XCTest
@testable import KanaMate

final class KanaMateTests: XCTestCase {
    
    func testKanaDataLoading() {
        let kanaData = KanaData.shared
        
        // Test that kana data is loaded
        XCTAssertFalse(kanaData.allKana.isEmpty, "Kana data should not be empty")
        
        // Test basic kana exists
        let basicKana = kanaData.getKana(by: .basic)
        XCTAssertFalse(basicKana.isEmpty, "Basic kana should not be empty")
        
        // Test that 'a' kana exists
        let aKana = basicKana.first { $0.romaji == "a" }
        XCTAssertNotNil(aKana, "Should find 'a' kana")
        XCTAssertEqual(aKana?.hiragana, "あ", "Hiragana for 'a' should be 'あ'")
        XCTAssertEqual(aKana?.katakana, "ア", "Katakana for 'a' should be 'ア'")
    }
    
    func testUserProgress() {
        let progressManager = ProgressManager.shared
        let testKanaId = UUID()
        
        // Test recording correct answer
        progressManager.recordCorrectAnswer(for: testKanaId)
        let progress = progressManager.userProgress[testKanaId]
        XCTAssertNotNil(progress, "Progress should exist after recording answer")
        XCTAssertEqual(progress?.correctCount, 1, "Correct count should be 1")
        
        // Test recording incorrect answer
        progressManager.recordIncorrectAnswer(for: testKanaId)
        let updatedProgress = progressManager.userProgress[testKanaId]
        XCTAssertEqual(updatedProgress?.incorrectCount, 1, "Incorrect count should be 1")
    }
    
    func testSpacedRepetition() {
        let progressManager = ProgressManager.shared
        let kanaData = KanaData.shared
        
        // Get kana for review
        let reviewKana = progressManager.getKanaForReview(from: kanaData.allKana, limit: 5)
        XCTAssertTrue(reviewKana.count <= 5, "Should return at most 5 kana")
        XCTAssertFalse(reviewKana.isEmpty, "Should return some kana for review")
    }
    
    func testKanaCategories() {
        let kanaData = KanaData.shared
        
        // Test all categories have kana
        for category in Kana.KanaCategory.allCases {
            let categoryKana = kanaData.getKana(by: category)
            XCTAssertFalse(categoryKana.isEmpty, "\(category.rawValue) category should have kana")
        }
    }
    
    func testSuccessRateCalculation() {
        var progress = UserProgress(kanaId: UUID())
        progress.correctCount = 7
        progress.incorrectCount = 3
        
        XCTAssertEqual(progress.successRate, 0.7, accuracy: 0.01, "Success rate should be 70%")
    }
}
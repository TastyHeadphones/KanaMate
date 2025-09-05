import SwiftUI

public struct KanaMetaView: View {
    @StateObject private var kanaData = KanaData.shared
    @StateObject private var progressManager = ProgressManager.shared
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var hapticManager = HapticManager.shared
    @StateObject private var testingModeManager = TestingModeManager.shared
    
    @State private var currentKana: Kana?
    @State private var showingKana = false
    @State private var reviewKana: [Kana] = []
    @State private var currentIndex = 0
    @State private var showingStats = false
    @State private var showingKanaChart = false
    @State private var showingForgottenKana = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header with navigation
                HStack {
                    // Statistics button
                    Button(action: {
                        hapticManager.playLightImpact()
                        showingStats = true
                    }) {
                        Image(systemName: "chart.bar.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
                    // Forgotten kana button
                    Button(action: {
                        hapticManager.playLightImpact()
                        showingForgottenKana = true
                    }) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                    // App title
                    Text("📚")
                        .font(.title)
                    
                    Spacer()
                    
                    // Kana chart button
                    Button(action: {
                        hapticManager.playLightImpact()
                        showingKanaChart = true
                    }) {
                        Image(systemName: "grid.circle.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                    
                    // Testing mode toggle
                    Button(action: {
                        hapticManager.playMediumImpact()
                        testingModeManager.switchMode()
                        resetLearningSession()
                    }) {
                        Image(systemName: testingModeManager.currentMode.icon)
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Main learning area
                if let kana = currentKana {
                    VStack(spacing: 40) {
                        // Romaji display
                        Text(kana.romaji)
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        // Kana display (when revealed)
                        if showingKana {
                            VStack(spacing: 20) {
                                HStack(spacing: 30) {
                                    VStack {
                                        Text("Hiragana")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(kana.hiragana)
                                            .font(.system(size: 60, weight: .medium))
                                            .foregroundColor(.blue)
                                    }
                                    
                                    VStack {
                                        Text("Katakana")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(kana.katakana)
                                            .font(.system(size: 60, weight: .medium))
                                            .foregroundColor(.red)
                                    }
                                }
                                
                                // Audio button
                                Button(action: {
                                    hapticManager.playLightImpact()
                                    audioManager.playPronunciation(for: kana)
                                }) {
                                    HStack {
                                        Image(systemName: "speaker.wave.2.fill")
                                        Text("🔊")
                                    }
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(12)
                                }
                                
                                // Continue button when kana is showing
                                Button(action: {
                                    hapticManager.playLightImpact()
                                    nextKana()
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.right.circle.fill")
                                        Text("➡️")
                                    }
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(12)
                                }
                            }
                            .transition(.opacity)
                        } else {
                            // Answer buttons
                            HStack(spacing: 40) {
                                // Know button
                                Button(action: {
                                    handleAnswer(correct: true)
                                }) {
                                    VStack {
                                        Text("✔️")
                                            .font(.system(size: 50))
                                        Text("😊")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                    }
                                    .foregroundColor(.white)
                                    .frame(width: 120, height: 120)
                                    .background(Color.green)
                                    .cornerRadius(20)
                                }
                                
                                // Don't know button
                                Button(action: {
                                    handleAnswer(correct: false)
                                }) {
                                    VStack {
                                        Text("❌")
                                            .font(.system(size: 50))
                                        Text("🤔")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                    }
                                    .foregroundColor(.white)
                                    .frame(width: 120, height: 120)
                                    .background(Color.red)
                                    .cornerRadius(20)
                                }
                            }
                        }
                    }
                } else {
                    // Welcome screen
                    VStack(spacing: 30) {
                        VStack(spacing: 10) {
                            Text("🇯🇵")
                                .font(.system(size: 80))
                            Text("📚 かなメモ")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("🎯 日本語 かな")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Button(action: {
                            hapticManager.playMediumImpact()
                            startLearningSession()
                        }) {
                            HStack {
                                Image(systemName: "play.circle.fill")
                                Text("🚀")
                            }
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        .cornerRadius(12)
                    }
                }
                
                Spacer()
                
                // Progress indicator
                if !reviewKana.isEmpty {
                    HStack {
                        Text("📊 \(currentIndex + 1) / \(reviewKana.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if let kana = currentKana {
                            Text("\(categoryIcon(for: kana.category)) \(kana.category.rawValue)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("\(testingModeManager.currentMode.icon) \(testingModeManager.currentMode.rawValue)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .sheet(isPresented: $showingStats) {
                StatsView()
            }
            .sheet(isPresented: $showingKanaChart) {
                KanaChartView()
            }
            .sheet(isPresented: $showingForgottenKana) {
                ForgottenKanaView()
            }
        }
        .onAppear {
            // Initialize with some kana for review
            if reviewKana.isEmpty {
                startLearningSession()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func categoryIcon(for category: Kana.KanaCategory) -> String {
        switch category {
        case .basic:
            return "🔤"
        case .voiced:
            return "🔊"
        case .semiVoiced:
            return "🎵"
        case .combination:
            return "🔗"
        }
    }
    
    private func startLearningSession() {
        reviewKana = testingModeManager.getKanaForReview(
            from: kanaData.allKana,
            progressManager: progressManager,
            limit: 20
        )
        currentIndex = 0
        if !reviewKana.isEmpty {
            currentKana = reviewKana[currentIndex]
            showingKana = false
        }
    }
    
    private func resetLearningSession() {
        startLearningSession()
    }
    
    private func handleAnswer(correct: Bool) {
        guard let kana = currentKana else { return }
        
        if correct {
            hapticManager.playSuccessHaptic()
            progressManager.recordCorrectAnswer(for: kana.id)
            nextKana()
        } else {
            hapticManager.playErrorHaptic()
            progressManager.recordIncorrectAnswer(for: kana.id)
            withAnimation(.easeInOut(duration: 0.3)) {
                showingKana = true
            }
        }
    }
    
    private func nextKana() {
        currentIndex += 1
        
        if currentIndex < reviewKana.count {
            currentKana = reviewKana[currentIndex]
            showingKana = false
        } else {
            // End of session - start a new one
            startLearningSession()
        }
    }
}

struct StatsView: View {
    @StateObject private var progressManager = ProgressManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                let stats = progressManager.getOverallStats()
                
                VStack(spacing: 15) {
                    StatRow(icon: "📚", label: "Total", value: "\(stats.totalKana)")
                    StatRow(icon: "🎯", label: "Studied", value: "\(stats.studiedKana)")
                    StatRow(icon: "✅", label: "Success", value: "\(Int(stats.averageSuccessRate * 100))%")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("📊")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
            })
        }
    }
}

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.title2)
            Text(label)
                .font(.body)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
        }
    }
}

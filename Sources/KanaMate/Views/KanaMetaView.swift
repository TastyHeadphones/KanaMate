import SwiftUI

public struct KanaMetaView: View {
    @StateObject private var kanaData = KanaData.shared
    @StateObject private var progressManager = ProgressManager.shared
    @StateObject private var audioManager = AudioManager.shared
    
    @State private var currentKana: Kana?
    @State private var showingKana = false
    @State private var reviewKana: [Kana] = []
    @State private var currentIndex = 0
    @State private var showingStats = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header with stats
                HStack {
                    Button("Stats") {
                        showingStats = true
                    }
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("KanaMate")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button("Reset") {
                        resetLearningSession()
                    }
                    .foregroundColor(.orange)
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
                                    audioManager.playPronunciation(for: kana)
                                }) {
                                    HStack {
                                        Image(systemName: "speaker.wave.2.fill")
                                        Text("Play Sound")
                                    }
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(12)
                                }
                                
                                // Continue button when kana is showing
                                Button("Continue") {
                                    nextKana()
                                }
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
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
                                        Text("Know")
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
                                        Text("Don't Know")
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
                            Text("Welcome to KanaMate")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Learn Japanese Kana")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Button("Start Learning") {
                            startLearningSession()
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                }
                
                Spacer()
                
                // Progress indicator
                if !reviewKana.isEmpty {
                    HStack {
                        Text("Progress: \(currentIndex + 1) / \(reviewKana.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if let kana = currentKana {
                            Text("Category: \(kana.category.rawValue)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .sheet(isPresented: $showingStats) {
                StatsView()
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
    
    private func startLearningSession() {
        reviewKana = progressManager.getKanaForReview(from: kanaData.allKana, limit: 20)
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
            progressManager.recordCorrectAnswer(for: kana.id)
            nextKana()
        } else {
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
                    StatRow(label: "Total Kana", value: "\(stats.totalKana)")
                    StatRow(label: "Studied Kana", value: "\(stats.studiedKana)")
                    StatRow(label: "Success Rate", value: "\(Int(stats.averageSuccessRate * 100))%")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Statistics")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
        }
    }
}

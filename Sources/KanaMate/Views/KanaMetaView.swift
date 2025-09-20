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
            ZStack {
                // Glass effect background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.05),
                        Color.cyan.opacity(0.08)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Header with navigation - Glass effect container
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
                        .glassButtonStyle()
                        
                        // Forgotten kana button
                        Button(action: {
                            hapticManager.playLightImpact()
                            showingForgottenKana = true
                        }) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title2)
                                .foregroundColor(.orange)
                        }
                        .glassButtonStyle()
                        
                        Spacer()
                        
                        // App title with glass effect
                        Text("📚")
                            .font(.title)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        
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
                        .glassButtonStyle()
                        
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
                        .glassButtonStyle()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Spacer()
                
                // Main learning area with glass effect
                if let kana = currentKana {
                    VStack(spacing: 40) {
                        // Romaji display with glass container
                        Text(kana.romaji)
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .padding(30)
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 25))
                            .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(LinearGradient(
                                        gradient: Gradient(colors: [.white.opacity(0.3), .clear]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ), lineWidth: 1)
                            )
                        
                        // Kana display (when revealed) with glass effects
                        if showingKana {
                            VStack(spacing: 20) {
                                HStack(spacing: 30) {
                                    // Hiragana with glass effect
                                    VStack {
                                        Text("Hiragana")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(kana.hiragana)
                                            .font(.system(size: 60, weight: .medium))
                                            .foregroundColor(.blue)
                                    }
                                    .padding(20)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                                    .shadow(color: .blue.opacity(0.2), radius: 8, x: 0, y: 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(LinearGradient(
                                                gradient: Gradient(colors: [.blue.opacity(0.3), .clear]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ), lineWidth: 1)
                                    )
                                    
                                    // Katakana with glass effect
                                    VStack {
                                        Text("Katakana")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(kana.katakana)
                                            .font(.system(size: 60, weight: .medium))
                                            .foregroundColor(.red)
                                    }
                                    .padding(20)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                                    .shadow(color: .red.opacity(0.2), radius: 8, x: 0, y: 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(LinearGradient(
                                                gradient: Gradient(colors: [.red.opacity(0.3), .clear]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ), lineWidth: 1)
                                    )
                                }
                                
                                // Audio button with glass effect
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
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.green, .green.opacity(0.8)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        in: RoundedRectangle(cornerRadius: 12)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.white.opacity(0.3), lineWidth: 1)
                                    )
                                    .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                                
                                // Continue button with glass effect
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
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        in: RoundedRectangle(cornerRadius: 12)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.white.opacity(0.3), lineWidth: 1)
                                    )
                                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                            }
                            .transition(.opacity)
                        } else {
                            // Answer buttons with glass effect
                            HStack(spacing: 40) {
                                // Know button with glass morphism
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
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.green, .green.opacity(0.7)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        in: RoundedRectangle(cornerRadius: 25)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(.white.opacity(0.4), lineWidth: 2)
                                    )
                                    .shadow(color: .green.opacity(0.4), radius: 15, x: 0, y: 8)
                                    .overlay(
                                        // Inner glow effect
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [.white.opacity(0.3), .clear]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                    )
                                }
                                
                                // Don't know button with glass morphism
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
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.red, .red.opacity(0.7)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        in: RoundedRectangle(cornerRadius: 25)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(.white.opacity(0.4), lineWidth: 2)
                                    )
                                    .shadow(color: .red.opacity(0.4), radius: 15, x: 0, y: 8)
                                    .overlay(
                                        // Inner glow effect
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [.white.opacity(0.3), .clear]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                    )
                                }
                            }
                        }
                    }
                } else {
                    // Welcome screen with glass effect
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
                        .padding(30)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 25))
                        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(LinearGradient(
                                    gradient: Gradient(colors: [.white.opacity(0.3), .clear]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ), lineWidth: 1)
                        )
                        
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
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                in: RoundedRectangle(cornerRadius: 12)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                }
                
                Spacer()
                
                // Progress indicator with glass effect
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
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
            }
            .padding()
            }
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
            ZStack {
                // Glass effect background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.1),
                        Color.blue.opacity(0.05),
                        Color.cyan.opacity(0.08)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    let stats = progressManager.getOverallStats()
                    
                    VStack(spacing: 15) {
                        StatRow(icon: "📚", label: "Total", value: "\(stats.totalKana)")
                        StatRow(icon: "🎯", label: "Studied", value: "\(stats.studiedKana)")
                        StatRow(icon: "✅", label: "Success", value: "\(Int(stats.averageSuccessRate * 100))%")
                    }
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(LinearGradient(
                                gradient: Gradient(colors: [.white.opacity(0.3), .clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ), lineWidth: 1)
                    )
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("📊")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
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

// MARK: - Glass Effect Extensions
extension View {
    func glassButtonStyle() -> some View {
        self
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(LinearGradient(
                        gradient: Gradient(colors: [.white.opacity(0.3), .clear]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 1)
            )
    }
}

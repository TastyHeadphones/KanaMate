import SwiftUI

struct ForgottenKanaView: View {
    @StateObject private var progressManager = ProgressManager.shared
    @StateObject private var kanaData = KanaData.shared
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var hapticManager = HapticManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    var forgottenKana: [(Kana, UserProgress)] {
        let allKana = kanaData.allKana
        return progressManager.userProgress.compactMap { (id, progress) in
            guard let kana = allKana.first(where: { $0.id == id }),
                  progress.incorrectCount > 0 else { return nil }
            return (kana, progress)
        }
        .sorted { $0.1.incorrectCount > $1.1.incorrectCount } // Sort by most forgotten
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if forgottenKana.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Text("🎉")
                            .font(.system(size: 80))
                        
                        Text("Perfect Memory!")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("You haven't forgotten any kana yet")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Header stats
                    VStack(spacing: 10) {
                        Text("📝 Frequently Forgotten")
                            .font(.headline)
                        
                        Text("\(forgottenKana.count) kana need review")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Forgotten kana list
                    List {
                        ForEach(forgottenKana, id: \.0.id) { kana, progress in
                            ForgottenKanaRow(
                                kana: kana,
                                progress: progress,
                                onPlay: {
                                    hapticManager.playLightImpact()
                                    audioManager.playPronunciation(for: kana)
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("💭")
            .navigationBarItems(
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            )
        }
    }
}

struct ForgottenKanaRow: View {
    let kana: Kana
    let progress: UserProgress
    let onPlay: () -> Void
    
    var difficultLevel: String {
        if progress.incorrectCount >= 5 {
            return "🔴"
        } else if progress.incorrectCount >= 3 {
            return "🟡"
        } else {
            return "🟢"
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Difficulty indicator
            Text(difficultLevel)
                .font(.title2)
            
            // Kana display
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(kana.hiragana)
                        .font(.title3)
                        .foregroundColor(.blue)
                    
                    Text(kana.katakana)
                        .font(.title3)
                        .foregroundColor(.red)
                }
                
                Text(kana.romaji)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Stats
            VStack(alignment: .trailing, spacing: 2) {
                Text("❌ \(progress.incorrectCount)")
                    .font(.caption)
                    .foregroundColor(.red)
                
                if progress.correctCount > 0 {
                    Text("✅ \(progress.correctCount)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                
                Text("\(Int(progress.successRate * 100))%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // Play button
            Button(action: onPlay) {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.title3)
                    .foregroundColor(.green)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
    }
}

struct ForgottenKanaView_Previews: PreviewProvider {
    static var previews: some View {
        ForgottenKanaView()
    }
}
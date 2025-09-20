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
            ZStack {
                // Glass effect background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.orange.opacity(0.1),
                        Color.red.opacity(0.05),
                        Color.pink.opacity(0.08)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    if forgottenKana.isEmpty {
                        // Empty state with glass effect
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Header stats with glass effect
                        VStack(spacing: 10) {
                            Text("📝 Frequently Forgotten")
                                .font(.headline)
                            
                            Text("\(forgottenKana.count) kana need review")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Forgotten kana list with glass effect
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
                            .listRowBackground(.thinMaterial)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .scrollContentBackground(.hidden)
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
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
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
            // Difficulty indicator with glass effect
            Text(difficultLevel)
                .font(.title2)
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
            
            // Kana display with glass containers
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(kana.hiragana)
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(6)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
                        .shadow(color: .blue.opacity(0.2), radius: 2, x: 0, y: 1)
                    
                    Text(kana.katakana)
                        .font(.title3)
                        .foregroundColor(.red)
                        .padding(6)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
                        .shadow(color: .red.opacity(0.2), radius: 2, x: 0, y: 1)
                }
                
                Text(kana.romaji)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Stats with glass container
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
            .padding(8)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
            
            // Play button with glass effect
            Button(action: onPlay) {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.title3)
                    .foregroundColor(.green)
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
                    .shadow(color: .green.opacity(0.2), radius: 3, x: 0, y: 1)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ForgottenKanaView_Previews: PreviewProvider {
    static var previews: some View {
        ForgottenKanaView()
    }
}
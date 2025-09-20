import SwiftUI

struct KanaChartView: View {
    @StateObject private var kanaData = KanaData.shared
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var hapticManager = HapticManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedCategory: Kana.KanaCategory = .basic
    
    var body: some View {
        NavigationView {
            ZStack {
                // Glass effect background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.cyan.opacity(0.1),
                        Color.blue.opacity(0.05),
                        Color.purple.opacity(0.08)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Category selector with glass effect
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(Kana.KanaCategory.allCases, id: \.self) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    hapticManager.playLightImpact()
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 15)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 0))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Kana grid
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 15) {
                            ForEach(kanaData.getKana(by: selectedCategory), id: \.id) { kana in
                                KanaCard(kana: kana) {
                                    hapticManager.playLightImpact()
                                    audioManager.playPronunciation(for: kana)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("📖")
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

struct CategoryButton: View {
    let category: Kana.KanaCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Text(categoryIcon(for: category))
                    .font(.title2)
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .clear]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                },
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .opacity(isSelected ? 0 : 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: isSelected ? .blue.opacity(0.3) : .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
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
}

struct KanaCard: View {
    let kana: Kana
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Romaji
                Text(kana.romaji)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Hiragana and Katakana with individual glass containers
                VStack(spacing: 4) {
                    Text(kana.hiragana)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .blue.opacity(0.2), radius: 3, x: 0, y: 2)
                    
                    Text(kana.katakana)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.red)
                        .padding(8)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .red.opacity(0.2), radius: 3, x: 0, y: 2)
                }
                
                // Audio icon with glass effect
                Image(systemName: "speaker.wave.1.fill")
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding(6)
                    .background(.ultraThinMaterial, in: Circle())
                    .shadow(color: .green.opacity(0.2), radius: 2, x: 0, y: 1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(LinearGradient(
                        gradient: Gradient(colors: [.white.opacity(0.3), .clear]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct KanaChartView_Previews: PreviewProvider {
    static var previews: some View {
        KanaChartView()
    }
}
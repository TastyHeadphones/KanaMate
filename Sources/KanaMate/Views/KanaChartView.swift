import SwiftUI

struct KanaChartView: View {
    @StateObject private var kanaData = KanaData.shared
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var hapticManager = HapticManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedCategory: Kana.KanaCategory = .basic
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category selector
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
                .padding(.vertical, 10)
                
                Divider()
                
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
            .navigationTitle("📖")
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
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
            )
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
                
                // Hiragana and Katakana
                VStack(spacing: 4) {
                    Text(kana.hiragana)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.blue)
                    
                    Text(kana.katakana)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.red)
                }
                
                // Audio icon
                Image(systemName: "speaker.wave.1.fill")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct KanaChartView_Previews: PreviewProvider {
    static var previews: some View {
        KanaChartView()
    }
}
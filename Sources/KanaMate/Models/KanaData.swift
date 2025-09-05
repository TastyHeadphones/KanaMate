import Foundation

/// Represents a single kana character with its properties
struct Kana: Identifiable, Codable {
    let id = UUID()
    let romaji: String
    let hiragana: String
    let katakana: String
    let category: KanaCategory
    
    enum KanaCategory: String, CaseIterable, Codable {
        case basic = "Basic"
        case voiced = "Voiced"
        case semiVoiced = "Semi-voiced"
        case combination = "Combination"
    }
}

/// Data source for all kana characters
class KanaData: ObservableObject {
    static let shared = KanaData()
    
    @Published var allKana: [Kana] = []
    
    private init() {
        loadKanaData()
    }
    
    private func loadKanaData() {
        // Basic kana (50 sounds)
        let basicKana = [
            Kana(romaji: "a", hiragana: "あ", katakana: "ア", category: .basic),
            Kana(romaji: "i", hiragana: "い", katakana: "イ", category: .basic),
            Kana(romaji: "u", hiragana: "う", katakana: "ウ", category: .basic),
            Kana(romaji: "e", hiragana: "え", katakana: "エ", category: .basic),
            Kana(romaji: "o", hiragana: "お", katakana: "オ", category: .basic),
            
            Kana(romaji: "ka", hiragana: "か", katakana: "カ", category: .basic),
            Kana(romaji: "ki", hiragana: "き", katakana: "キ", category: .basic),
            Kana(romaji: "ku", hiragana: "く", katakana: "ク", category: .basic),
            Kana(romaji: "ke", hiragana: "け", katakana: "ケ", category: .basic),
            Kana(romaji: "ko", hiragana: "こ", katakana: "コ", category: .basic),
            
            Kana(romaji: "sa", hiragana: "さ", katakana: "サ", category: .basic),
            Kana(romaji: "shi", hiragana: "し", katakana: "シ", category: .basic),
            Kana(romaji: "su", hiragana: "す", katakana: "ス", category: .basic),
            Kana(romaji: "se", hiragana: "せ", katakana: "セ", category: .basic),
            Kana(romaji: "so", hiragana: "そ", katakana: "ソ", category: .basic),
            
            Kana(romaji: "ta", hiragana: "た", katakana: "タ", category: .basic),
            Kana(romaji: "chi", hiragana: "ち", katakana: "チ", category: .basic),
            Kana(romaji: "tsu", hiragana: "つ", katakana: "ツ", category: .basic),
            Kana(romaji: "te", hiragana: "て", katakana: "テ", category: .basic),
            Kana(romaji: "to", hiragana: "と", katakana: "ト", category: .basic),
            
            Kana(romaji: "na", hiragana: "な", katakana: "ナ", category: .basic),
            Kana(romaji: "ni", hiragana: "に", katakana: "ニ", category: .basic),
            Kana(romaji: "nu", hiragana: "ぬ", katakana: "ヌ", category: .basic),
            Kana(romaji: "ne", hiragana: "ね", katakana: "ネ", category: .basic),
            Kana(romaji: "no", hiragana: "の", katakana: "ノ", category: .basic),
            
            Kana(romaji: "ha", hiragana: "は", katakana: "ハ", category: .basic),
            Kana(romaji: "hi", hiragana: "ひ", katakana: "ヒ", category: .basic),
            Kana(romaji: "fu", hiragana: "ふ", katakana: "フ", category: .basic),
            Kana(romaji: "he", hiragana: "へ", katakana: "ヘ", category: .basic),
            Kana(romaji: "ho", hiragana: "ほ", katakana: "ホ", category: .basic),
            
            Kana(romaji: "ma", hiragana: "ま", katakana: "マ", category: .basic),
            Kana(romaji: "mi", hiragana: "み", katakana: "ミ", category: .basic),
            Kana(romaji: "mu", hiragana: "む", katakana: "ム", category: .basic),
            Kana(romaji: "me", hiragana: "め", katakana: "メ", category: .basic),
            Kana(romaji: "mo", hiragana: "も", katakana: "モ", category: .basic),
            
            Kana(romaji: "ya", hiragana: "や", katakana: "ヤ", category: .basic),
            Kana(romaji: "yu", hiragana: "ゆ", katakana: "ユ", category: .basic),
            Kana(romaji: "yo", hiragana: "よ", katakana: "ヨ", category: .basic),
            
            Kana(romaji: "ra", hiragana: "ら", katakana: "ラ", category: .basic),
            Kana(romaji: "ri", hiragana: "り", katakana: "リ", category: .basic),
            Kana(romaji: "ru", hiragana: "る", katakana: "ル", category: .basic),
            Kana(romaji: "re", hiragana: "れ", katakana: "レ", category: .basic),
            Kana(romaji: "ro", hiragana: "ろ", katakana: "ロ", category: .basic),
            
            Kana(romaji: "wa", hiragana: "わ", katakana: "ワ", category: .basic),
            Kana(romaji: "wo", hiragana: "を", katakana: "ヲ", category: .basic),
            Kana(romaji: "n", hiragana: "ん", katakana: "ン", category: .basic),
        ]
        
        // Voiced sounds (dakuten)
        let voicedKana = [
            Kana(romaji: "ga", hiragana: "が", katakana: "ガ", category: .voiced),
            Kana(romaji: "gi", hiragana: "ぎ", katakana: "ギ", category: .voiced),
            Kana(romaji: "gu", hiragana: "ぐ", katakana: "グ", category: .voiced),
            Kana(romaji: "ge", hiragana: "げ", katakana: "ゲ", category: .voiced),
            Kana(romaji: "go", hiragana: "ご", katakana: "ゴ", category: .voiced),
            
            Kana(romaji: "za", hiragana: "ざ", katakana: "ザ", category: .voiced),
            Kana(romaji: "ji", hiragana: "じ", katakana: "ジ", category: .voiced),
            Kana(romaji: "zu", hiragana: "ず", katakana: "ズ", category: .voiced),
            Kana(romaji: "ze", hiragana: "ぜ", katakana: "ゼ", category: .voiced),
            Kana(romaji: "zo", hiragana: "ぞ", katakana: "ゾ", category: .voiced),
            
            Kana(romaji: "da", hiragana: "だ", katakana: "ダ", category: .voiced),
            Kana(romaji: "ji", hiragana: "ぢ", katakana: "ヂ", category: .voiced),
            Kana(romaji: "zu", hiragana: "づ", katakana: "ヅ", category: .voiced),
            Kana(romaji: "de", hiragana: "で", katakana: "デ", category: .voiced),
            Kana(romaji: "do", hiragana: "ど", katakana: "ド", category: .voiced),
            
            Kana(romaji: "ba", hiragana: "ば", katakana: "バ", category: .voiced),
            Kana(romaji: "bi", hiragana: "び", katakana: "ビ", category: .voiced),
            Kana(romaji: "bu", hiragana: "ぶ", katakana: "ブ", category: .voiced),
            Kana(romaji: "be", hiragana: "べ", katakana: "ベ", category: .voiced),
            Kana(romaji: "bo", hiragana: "ぼ", katakana: "ボ", category: .voiced),
        ]
        
        // Semi-voiced sounds (handakuten)
        let semiVoicedKana = [
            Kana(romaji: "pa", hiragana: "ぱ", katakana: "パ", category: .semiVoiced),
            Kana(romaji: "pi", hiragana: "ぴ", katakana: "ピ", category: .semiVoiced),
            Kana(romaji: "pu", hiragana: "ぷ", katakana: "プ", category: .semiVoiced),
            Kana(romaji: "pe", hiragana: "ぺ", katakana: "ペ", category: .semiVoiced),
            Kana(romaji: "po", hiragana: "ぽ", katakana: "ポ", category: .semiVoiced),
        ]
        
        // Combination sounds (youon)
        let combinationKana = [
            Kana(romaji: "kya", hiragana: "きゃ", katakana: "キャ", category: .combination),
            Kana(romaji: "kyu", hiragana: "きゅ", katakana: "キュ", category: .combination),
            Kana(romaji: "kyo", hiragana: "きょ", katakana: "キョ", category: .combination),
            
            Kana(romaji: "sha", hiragana: "しゃ", katakana: "シャ", category: .combination),
            Kana(romaji: "shu", hiragana: "しゅ", katakana: "シュ", category: .combination),
            Kana(romaji: "sho", hiragana: "しょ", katakana: "ショ", category: .combination),
            
            Kana(romaji: "cha", hiragana: "ちゃ", katakana: "チャ", category: .combination),
            Kana(romaji: "chu", hiragana: "ちゅ", katakana: "チュ", category: .combination),
            Kana(romaji: "cho", hiragana: "ちょ", katakana: "チョ", category: .combination),
            
            Kana(romaji: "nya", hiragana: "にゃ", katakana: "ニャ", category: .combination),
            Kana(romaji: "nyu", hiragana: "にゅ", katakana: "ニュ", category: .combination),
            Kana(romaji: "nyo", hiragana: "にょ", katakana: "ニョ", category: .combination),
            
            Kana(romaji: "hya", hiragana: "ひゃ", katakana: "ヒャ", category: .combination),
            Kana(romaji: "hyu", hiragana: "ひゅ", katakana: "ヒュ", category: .combination),
            Kana(romaji: "hyo", hiragana: "ひょ", katakana: "ヒョ", category: .combination),
            
            Kana(romaji: "mya", hiragana: "みゃ", katakana: "ミャ", category: .combination),
            Kana(romaji: "myu", hiragana: "みゅ", katakana: "ミュ", category: .combination),
            Kana(romaji: "myo", hiragana: "みょ", katakana: "ミョ", category: .combination),
            
            Kana(romaji: "rya", hiragana: "りゃ", katakana: "リャ", category: .combination),
            Kana(romaji: "ryu", hiragana: "りゅ", katakana: "リュ", category: .combination),
            Kana(romaji: "ryo", hiragana: "りょ", katakana: "リョ", category: .combination),
        ]
        
        allKana = basicKana + voicedKana + semiVoicedKana + combinationKana
    }
    
    func getKana(by category: Kana.KanaCategory) -> [Kana] {
        return allKana.filter { $0.category == category }
    }
}
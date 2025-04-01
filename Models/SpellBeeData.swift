import Foundation

struct SpellBeeData: Codable {
    let spellbee_id: Int
    let date: String
    let words: [String]
    let sentences: [String]
    let status: Bool
}

struct WordItem: Codable {
    let word: String
    let sentence: String
}

struct WordResponse: Codable {
    let words: [WordItem]
}

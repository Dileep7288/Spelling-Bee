import Foundation

struct SpellBeeData: Codable {
    let spellbee_id: Int
    let date: String
    let words: [String]
    let sentences: [String]
    let status: Bool
}

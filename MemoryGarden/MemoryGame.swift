import Foundation

// Game rules are independent of the UI, making them easy to understand and test.
struct MemoryGame {
    struct Card: Identifiable {
        let id = UUID()
        let symbol: String
        var isFaceUp = false
        var isMatched = false
    }

    private(set) var cards: [Card] = []
    private(set) var moves = 0
    private(set) var selectedIndex: Int?
    private(set) var pendingPair: (Int, Int)?
    private(set) var roundID = UUID()

    var matchedPairs: Int { cards.filter { $0.isMatched }.count / 2 }
    var isComplete: Bool { !cards.isEmpty && cards.allSatisfy { $0.isMatched } }
    var isResolving: Bool { pendingPair != nil }

    init(pairCount: Int = 4) { reset(pairCount: pairCount) }

    mutating func reset(pairCount: Int) {
        let symbols = ["🌻", "🍄", "🦋", "🍓", "🌵", "🐝", "🍀", "🌷"]
        let count = min(max(pairCount, 2), symbols.count)
        cards = symbols.shuffled().prefix(count).flatMap {
            [Card(symbol: $0), Card(symbol: $0)]
        }.shuffled()
        moves = 0
        selectedIndex = nil
        pendingPair = nil
        roundID = UUID()
    }

    mutating func choose(_ id: UUID) {
        guard !isResolving,
              let index = cards.firstIndex(where: { $0.id == id }),
              !cards[index].isMatched else { return }

        // Tapping the first card again turns it back down.
        if selectedIndex == index {
            cards[index].isFaceUp = false
            selectedIndex = nil
            return
        }

        cards[index].isFaceUp = true
        if let first = selectedIndex {
            moves += 1
            pendingPair = (first, index)
            selectedIndex = nil
        } else {
            selectedIndex = index
        }
    }

    // The round token prevents an old timer from modifying a new game.
    mutating func resolvePair(in round: UUID) {
        guard round == roundID, let (first, second) = pendingPair else { return }
        if cards[first].symbol == cards[second].symbol {
            cards[first].isMatched = true
            cards[second].isMatched = true
        } else {
            cards[first].isFaceUp = false
            cards[second].isFaceUp = false
        }
        pendingPair = nil
    }
}

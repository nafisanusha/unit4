import SwiftUI

struct ContentView: View {
    @State private var game = MemoryGame()
    @State private var pairCount = 4
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let ink = Color(red: 0.13, green: 0.27, blue: 0.22)
    private let columns = [GridItem(.adaptive(minimum: 85, maximum: 140), spacing: 12)]
    private var motion: Animation? { reduceMotion ? nil : .easeInOut(duration: 0.25) }

    var body: some View {
        VStack(spacing: 18) {
            VStack(spacing: 6) {
                Text("MEMORY GARDEN")
                    .font(.caption.weight(.bold)).tracking(3)
                Text("Find your pairs")
                    .font(.largeTitle.bold())
                Text("Flip two cards. Match them to clear the garden.")
                    .font(.subheadline).multilineTextAlignment(.center)
            }

            Picker("Number of pairs", selection: $pairCount) {
                ForEach([2, 4, 6, 8], id: \.self) { count in
                    Text("\(count) pairs").tag(count)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: pairCount) { newCount in
                withAnimation(motion) { game.reset(pairCount: newCount) }
            }

            HStack {
                Label("\(game.moves) moves", systemImage: "hand.tap")
                Spacer()
                Text("\(game.matchedPairs) / \(pairCount) pairs")
            }
            .font(.subheadline.weight(.semibold))

            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(game.cards) { card in
                        Button { flip(card) } label: {
                            CardView(card: card, ink: ink)
                        }
                        .buttonStyle(.plain)
                        .opacity(card.isMatched ? 0 : 1)
                        .disabled(card.isMatched || game.isResolving)
                        .accessibilityHidden(card.isMatched)
                        .accessibilityLabel(card.isFaceUp ? card.symbol : "Face-down card")
                        .accessibilityHint("Tap to flip")
                    }
                }
                .padding(.vertical, 8)

                if game.isComplete {
                    VStack(spacing: 8) {
                        Text("Garden cleared! 🌻").font(.title2.bold())
                        Text("You found every pair in \(game.moves) moves.")
                    }
                    .padding().frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .accessibilityElement(children: .combine)
                }
            }

            Button {
                withAnimation(motion) { game.reset(pairCount: pairCount) }
            } label: {
                Label("New game", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .foregroundColor(.white).background(ink)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(ink)
        .background(Color(red: 0.94, green: 0.96, blue: 0.89).ignoresSafeArea())
    }

    private func flip(_ card: MemoryGame.Card) {
        withAnimation(motion) { game.choose(card.id) }
        guard game.isResolving else { return }
        let round = game.roundID
        // Keep both faces visible briefly before hiding or removing the pair.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
            withAnimation(motion) { game.resolvePair(in: round) }
        }
    }
}

private struct CardView: View {
    let card: MemoryGame.Card
    let ink: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(card.isFaceUp ? Color.white : ink)
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                .padding(7)
            if card.isFaceUp {
                Text(card.symbol).font(.system(size: 40))
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            } else {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(red: 0.80, green: 0.89, blue: 0.60))
            }
        }
        .frame(height: 116)
        .rotation3DEffect(.degrees(card.isFaceUp ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View { ContentView() }
}

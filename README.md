# Project 4 - *Memory Garden*

Submitted by: **Nafisa Nusha**

**Memory Garden** is a SwiftUI memory game where players flip garden-themed cards, find matching pairs, and clear the board. Players can choose the number of pairs and start a fresh, shuffled game at any time.

Time spent: **[3]** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] App loads to display a grid of cards initially placed face-down:
  - Upon launching the app, a shuffled grid of cards is visible.
  - Cards show a leaf design on their backs at the start of the game.
- [x] Users can tap cards to toggle their display between the back and the face:
  - Tapping a face-down card reveals its garden symbol.
  - Tapping the first card again returns it to the face-down position.
  - Tapping a second nonmatching card flips both back down after a short delay.
- [x] When two matching cards are found, they both disappear from view:
  - The game compares the symbols on two selected cards.
  - Matching cards disappear after a brief reveal delay.
  - Nonmatching cards return to the face-down position.
- [x] User can reset the game and start a new game via a button:
  - The **New game** button starts a new round.
  - It shuffles the cards and resets moves, matches, and selections.

The following **optional** features are implemented:

- [x] User can select number of pairs to play with (at least 2 unique values like 2 and 4).
  - A segmented Picker offers 2, 4, 6, or 8 pairs.
- [x] App allows for user to scroll to see pairs out of view.
  - A ScrollView contains an adaptive card grid.
- [x] Add any flavor you’d like to your UI with colored buttons or backgrounds, unique cards, etc.
  - Soft green background, dark green card backs, and garden-themed emoji.
  - Animated card flips and disappearing matches.

The following **additional** features are implemented:

- [x] Move counter and matched-pair progress.
- [x] Completion message showing the final move count.
- [x] Prevents selecting a third card while checking a pair.
- [x] Protects the new board from delayed callbacks after a reset.
- [x] VoiceOver card labels and reduced-motion support.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

**https://www.loom.com/share/2bf6c84a109e44cba4a697f3e14d0aaf**


## Notes

One implementation challenge was resetting the game while two cards were still waiting to be checked. Every new game receives a unique round ID. The delayed callback checks this ID before changing any cards, so an earlier round cannot affect the new board.

Matched cards become invisible while keeping their positions in the grid. This keeps the remaining cards in familiar locations. Card taps are disabled briefly while a pair is being checked to keep game state consistent.


## License

    Copyright 2026 [nafisa nusha]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

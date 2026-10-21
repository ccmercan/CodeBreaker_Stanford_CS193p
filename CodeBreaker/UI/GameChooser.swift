//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by cag on 10/21/26.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        NavigationStack{
            List($games, id: \.pegChoices, editActions: [.delete, .move]) { $game in
                NavigationLink{
                    CodeBreakerView(game: $game)
                } label : {
                    GameSummary(game: game)
                }
            }
            .listStyle(.plain)
            .toolbar{
                EditButton()
            }
        }

        .onAppear{
            games.append(CodeBreaker(name:"Mastermind",numberOfPegs: 4, pegChoices: ["red","blue","green","yellow"]))
            games.append(CodeBreaker(name:"Earth Tones",numberOfPegs: 5, pegChoices: ["orange","brown","black","yellow","green"]))
            games.append(CodeBreaker(name:"Undersea",numberOfPegs: 3, pegChoices: ["blue","indigo","cyan"]))
        }
    }
}

#Preview {
    GameChooser()
}

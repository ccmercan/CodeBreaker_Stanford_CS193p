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
            List{
                ForEach(games) { game in
                    NavigationLink(value: game){
                        GameSummary(game:game)
                    }
            
                }
                .onDelete{ offsets in
                    games.remove(atOffsets:offsets)
                }
                .onMove { offsets, destination in
                    games.move(fromOffsets: offsets, toOffset: destination)
                }
            }
            .navigationDestination(for: CodeBreaker.self){ game in
                CodeBreakerView(game:game)
                
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

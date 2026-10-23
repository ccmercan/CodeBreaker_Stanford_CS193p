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
    
    @State private var selection: CodeBreaker? = nil
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)){
            List(selection:$selection){
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
            .navigationTitle("Code Breaker")
            .listStyle(.plain)
            .toolbar{
                EditButton()
            }
        }
        detail:{
            if let selection {
                CodeBreakerView(game:selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            }
            else{
                Text("Choose a game.")
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear{
            games.append(CodeBreaker(name:"Mastermind",numberOfPegs: 4, pegChoices: ["red","blue","green","yellow"]))
            games.append(CodeBreaker(name:"Earth Tones",numberOfPegs: 5, pegChoices: ["orange","brown","black","yellow","green"]))
            games.append(CodeBreaker(name:"Undersea",numberOfPegs: 3, pegChoices: ["blue","indigo","cyan"]))
            selection = games.first
        }
    }
}

#Preview {
    GameChooser()
}

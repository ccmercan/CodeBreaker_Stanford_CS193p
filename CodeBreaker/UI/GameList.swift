//
//  GameList.swift
//  CodeBreaker
//
//  Created by cag on 10/24/26.
//

import SwiftUI

struct GameList: View {
     
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        List(selection:$selection){
            ForEach(games) { game in
                NavigationLink(value: game){
                    GameSummary(game:game)
                }
                .contextMenu{
                    deleteButton(for: game)
                }
            }
            
            
            .onDelete{ offsets in
                games.remove(atOffsets:offsets)
            }
            .onMove { offsets, destination in
                games.move(fromOffsets: offsets, toOffset: destination)
            }
        }
        .onChange(of:games){
            if let selection, !games.contains(selection){
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar{
            Button("Add Game", systemImage: "plus"){
                let newGame = CodeBreaker(name:"Untitled", numberOfPegs: 3, pegChoices: ["red","blue","yellow"])
                games.append(newGame)
            }
            EditButton()
        }
        .onAppear{addSampleGames() }
    }
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete",systemImage: "minus.circle", role: .destructive){
            withAnimation{
                games.removeAll{$0 == game}
            }
            
        }
    }

        func addSampleGames() {
            if games.isEmpty{
                games.append(CodeBreaker(name:"Mastermind",numberOfPegs: 4, pegChoices: ["red","blue","green","yellow"]))
                games.append(CodeBreaker(name:"Earth Tones",numberOfPegs: 5, pegChoices: ["orange","brown","black","yellow","green"]))
                games.append(CodeBreaker(name:"Undersea",numberOfPegs: 3, pegChoices: ["blue","indigo","cyan"]))
                selection = games.first
            }
        }

    }


#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack{
        GameList(selection: $selection)
    }
}

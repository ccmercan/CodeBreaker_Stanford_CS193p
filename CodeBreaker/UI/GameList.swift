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
    
    
    @State private var showGameEditor: Bool = false
    @State private var gameToEdit: CodeBreaker?
    
    var body: some View {
        List(selection:$selection){
            ForEach(games) { game in
                NavigationLink(value: game){
                    GameSummary(game:game)
                }
                .contextMenu{
                    editButton(for: game) // editing a game
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading) {
                    editButton(for: game).tint(.accentColor)
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
            addButton
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
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }
    
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus"){
            gameToEdit = CodeBreaker(name:"Untitled", numberOfPegs: 3, pegChoices: ["red","blue","yellow"])
            
        }
        .onChange(of: gameToEdit){
            showGameEditor = gameToEdit != nil
        }
        .sheet(isPresented: $showGameEditor, onDismiss: { gameToEdit = nil }){
            gameEditor
        }
    }
    
    @ViewBuilder
    var gameEditor: some View{
        if let gameToEdit{
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, numberOfPegs: gameToEdit.masterCode.pegs.count, pegChoices: gameToEdit.pegChoices) // careful this is reference type cant do = gameToEdit
            GameEditor(game: copyOfGameToEdit){
                if let index = games.firstIndex(of: gameToEdit){
                    games[index] = copyOfGameToEdit
                } else {
                    games.insert(gameToEdit, at: 0)
                }
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

//
//  GameList.swift
//  CodeBreaker
//
//  Created by cag on 10/24/26.
//

import SwiftUI
import SwiftData
struct GameList: View {
     // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    @Query(sort: \CodeBreaker.name, order: .forward) private var games: [CodeBreaker]
    // MARK: Data Owned by Me
    
    
    
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
                for offset in offsets{
                    modelContext.delete(games[offset])
                }
                //games.remove(atOffsets:offsets)
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
                modelContext.delete(game)
                
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
                if games.contains(gameToEdit){
                    modelContext.delete(gameToEdit)
                    modelContext.insert(copyOfGameToEdit)
                    
                }
                modelContext.insert(copyOfGameToEdit)
            }
            
            
        }
    }
    
    func addSampleGames() {
            let fetchDescriptor = FetchDescriptor<CodeBreaker> ()
            
            do {
                let results = try modelContext.fetch(fetchDescriptor)
                if results.count == 0 {
                    modelContext.insert(CodeBreaker(name:"Mastermind",numberOfPegs: 4, pegChoices: ["red","blue","green","yellow"]))
                    modelContext.insert(CodeBreaker(name:"Earth Tones",numberOfPegs: 5, pegChoices: ["orange","brown","black","yellow","green"]))
                    modelContext.insert(CodeBreaker(name:"Undersea",numberOfPegs: 3, pegChoices: ["blue","indigo","cyan"]))
                    
                }
            } catch {
                print("Had a problem counting games: \(error.localizedDescription)")
            }
        
        
            
        }

    }


#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack{
        GameList(selection: $selection)
    }
    .modelContainer(for: CodeBreaker.self, inMemory: true)
    
}

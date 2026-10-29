//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by cag on 10/24/26.
//

import SwiftUI

struct GameEditor: View {
    @Bindable var game: CodeBreaker
    
    var body: some View {
        Form {
            TextField("Name", text: $game.name)
            List{
                ForEach(game.pegChoices.indices, id:\.self) { index in
                ColorPicker(
                    selection: $game.pegChoices[index]]),
                    supportsOpacity: false
                ){
                    Text("Peg Choice ")
                }
                }
            }
        }
    }
    let supportedColors: [String: Color] = [
        "brown": .brown,
        "yellow": .yellow,
        "orange": .orange,
        "black": .black,
        "pink": .pink,
        "purple": .purple,
        "red": .red,
        "blue": .blue,
        "green": .green,
        "indigo": .indigo,
        "cyan": .cyan
        
    ]
}

#Preview {
    let game = CodeBreaker(name:"Preview", numberOfPegs: 3, pegChoices: ["orange","purple","black"])
    GameEditor(game: game)
        .onChange(of: game.name){
            print("game name changed to \(game.name)")
        }
        .onChange(of: game.pegChoices){
            print("game pegs changed to \(game.pegChoices)")
        }
}

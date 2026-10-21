//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by cag on 10/21/26.
//

import SwiftUI

struct GameSummary: View {
    //MARK: Data In
    let game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading){
            Text(game.name).font(.title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempt](inflect:true)")
        }
    }
}

#Preview {
    List{
        GameSummary(game:CodeBreaker(name:"Preview",numberOfPegs: 2, pegChoices:["red","cyan","yellow"]))

    }
    List{
        GameSummary(game:CodeBreaker(name:"Preview",numberOfPegs: 2, pegChoices:["red","cyan","yellow"]))

    }
    .listStyle(.plain)
}

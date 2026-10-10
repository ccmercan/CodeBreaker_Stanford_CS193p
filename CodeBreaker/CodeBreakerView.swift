//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by cag on 9/17/26.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker(numberOfPegs: 6,pegChoices: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐"])
    
    
    
    var body: some View {
        VStack {
            
            view(for: game.masterCode)
            ScrollView{
                    view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self){index in
                    view(for:game.attempts[index])
                }
            }
           
            
            
        }
        .padding()
    }
    
    var guessButton: some View{
        return Button("Guess"){
            withAnimation{
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
        
        var restartButton: some View{
            return Button("Restart"){
                withAnimation{
                    
                    game = CodeBreaker.randomGame()
                }
            }
            .font(.system(size: 80))
            .minimumScaleFactor(0.1)
        
    }
    func view(for code:Code) -> some View {
        HStack{
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(peg: code.pegs[index])
                .contentShape(Rectangle())
                .aspectRatio(1, contentMode: .fit)
                .padding(3)
                .onTapGesture {
                    if code.kind == .guess {
                        game.changeGuessPeg(at: index)
                    }
                }
            }
            
            RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.clear).aspectRatio(1,contentMode: .fit).overlay{
            if let matches = code.matches{
                MatchMarkers(matches: matches)
                }
            else {
                
                if code.kind == .guess{
                    guessButton
                }
                if code.kind == .master{
                    restartButton
                        }
                    
                }
            }
            
    
            
        }
    }
}


#Preview {
    CodeBreakerView()
}

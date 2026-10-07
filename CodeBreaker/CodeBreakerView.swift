//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by cag on 9/17/26.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker(numberOfPegs: 6,pegChoices: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐"])
    
    private let supportedColors: [String: Color] = [
        "brown": .brown,
        "yellow": .yellow,
        "orange": .orange,
        "black": .black,
        "pink": .pink,
        "purple": .purple
    ]
    
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
            .font(.system(size: 148))
            .minimumScaleFactor(0.1)
        
    }
    func view(for code:Code) -> some View {
        HStack(){
            ForEach(code.pegs.indices, id: \.self) { index in
                ZStack {
                    if code.pegs[index] == Code.missing {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray)
                    } else if let color = supportedColors[code.pegs[index]] {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                                .fill(Color.clear)
                                .overlay {
                                    Text(code.pegs[index])
                                        .font(.system(size: 120))
                                        .minimumScaleFactor(9.0 / 120.0)
                                        .lineLimit(1)
                                }
                        }
                }
                .contentShape(Rectangle())
                .aspectRatio(1, contentMode: .fit)
                .padding(3)
                .onTapGesture {
                    if code.kind == .guess {
                        game.changeGuessPeg(at: index)
                    }
                }
            }
            /*"ForEach(code.pegs.indices, id: \.self){index in
                RoundedRectangle(cornerRadius: 10)
                    .overlay{
                        if code.pegs[index] == Code.missing{
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1,contentMode: .fit)
                    //.foregroundStyle(code.pegs[index])
                    .padding(3)
                    .onTapGesture{
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }*/
            
            
            
            MatchMarkers(matches: code.matches)
                .overlay{
                    if code.kind == .master{
                        restartButton
                    }
                    if code.kind == .guess{
                        guessButton
                    }
                    
                }
            
    
            
        }
    }
}


#Preview {
    CodeBreakerView()
}

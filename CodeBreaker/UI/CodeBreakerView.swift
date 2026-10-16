//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by cag on 9/17/26.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Owned by Me
    @State private var game = CodeBreaker(numberOfPegs: 6,pegChoices: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐"])
    
    @State private var selection: Int = 0
    // MARK: - Body
    
    
    var body: some View {
        VStack {
            
            CodeView(code: game.masterCode){
                Text("0:03")
                    .font(.title)
            }
            ScrollView{
                if !game.isOver{
                    CodeView(code: game.guess,selection: $selection){
                        guessButton
                    }
                             
                }
                   
                ForEach(game.attempts.indices.reversed(), id: \.self){index in
                    CodeView(
                        code:game.attempts[index])
                        {
                            if let matches = game.attempts[index].matches{
                                MatchMarkers(matches: matches)
                            }
                            }
                }
            }
            PegChooser(choices: game.pegChoices) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }
            restartButton
                .aspectRatio(0.3,contentMode: .fit)
           
        }
        .padding()
    }
    
    
    
    var guessButton: some View{
        return Button("Guess"){
            withAnimation{
                game.attemptGuess()
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
        
        var restartButton: some View{
            return Button("Restart"){
                withAnimation{
                    selection = 0
                    game = CodeBreaker.randomGame()
                    
                }
            }
            .font(.system(size: 80))
            .minimumScaleFactor(0.1)
        
    }
    
    struct GuessButton{
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
    }
    
}

extension Color {
    static func gray(_ brightness:CGFloat) -> Color{
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    CodeBreakerView()
}

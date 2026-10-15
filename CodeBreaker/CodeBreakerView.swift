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
            
            view(for: game.masterCode)
            ScrollView{
                if !game.isOver{
                    view(for: game.guess)
                }
                   
                ForEach(game.attempts.indices.reversed(), id: \.self){index in
                    view(for:game.attempts[index])
                }
            }
            PegChooser(choices: game.pegChoices) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
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
    func view(for code:Code) -> some View {
        HStack{
            CodeView(code: code, selection: $selection)
            
            CodeView.Selection.shape
                .foregroundStyle(Color.clear).aspectRatio(1,contentMode: .fit)
                .overlay{
                    if let matches = code.matches{
                        MatchMarkers(matches: matches)
                        }
                    else {
                        
                        if code.kind == .guess{
                            guessButton
                        }
                        if case .master = code.kind{
                            restartButton
                        }
                            
                        }
            }
            
        }
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

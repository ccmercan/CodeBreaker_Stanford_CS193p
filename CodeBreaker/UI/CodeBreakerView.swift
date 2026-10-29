//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by cag on 9/17/26.
//

import SwiftUI

struct CodeBreakerView: View {
    
    // MARK: Data In
    @Environment(\.scenePhase) var scenePhase
    
    // MARK: Data Shared with Me
    let game: CodeBreaker

    
    // MARK: Data Owned by Me
    
    @State private var selection: Int = 0 // selection of the guess
    @State private var restarting = false
    @State private var hideRecentMarkers = false
    
    
    // MARK: - Body
    
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
            ScrollView{
                if !game.isOver || restarting{
                    CodeView(code: game.guess,selection: $selection){
                        guessButton
                    }
                    
                    .animation(nil, value:game.attempts.count)
                    .opacity(restarting && game.isOver ? 0 : 1)
                }
                   
                ForEach(game.attempts, id: \.pegs){attempt in
                    CodeView(
                        code:attempt){
                            let showMarkers = !hideRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                            if showMarkers, let matches = attempt.matches{
                                MatchMarkers(matches: matches)
                            }
                        }
                        .transition(.attempt(game.isOver))
                }
            }
            if !game.isOver{
                PegChooser(choices: game.pegChoices) { peg in
                    game.setGuessPeg(peg, at: selection)
                    selection = (selection + 1) % game.masterCode.pegs.count
                        
                }
                .transition(.pegChooser)
                .frame(maxHeight: 100)
            }
            
           
        }
        .onAppear{
            game.startTimer()
        }
        .onDisappear{
            game.pauseTimer()
        }
        .onChange(of: game) {oldGame, newGame in
            oldGame.pauseTimer()
            newGame.startTimer()
        }
        .onChange(of: scenePhase){
            switch scenePhase{
            case .active: game.startTimer()
            case .background: game.pauseTimer()
            default: break
            }
        }
        .toolbar{
            ToolbarItem(placement: .primaryAction){
                restartButton
            }
            
                        ToolbarItem{
                            ElapsedTime(startTime: game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
                //.font(.system(size: GuessButton.maximumFontSize))
                //.minimumScaleFactor(GuessButton.scaleFactor)
                    .monospaced()
                .lineLimit(1)}
        }
        .padding()
    }
    
    
    
    var guessButton: some View{
        Button("Guess", action: guess)
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    func guess() {
        withAnimation(.guess){
            game.attemptGuess()
            selection = 0
            hideRecentMarkers = true
        }
    completion : {
        withAnimation(.guess) {
            hideRecentMarkers = false
            }
        }
    }
        
    var restartButton: some View{
            Button("Restart",systemImage: "arrow.circlepath"){
                withAnimation(.guess) {
                    restarting = true
                }
                completion : {
                    withAnimation(.guess){
                        selection = 0
                        game.randomGame()
                        restarting = false
                        
                    }
                }
            }
            .font(.system(size: 30))
            //.minimumScaleFactor(0.1)
        
    }
    
    struct GuessButton{
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
    }
    
}

extension Animation {
    static let guess = Animation.bouncy
}

extension AnyTransition{
    static let pegChooser = AnyTransition.offset(x:0, y:200)
    static func attempt(_ isOver:Bool) -> AnyTransition {
        AnyTransition.asymmetric(
            insertion: isOver ? .opacity : .move(edge: .top),
            removal: .move(edge: .trailing))
    }
}

extension Color {
    static func gray(_ brightness:CGFloat) -> Color{
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    @Previewable @State var game = CodeBreaker(name:"Preview", numberOfPegs: 3, pegChoices: ["red","blue","green"])
    NavigationStack{
        CodeBreakerView(game: game)

    }
}

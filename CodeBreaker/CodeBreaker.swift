//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by cag on 9/24/26.
//

import Foundation

typealias Peg = String

struct CodeBreaker { 
    
    var masterCode: Code
    var guess: Code 
    var attempts: [Code] = []
    let pegChoices:[Peg]
    
    init(numberOfPegs: Int, pegChoices: [Peg] = ["brown","yellow","orange","black", "pink", "purple"]){
        
        self.pegChoices = pegChoices
        self.masterCode  = Code(kind: .master, numberOfPegs:numberOfPegs)
        self.guess = Code(kind:.guess, numberOfPegs:numberOfPegs)
        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }
    
    static func randomGame() -> CodeBreaker {
        let useEmojis = Bool.random()

        let choices: [Peg]
        if useEmojis {
            choices = ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐"]
        } else {
            choices = ["brown", "yellow", "orange", "black", "pink", "purple"]
        }

        return CodeBreaker(
            numberOfPegs: Int.random(in: 3...6),
            pegChoices: choices
        )
    }
    
    mutating func attemptGuess() {
        var attempt = guess

        let alreadyTried = attempts.contains { savedAttempt in
            savedAttempt.pegs == attempt.pegs
        }
        let hasNoPegsChosen = attempt.pegs.allSatisfy { peg in
            peg == Code.missing
        }

        if alreadyTried || hasNoPegsChosen {
            return
        }

        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()
    }
    
    
    
    mutating func changeGuessPeg(at index:Int){
        let existingPeg = guess.pegs[index]
        if let indexOfExistingInPegChoices = pegChoices.firstIndex(of: existingPeg){
            let newPeg = pegChoices[(indexOfExistingInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
    
}



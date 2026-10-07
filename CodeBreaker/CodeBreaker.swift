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

struct Code {
    var kind: Kind
    var pegs : [Peg] //=
    
    init(kind:Kind,numberOfPegs:Int){
        self.kind = kind
        self.pegs = Array(repeating: Code.missing, count: numberOfPegs)
    }
    static let missing: Peg = "clear"
    
    enum Kind:Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    var matches: [Match]{
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }
    
    mutating func randomize(from pegChoices:[Peg]) {
        for index in pegs.indices{
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results:[Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        for index in pegs.indices.reversed(){
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index]{
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        
        for index in pegs.indices{
            if results[index] != .exact{
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]){
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }
}

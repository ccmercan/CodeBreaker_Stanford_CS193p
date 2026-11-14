//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by cag on 9/24/26.
//

import Foundation
import SwiftData

typealias Peg = String

@Model class CodeBreaker {
    
        
    var name: String
    @Relationship(deleteRule: .cascade) var masterCode: Code
    @Relationship(deleteRule: .cascade) var guess: Code
    @Relationship(deleteRule: .cascade) var _attempts: [Code] = []
    var pegChoices:[Peg]
    @Transient var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var lastAttemptDate:Date = Date.now
    
    
    
    /// Provides attempts sorted from newest to oldest by timestamp.
    /// The underlying SwiftData relationship does not guarantee ordering.
    /// Changes are written back to the stored `_attempts` relationship.
    var attempts: [Code] {
        get { _attempts.sorted { $0.timestamp > $1.timestamp} }
        set { _attempts = newValue}
    }
    
    init(name:String = "Code Breaker",numberOfPegs: Int, pegChoices: [Peg] = ["brown","yellow","orange","black", "pink", "purple"]){
        self.name = name
        self.pegChoices = pegChoices
        self.masterCode  = Code(kind: .master(isHidden: true), numberOfPegs:numberOfPegs)
        self.guess = Code(kind:.guess, numberOfPegs:numberOfPegs)
        masterCode.randomize(from: pegChoices)
        
        print(masterCode.pegs)
    }
    
     func randomGame(){
//        let useEmojis = Bool.random()
//
//        let choices: [Peg]
//        if useEmojis {
//            choices = ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐"]
//        } else {
//            choices = ["brown", "yellow", "orange", "black", "pink", "purple"]
//        }
        
        masterCode.kind = .master(isHidden: true)
        masterCode.randomize(from: pegChoices)
        guess.reset()

        attempts.removeAll()
        startTime = .now
        endTime = nil
        elapsedTime = 0
        print(masterCode.pegs)
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
            elapsedTime += 0.00001
        }
    }
    
    func pauseTimer(){
        if let startTime{
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        
        startTime = nil
    }
    
    
    var isOver: Bool{
        attempts.first?.pegs == masterCode.pegs
    }
    
     func attemptGuess() {
        
        let attemptt = guess

        let alreadyTried = attempts.contains { savedAttempt in
            savedAttempt.pegs == attemptt.pegs
        }
        let hasNoPegsChosen = attemptt.pegs.allSatisfy { peg in
            peg == Code.missing
        }

        if alreadyTried || hasNoPegsChosen {
            return
        }
        let attempt = Code(kind:.attempt(guess.match(against: masterCode)), numberOfPegs: guess.pegs.count)
         attempt.pegs = guess.pegs
        
        attempts.insert(attempt, at: 0)
         lastAttemptDate = .now
        guess.reset()
        if isOver{
            masterCode.kind = .master(isHidden: false)
            endTime = .now
            pauseTimer()
        }
    }
    
     func setGuessPeg(_ peg: Peg, at index: Int){
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
     func changeGuessPeg(at index:Int){
        let existingPeg = guess.pegs[index]
        if let indexOfExistingInPegChoices = pegChoices.firstIndex(of: existingPeg){
            let newPeg = pegChoices[(indexOfExistingInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
    
}

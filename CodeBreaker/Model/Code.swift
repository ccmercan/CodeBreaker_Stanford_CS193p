//
//  Code.swift
//  CodeBreaker
//
//  Created by cag on 10/10/26.
//


import Foundation

struct Code {
    var kind: Kind
    var pegs : [Peg] //=
    
    init(kind:Kind,numberOfPegs:Int){
        self.kind = kind
        self.pegs = Array(repeating: Code.missing, count: numberOfPegs)
    }
    static let missing: Peg = "clear"
    
    enum Kind:Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }

    
    var matches: [Match]?{
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
        
    mutating func reset(){
        pegs = Array(repeating: Code.missing, count: pegs.count)
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

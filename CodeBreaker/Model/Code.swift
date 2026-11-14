//
//  Code.swift
//  CodeBreaker
//
//  Created by cag on 10/10/26.
//


import Foundation
import SwiftData

@Model class Code {
    var _kind: String = Kind.unknown.description
    var pegs: [Peg]
    var timestamp = Date.now
        
    var kind: Kind {
            get { return Kind(_kind) }
            set { _kind = newValue.description }
        }
    
    init(kind:Kind,numberOfPegs:Int){
        
        self.pegs = Array(repeating: Code.missing, count: numberOfPegs)
        self.kind = kind
    }
    static let missing: Peg = "clear"
    
//    enum Kind:Equatable {
//        case master(isHidden: Bool)
//        case guess
//        case attempt([Match])
//        case unknown
//    }
//    
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
    
        
    func reset(){
        pegs = Array(repeating: Code.missing, count: pegs.count)
    }
    
    func randomize(from pegChoices:[Peg]) {
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
enum Match: String {
    case nomatch
    case exact
    case inexact
}

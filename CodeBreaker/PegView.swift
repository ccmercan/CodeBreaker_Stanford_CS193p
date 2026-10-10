//
//  PegView.swift
//  CodeBreaker
//
//  Created by cag on 10/10/26.
//

import SwiftUI

struct PegView: View {
    let peg: Peg
    
    private let supportedColors: [String: Color] = [
        "brown": .brown,
        "yellow": .yellow,
        "orange": .orange,
        "black": .black,
        "pink": .pink,
        "purple": .purple
    ]
    
    let pegShape = RoundedRectangle(cornerRadius: 10)
    
    var body: some View {
        HStack {
            if peg == Code.missing {
                pegShape
                    .strokeBorder(Color.gray)
            } else if let color = supportedColors[peg] {
                pegShape
                    .fill(color)
            } else {
                pegShape
                        .fill(Color.clear)
                        .overlay {
                            Text(peg)
                                .font(.system(size: 120))
                                .minimumScaleFactor(9.0 / 120.0)
                                .lineLimit(1)
                        }
                }
        }
    }
}


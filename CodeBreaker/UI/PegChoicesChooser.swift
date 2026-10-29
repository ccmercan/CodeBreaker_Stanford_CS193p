//
//  PegChoicesChooser.swift
//  CodeBreaker
//
//  Created by cag on 10/25/26.
//

import SwiftUI

struct PegChoicesChooser: View {
    // MARK: Data Shared with Me
    @Binding var pegChoices : [Peg]
    
    private let colorNames = [
        "brown", "yellow", "orange", "black", "pink", "purple",
        "red", "blue", "green", "indigo", "cyan"
    ]

    
    var body: some View {
        List{
            ForEach(pegChoices.indices, id: \.self) { index in
                if colorNames.contains(pegChoices[index]) {
                    Picker(
                        "Peg Choice \(index + 1)",
                        selection: $pegChoices[index]
                    ) {
                        ForEach(colorNames, id: \.self) { name in
                            Text(name.capitalized)
                                .tag(name)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            Button("Add Peg", systemImage: "plus.circle"){
                pegChoices.append("green")
            }
        }
    }
}

#Preview {
    @Previewable @State var pegChoices: [Peg] = ["green","orange"]
    PegChoicesChooser(pegChoices: $pegChoices)
        .onChange(of: pegChoices) {
            print("pegChoices =  \(pegChoices)")
        }
}

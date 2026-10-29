import SwiftUI

struct GameEditor: View {
    
    // MARK: Data (Function) IN
    @Environment(\.dismiss) var dismiss
    
    // MARK: Data Shared with Me
    @Bindable var game: CodeBreaker

    // MARK: Action Function
    let onChoose: () -> Void
    
    // MARK: Data Owned by Me
    @State private var showInvalidGameAlert = false
    
    var body: some View {
        
        NavigationStack{
            Form {
                Section("Name"){
                    TextField("Name", text: $game.name)
                }

                Section("Peg Choices") {
                    PegChoicesChooser(pegChoices: $game.pegChoices)
                }
            }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction){
                        Button("Cancel"){
                        dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction){
                        Button("Done"){
                            done()
                        }
                        .alert("Invalid Game", isPresented: $showInvalidGameAlert){
                            Button("OK"){
                                showInvalidGameAlert = false
                            }
                        } message: {
                            Text("A game must have a name and more than one unique peg.")
                        }
                    }
                }
        }

    }
    func done() {
        if game.isValid{
            onChoose()
            dismiss()
        }
        else {
            showInvalidGameAlert = true
        }
    }
}

extension CodeBreaker{
    var isValid: Bool {
        !name.isEmpty && Set(pegChoices).count >= 2
    }
}

#Preview {
    @Previewable @State var game = CodeBreaker(
        name: "Preview",
        numberOfPegs: 3,
        pegChoices: ["orange", "purple", "black"]
    )

    GameEditor(game: game){
            print("Game name changed to \(game.name)")
            print("Game pegs changed to \(game.pegChoices)")
        }
}

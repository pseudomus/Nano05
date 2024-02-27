import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationStack{
            VStack{
                NavigationLink {
                    GameplayView()
                } label: {
                    NavigationButton(label: "SinglePlayer", color: .blue)
                }
                NavigationLink {
                    GameplayView()
                } label: {
                    NavigationButton(label: "Multiplayer", color: .blue)
                }
            }
        }
    }
}

#Preview {
    MenuView()
}

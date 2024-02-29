import SwiftUI

enum Screens: Hashable {
    case menu
    case gameplay
    case multiplayer
    case end
}


struct MenuView: View {
    
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        NavigationStack(path: $navigationModel.screens){
            VStack{
                Button {
                    navigationModel.push(.gameplay)
                } label: {
                    NavigationButton(label: "SinglePlayer", color: .blue)
                }
                .navigationBarBackButtonHidden()
                
                Button {
                    navigationModel.push(.multiplayer)
                } label: {
                    NavigationButton(label: "Multiplayer", color: .blue)
                }
                .navigationBarBackButtonHidden()
            }                .navigationDestination(for: Screens.self) { screen in
                switch screen {
                case .menu:
                    MenuView()
                case .gameplay:
                    GameplayView()
                case .multiplayer:
                    MultiplayerGameView()
                case .end:
                    EndView()
                }
            }
        }
    }
}

#Preview {
    MenuView()
}

import SwiftUI

enum Screens: Hashable {
    case menu
    case gameplay
    case lobby
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
                    NavigationButton(label: "SinglePlayer", color: .blue, systemName: "person.fill")
                }
                .navigationBarBackButtonHidden()
                
                Button {
                    navigationModel.push(.lobby)
                } label: {
                    NavigationButton(label: "Multiplayer", color: .blue, systemName: "person.2.fill")
                }
                .navigationBarBackButtonHidden()
            }                .navigationDestination(for: Screens.self) { screen in
                switch screen {
                case .menu:
                    MenuView()
                case .gameplay:
                    GameplayView()
                case .lobby:
                    MultiplayerMain()
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

//
//  MultiplayerMain.swift
//  Nano05
//
//  Created by Gustavo Horestee Santos Barros on 27/02/24.
//

import SwiftUI
import GroupActivities

struct MultiplayerMain: View {
    @EnvironmentObject private var sharePlayvm: SharePlayViewModel
    @EnvironmentObject private var navigationVm: NavigationModel
    @StateObject var groupStateObserver = GroupStateObserver()
    @State private var isActivity: Bool = false
    @State private var textTutorial: [String] = [
        "Convide seu amigo.", "Selecione o contato do amigo que você deseja convidar.", "Aperte no botão que da maneira que irá convidar o seu amigo por mensagem ou ligação.", "Após seu amigo se conectar, basta os dois apertarem o botão de Pronto e o jogo irá começar."
    ]
    @State private var columns: [GridItem] = [GridItem()]
    @State private var countdown: Int = 5
    
    var body: some View {
            VStack {
                Spacer()
                
                if sharePlayvm.allReady{
                    Text("\(countdown)")
                        .font(.system(size: 128, weight: .black))
                        .onChange(of: countdown) { _, _ in
                            decrementTimer()
                        }
                }else{
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(textTutorial.indices, id: \.self) { index in
                            let text = textTutorial[index]
                            Text("\(index+1). \(text)")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                
                Spacer()
                Button{
                    startSession()
                }label: {
                    NavigationButton(label: "Invite Friend", color: .blue, systemName: "shareplay")
                }
    
                Button {
                    sharePlayvm.isReady()
                }label: {
                    NavigationButton(label: "Ready", color: sharePlayvm.invitedFriend ? .blue : .gray.opacity(0.5), systemName: "play.fill")
                }
//                .disabled(!sharePlayvm.invitedFriend)
                
            }
            .navigationTitle("SharePlay")
            .sheet(isPresented: $isActivity){
                ActivitySharingViewController(activity: SharePlayActivityMetadata())
                
            }
            .task {
                for await session in  SharePlayActivityMetadata.sessions(){
                    sharePlayvm.configurationSession(session)
                }
            }
            .onReceive(sharePlayvm.$allReady) { value in
                print(value)
                if value{
                    decrementTimer()
                }
            }
    }
    
    private func startSession(){
        if groupStateObserver.isEligibleForGroupSession{
            sharePlayvm.startSession()
            return
        }
        isActivity = true
    }
    
    private func decrementTimer(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            if countdown == 0{
                navigationVm.push(.multiplayer)
                return
            }
            countdown -= 1
        }
    }
}

#Preview {
    MultiplayerMain()
        .environmentObject(SharePlayViewModel())
        .environmentObject(NavigationModel.shared)
        .environmentObject(GroupStateObserver())
}

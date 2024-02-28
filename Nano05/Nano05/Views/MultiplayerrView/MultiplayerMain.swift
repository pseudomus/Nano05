//
//  MultiplayerMain.swift
//  Nano05
//
//  Created by Gustavo Horestee Santos Barros on 27/02/24.
//

import SwiftUI
import GroupActivities

struct MultiplayerMain: View {
    @EnvironmentObject private var vm: SharePlayViewModel
    @StateObject var groupStateObserver = GroupStateObserver()
    @State var isActivity: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button{
                    startSession()
                }label: {
                    Label("Invite Friend", systemImage: "shareplay")
                        .font(.system(size: 22))
                }.buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .foregroundStyle(Color.black)
            }.toolbar{
                
            }
            .navigationTitle("SharePlay")
            .sheet(isPresented: $isActivity){
                ActivitySharingViewController(activity: SharePlayActivityMetadata())
                
            }
            
        }.task {
            for await session in  SharePlayActivityMetadata.sessions(){
                vm.configurationSession(session)
            }
        }
    }
    
    private func startSession(){
        if groupStateObserver.isEligibleForGroupSession{
            vm.startSession()
            return
        }
        isActivity = true
    }
}

#Preview {
    MultiplayerMain()
        .environmentObject(SharePlayViewModel())
}

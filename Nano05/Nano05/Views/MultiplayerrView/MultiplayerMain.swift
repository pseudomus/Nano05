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
                if let session = vm.groupSession{
                    Text("\(String(describing: session.state))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.green)
                }else{
                    Text("Not shared")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.red)
                }
                
            }.toolbar{
                Button{
                    if groupStateObserver.isEligibleForGroupSession{
                        vm.startSession()
                    }else{
                        isActivity = true
                    }
                }label: {
                    Label("Share", systemImage: "shareplay")
                }
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
    
}

#Preview {
    MultiplayerMain()
        .environmentObject(SharePlayViewModel())
}

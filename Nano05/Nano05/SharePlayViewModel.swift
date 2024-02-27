//
//  SharePlayViewModel.swift
//  Nano05
//
//  Created by Gustavo Horestee Santos Barros on 27/02/24.
//

import GroupActivities
import SwiftUI

//MARK: - Gerencia funcionalidades do SharePlay
@MainActor
class SharePlayViewModel: ObservableObject{
    @Published  var userData: SharePlayModelData = SharePlayModelData()
    @Published var groupSession: GroupSession<SharePlayActivityMetadata>?
    var groupSessionMesager: GroupSessionMessenger?
    var taks = Set<Task<Void, Never>>()
    
    //Change hitValue
    public func incrementValue(){
        userData.hitsCount += 1
        sendData(userData)
    }
    
    //Start Session
    public func startSession(){
        Task{
            do{
                _ = try await SharePlayActivityMetadata().activate()
            }catch{
                print("Error in init session [SharePlayViewModel.startSession] - ", error.localizedDescription)
            }
        }
    }
    
    //Send Data
    private func sendData(_ model: SharePlayModelData){
        Task{
            do{
                _ = try await groupSessionMesager?.send(model)
            }catch{
                print("Error in send model session [SharePlayViewModel.sendData] - ", error.localizedDescription)
            }
        }
    }
    
    //Configuration Session
    public func configurationSession(_ session: GroupSession<SharePlayActivityMetadata>){
        let mensager = GroupSessionMessenger(session: session)
        self.groupSessionMesager = mensager
        self.groupSession = session
        
        // Criar  groupSession.$state que reseta?
        
        taks.insert(
            Task{
                for await (response, _) in mensager.messages(of: SharePlayModelData.self){
                    handle(response)
                }
            }
        )
        
        groupSession?.join()
    }
    
    private func handle(_ model: SharePlayModelData){
        self.userData = model
    }
}


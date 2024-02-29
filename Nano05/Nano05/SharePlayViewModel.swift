//
//  SharePlayViewModel.swift
//  Nano05
//
//  Created by Gustavo Horestee Santos Barros on 27/02/24.
//

import GroupActivities
import Combine
import SwiftUI

//MARK: - Gerencia funcionalidades do SharePlay
@MainActor
class SharePlayViewModel: ObservableObject{
    @Published var opponentData: SharePlayModelData = SharePlayModelData()
    @Published var groupSession: GroupSession<SharePlayActivityMetadata>?
    @Published var invitedFriend: Bool = false
    @Published var myReady: Bool = false
    @Published var allReady: Bool = false
    var groupSessionMesager: GroupSessionMessenger?
    var subscriptions = Set<AnyCancellable>()
    var taks = Set<Task<Void, Never>>()
    
    
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
    
    //Change hitValue
    public func incrementValue(_ value: Int){
        let newUserData = SharePlayModelData(hitsCount: value)
        sendData(newUserData)
    }
    
    public func isReady(){
        self.myReady = true
        let newUserData = SharePlayModelData(isReady: myReady)
        sendData(newUserData)
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
        
        //verifica o status da session se for invalidated reseta os dados.
        groupSession?.$state
            .sink { state in
                if case .invalidated = state{
                    self.groupSession = nil
                    //chamar funcao que reseta o model data(UserData)
                }
            }.store(in: &subscriptions)
        
        groupSession?.$activeParticipants
            .sink { activeParticipants in
                if activeParticipants.count == 2{
                    self.invitedFriend = true
                }
            }
            .store(in: &subscriptions)
        
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
        self.opponentData = model
        verify()
    }
    
    private func verify(){
        //se ready do usuario == a do inimigo
        //chamar o timer -> comcar o jogo
        if myReady && opponentData.isReady{
            print("Meu valor ready e: ", myReady, "\n", "enimigo ready e:", opponentData.isReady)
            //init timer
            self.allReady = true
        }
    }
}


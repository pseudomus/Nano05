//
//  MultiplayerGameView.swift
//  Nano05
//
//  Created by Gustavo Horestee Santos Barros on 28/02/24.
//

import SwiftUI

struct MultiplayerGameView: View {
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var cameraVm: CameraModel
    @EnvironmentObject var sharePlayVm: SharePlayViewModel
    @StateObject var model = GameplayViewModel()
    
    var body: some View {
        VStack{
            ZStack {
                CameraView(image: cameraVm.frama)
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 40)
                            .foregroundStyle(.black)
                            .frame(width: 350,height: 70)
                        HStack{
                            Text("\(model.toFindObject)")
                                .font(.system(size: 20))
                                .frame(width: 270)
                            Button{
                                model.chooseObject()
                            }label: {
                                Image("ChangeButton")
                                    .resizable()
                                    .frame(width: 45,height: 45)
                                    .scaledToFit()
                            }
                        }
                    }
                    PhotoButton(action: {
                        if model.toFindObject == cameraVm.classifyImage(){
                            model.findedObject()
                        }
                    })
                    .padding(15)
                }
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 40)
                            .foregroundStyle(.black)
                            .frame(width: UIScreen.main.bounds.width, height: 120)
                            .foregroundStyle(.white)
                        VStack{
                            Text("\(model.timeRemaining.convertDurationToString())")
                                .bold()
                                .font(.system(size: 30))
                            HStack {
                                Text("You:")
                                Text("\(model.numberOfObjects)")
                                    .foregroundStyle(.green)
                                    .onChange(of: model.numberOfObjects) { _, _ in
                                        sharePlayVm.incrementValue(model.numberOfObjects)
                                    }
                                Text("|")
                                Text("rival:")
                                Text("\(sharePlayVm.opponentData.hitsCount)")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }.onReceive(timer){ time in
            if model.timeRemaining > 0 {
                model.timeRemaining -= 1
            }else {
                timer.timeout(.seconds(0.1), scheduler: DispatchQueue.main, options: nil, customError: nil)
//                navigationModel.push(.endLose)
                verifyWiner()
            }
        }
        .onReceive(model.$numberOfObjects){ objects in
            if model.numberOfObjects == 10{
                sharePlayVm.playerWiner()
                navigationModel.push(.endWin)
            }
        }
        .onReceive(sharePlayVm.$winner){ value in
            if value{
                navigationModel.push(.endLose)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            model.chooseObject()
        }
    }
    
    private func verifyWiner(){
        if model.numberOfObjects > sharePlayVm.opponentData.hitsCount || model.numberOfObjects == 10{
            navigationModel.push(.endWin)
            return
        }
        navigationModel.push(.endLose)
    }
}

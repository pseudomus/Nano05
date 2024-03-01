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
                    .popover(isPresented: $model.showPopOver,attachmentAnchor: .point(.top),arrowEdge: .bottom){
                        VStack{
                            if model.objectIsRigt{
                                Text("Correct object")
                            }else {
                                Text("Wrong object or cannot identify, try other angles")
                            }
                        }
                        .presentationCompactAdaptation(.popover)
                        .padding()
                    }
                    PhotoButton(action:{
                        if model.toFindObject == cameraVm.classifyImage(){
                            model.showPopOver = true
                            model.objectIsRigt = true
                            model.findedObject()
                        }else {
                            model.objectIsRigt = false
                            model.showPopOver = true
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
                if !model.defeatShow{
                    verifyWiner()
                    model.defeatShow = true
                }
//                navigationModel.push(.endLose)
            }
        }
        .onReceive(model.$numberOfObjects){ objects in
            if model.numberOfObjects == 10{ //MARK: - change for 10
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

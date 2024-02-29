//
//  MultiplayerGameView.swift
//  Nano05
//
//  Created by Gustavo Horestee Santos Barros on 28/02/24.
//

import SwiftUI

struct MultiplayerGameView: View {
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
                    .padding(40)
                }
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 40)
                            .foregroundStyle(.black)
                            .frame(width: UIScreen.main.bounds.width, height: 120)
                            .foregroundStyle(.white)
                        VStack{
                            HStack {
                                Text("You:")
                                Text("\(model.numberOfObjects)")
                                    .foregroundStyle(.green)
                                    .onChange(of: model.numberOfObjects) { _, _ in
                                        sharePlayVm.incrementValue(model.numberOfObjects)
                                    }
                                Text("|")
                                Text("rival:")
                                Text("\(sharePlayVm.userData.hitsCount)")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            model.chooseObject()
        }
    }
}

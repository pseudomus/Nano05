//
//  ContentView.swift
//  Nano05
//
//  Created by Luca Lacerda on 26/02/24.
//

import SwiftUI

struct GameplayView: View {
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var cameraVm: CameraModel
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
                    .popover(isPresented: $model.showPopOver, attachmentAnchor: .point(.top),arrowEdge: .bottom){
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
                        VStack{
                            Text("\(model.timeRemaining.convertDurationToString())")
                                .bold()
                                .font(.system(size: 30))
                            Text("\(model.numberOfObjects)/10")
                        }
                    }
                    Spacer()
                }
            }
        }.onReceive(timer, perform: { time in
            if model.timeRemaining > 0 {
                model.timeRemaining -= 1
            }else {
                navigationModel.push(.end)
            }
        })
        .navigationBarBackButtonHidden(true)
        .onAppear {
            model.chooseObject()
        }
    }
}

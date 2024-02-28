//
//  ContentView.swift
//  Nano05
//
//  Created by Luca Lacerda on 26/02/24.
//

import SwiftUI

struct GameplayView: View {

    @EnvironmentObject var cameraVm: CameraModel
    @StateObject var model = GameplayViewModel()
    
    var body: some View {
        VStack{
            Text("\(model.toFindObject)")
            Text("\(model.numberOfObjects)")
            ZStack {
                CameraView(image: cameraVm.frama)
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    PhotoButton(action:{
                        if model.toFindObject == cameraVm.classifyImage(){
                            model.findedObject()
                        }
                    })
                        .padding(40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            model.chooseObject()
        }
    }
}

//#Preview {
//    GameplayView()
//}

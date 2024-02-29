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
            Text("\(model.toFindObject)")
            
            HStack {
                Text("You:")
                Text("\(model.numberOfObjects)")
                    .onChange(of: model.numberOfObjects) { _, _ in
                        sharePlayVm.incrementValue(model.numberOfObjects)
                    }
                
                Spacer()
                
                Text("enemy:")
                Text("\(sharePlayVm.opponentData.hitsCount)")
            }.padding(.horizontal)
            
            
            ZStack {
                CameraView(image: cameraVm.frama)
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    PhotoButton(action: {
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


#Preview {
    MultiplayerGameView()
}

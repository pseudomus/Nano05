//
//  ContentView.swift
//  Nano05
//
//  Created by Luca Lacerda on 26/02/24.
//

import SwiftUI

struct GameplayView: View {

    @EnvironmentObject var cameraVm: CameraModel
    
    var body: some View {
        VStack{
            
            ZStack {
                CameraView(image: cameraVm.frama)
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    PhotoButton(action: cameraVm.classifyImage)
                        .padding(40)
                }
            }
        }
    }
}

#Preview {
    GameplayView()
}

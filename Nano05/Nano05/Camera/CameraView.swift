//
//  CameraView.swift
//  fruitDetector
//
//  Created by Luca Lacerda on 22/02/24.
//

import SwiftUI

struct CameraView: View {
    
    @EnvironmentObject var cameraVm: CameraModel
    
    var image:UIImage?
    
    var body: some View {
        ZStack{
            if let image = image{
               Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.black
                Text("teste")
                    .foregroundStyle(.white)
            }
            Button {
                cameraVm.classifyImage()
            } label: {
                Text("Funciona")
            }
        }
    }
}

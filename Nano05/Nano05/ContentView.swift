//
//  ContentView.swift
//  Nano05
//
//  Created by Luca Lacerda on 26/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var cameraVm = CameraModel()
    var body: some View {
        VStack {
            CameraView(image: cameraVm.frama)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}

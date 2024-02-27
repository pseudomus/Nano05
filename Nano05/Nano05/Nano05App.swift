//
//  Nano05App.swift
//  Nano05
//
//  Created by Luca Lacerda on 26/02/24.
//

import SwiftUI

@main
struct Nano05App: App {
    
    @StateObject var cameraVm = CameraModel()
    
    var body: some Scene {
        WindowGroup {
            MenuView()
                .environmentObject(cameraVm)
        }
    }
}

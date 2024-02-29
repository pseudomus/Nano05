//
//  NavigationModel.swift
//  Nano05
//
//  Created by GABRIEL Ferreira Cardoso on 28/02/24.
//

import Foundation

class NavigationModel: ObservableObject {
    
    static let shared = NavigationModel()
    
    @Published var screens: [Screens] = []
    
    private init() { }
    
    func push(_ screen: Screens) {
        screens.append(screen)
    }
    
    func updateScreens(_ screens: [Screens]) {
        self.screens = screens
    }
    
    func popToRoot() {
        screens = []
    }
    
    func pop() {
        screens.removeLast()
    }
}

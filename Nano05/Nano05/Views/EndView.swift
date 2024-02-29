//
//  EndView.swift
//  Nano05
//
//  Created by GABRIEL Ferreira Cardoso on 28/02/24.
//

import SwiftUI

struct EndView: View {
    
    @EnvironmentObject var navigationModel: NavigationModel
    
    var finalResult = false
    
    var body: some View {
        VStack {
            
            if finalResult {
                Text("You Win")
            } else {
                Text("You lose")
            }
            
            Button {
                navigationModel.popToRoot()
            } label: {
                NavigationButton(label: "Back to menu", color: .orange)
            }
        }
    }
}

#Preview {
    EndView()
}

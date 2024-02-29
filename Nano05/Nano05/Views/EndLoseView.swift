//
//  EndLossView.swift
//  Nano05
//
//  Created by GABRIEL Ferreira Cardoso on 29/02/24.
//

import SwiftUI

struct EndLoseView: View {
    
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var sharePlayVM: SharePlayViewModel
    @EnvironmentObject var gameplayVM: GameplayViewModel
    
    var finalResult = false
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("Derrota")
                .font(.title)
                .foregroundStyle(.white)
                .padding()
            
            Text("Tempo restante")
                .font(.subheadline)
                .foregroundStyle(.white)
            
            Spacer()
            
            Button {
                navigationModel.popToRoot()
            } label: {
                NavigationButton(label: "Menu", color: .white)
            }
            
            Spacer()
        }
        .foregroundStyle(.black)
    }
    
}


#Preview {
    EndLoseView()
}

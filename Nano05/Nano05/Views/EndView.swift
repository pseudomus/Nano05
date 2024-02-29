//
//  EndView.swift
//  Nano05
//
//  Created by GABRIEL Ferreira Cardoso on 28/02/24.
//

import SwiftUI

struct EndView: View {
    
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var sharePlayVM: SharePlayViewModel
    @EnvironmentObject var gameplayVM: GameplayViewModel
    
    var finalResult = false
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            if finalResult {
                Text("Vitoria")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding()
                
                Text("Tempo restante")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                
            } else {
                Text("Derrota")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding()
                
                Text("Tempo restante")
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
            
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
    EndView()
}

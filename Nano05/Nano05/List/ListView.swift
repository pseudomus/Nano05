//
//  ObjectToFindView.swift
//  Nano05
//
//  Created by GABRIEL Ferreira Cardoso on 28/02/24.
//

import SwiftUI

struct ListView: View {
    
    var isChecked = false
    
    var body: some View {
        HStack{
            
            if isChecked == true {
                Image(systemName: "checkmark.square")
            } else {
                Image(systemName: "square")
            }
            
            Text("Teste")
        }
    }
}

#Preview {
    ListView()
}

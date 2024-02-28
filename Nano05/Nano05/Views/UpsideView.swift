//
//  UpsideView.swift
//  Nano05
//
//  Created by GABRIEL Ferreira Cardoso on 28/02/24.
//

import SwiftUI

struct UpsideView: View {
    
    var isChecked = false
    var itemName = ""
    
    var body: some View {
        HStack {
            if isChecked {
                Image(systemName: "checkmark.square")
                Text("Geladeira")
                
            } else {
                Image(systemName: "square")
                Text("Geladeira")
            }
        }
    }
}

#Preview {
    UpsideView()
}

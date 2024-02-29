//
//  UpsideView.swift
//  Nano05
//
//  Created by GABRIEL Ferreira Cardoso on 28/02/24.
//

import SwiftUI

struct UpsideView: View {

    var numberOfItemsFound:Int
    
    var body: some View {
        ZStack{
            Color.black
            VStack {
                    Text("\(numberOfItemsFound)//10")
            }
        }
    }
}

#Preview {
    UpsideView(numberOfItemsFound: 2)
}

import SwiftUI

struct PhotoButton: View {

    var action:()-> Void

    var body: some View {
        VStack{
            Button{
                action()
            }label: {
                ZStack{
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: 65, height: 65)
                    Circle()
                        .stroke(Color.black,lineWidth: 2)
                        .foregroundStyle(.white)
                        .frame(width: 55,height: 55)
                }
            }
        }
    }
}

#Preview {
    PhotoButton(action: {})
}

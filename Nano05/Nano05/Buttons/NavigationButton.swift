import SwiftUI

struct NavigationButton: View {

    var label:String
    var color:Color

    var body: some View {
        VStack{
            Text(label)
                .bold()
                .foregroundStyle(.white)
                .frame(width: 144,height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 20).foregroundStyle(color))
        }
    }
}

import SwiftUI

struct NavigationButton: View {
    var label: String
    var color: Color
    var systemName: String?

    var body: some View {
        HStack{
            Image(systemName: systemName ?? "")
                .font(.system(size: 24))
                .padding(.leading)
            
            Text(label)
                .bold()
                .padding(.trailing)
                .frame(height: 60)
            
        }.background(
            RoundedRectangle(cornerRadius: 20).foregroundStyle(color)
        )
        .foregroundStyle(.white)
    }
}

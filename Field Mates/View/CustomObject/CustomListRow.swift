//
//  CustomListRow.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 02.02.2025.
//



import SwiftUI

struct CustomListRow: View {
    
    let rowLabel: String
    let rowContent: String
    let rowTintColor: Color
    let rowIcon: String
    
    @State var destinationLink: String? = nil
    @Environment(\.colorScheme) var colorScheme // Detect the current color scheme

    var body: some View {
        LabeledContent {
            Text(rowLabel)
                .fontWeight(.medium)
                .foregroundStyle(colorScheme == .dark ? .white : .secondary)
            //MARK: - Open link in safari/(any) internet
            if destinationLink != nil {
                Link("", destination: URL(string: destinationLink!)!)
            }
        } label: {
            HStack{
                ZStack{
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .foregroundStyle(
                            LinearGradient(colors: [rowTintColor, rowTintColor.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 35, height: 35)
                    Image(systemName: rowIcon)
                        .resizable()
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
                Text(rowContent)
                    .tint(Color.primary)
            }
        }
    }
}

#Preview {
    List{
        CustomListRow(rowLabel: "Test", rowContent: "App", rowTintColor: .gray, rowIcon: "gear", destinationLink: "https://www.linkedin.com/in/%C8%99tefan-miloiu-29a120266?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app")
    }
}

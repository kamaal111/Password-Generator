//
//  LogoPlaygroundColorSelector.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 26/09/2021.
//

#if DEBUG
import SwiftUI

struct LogoPlaygroundColorSelector: View {
    @Binding var selectedColor: Color

    let title: String
    let selectableColors: [Color]

    private let innerCircleSize: CGSize = .squared(20)

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            Divider()
            HStack {
                ForEach(selectableColors, id: \.self) { selectableColor in
                    Button(action: { withAnimation { selectedColor = selectableColor } }) {
                        ZStack {
                            if isSelected(selectableColor) {
                                Circle()
                                    .frame(width: innerCircleSize.width * 1.2, height: innerCircleSize.height * 1.2)
                                    .foregroundColor(.accentColor)
                            }
                            Circle()
                                .frame(width: innerCircleSize.width, height: innerCircleSize.height)
                                .foregroundColor(selectableColor)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    private func isSelected(_ color: Color) -> Bool {
        color == selectedColor
    }
}

struct LogoPlaygroundColorSelector_Previews: PreviewProvider {
    static var previews: some View {
        LogoPlaygroundColorSelector(
            selectedColor: .constant(.green),
            title: "Super color",
            selectableColors: [.red, .green])
    }
}
#endif

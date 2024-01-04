//
//  ButtonDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

// Demo
import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 230, height: 45)
            .font(DesignSystem.FontStyles.h1)
            .foregroundColor(Color(hex: "#2D2D2D"))
            .background(Color(hex: "#FFD2D2"))
            .cornerRadius(30)
    }
}

struct ButtonDemo: View {
    var body: some View {
        VStack {
            Button("Test") {
                print("Test")
            }.buttonStyle(DefaultButtonStyle())
        }
    }
}

#Preview {
    ButtonDemo()
}

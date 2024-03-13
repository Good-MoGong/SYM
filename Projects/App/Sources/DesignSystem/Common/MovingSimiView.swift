//
//  MovingSimiView.swift
//  SYM
//
//  Created by 박서연 on 2024/03/07.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct MovingSimiView: View {
    @State private var yOffset: CGFloat = 0
    var image: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("shadow")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .symWidth * 0.4, alignment: .center)
            Image(image)
                .resizable()
                .scaledToFit()
                .padding(.bottom, 35)
                .animationSimi(yOffset: yOffset)
        }
    }
}

#Preview {
    MovingSimiView(image: "SimiLogin")
}

struct SimiModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
//            .resizable()
//            .scaledToFit()
//            .padding(.horizontal, 50)
    }
}

extension View {
    func simiImageModifier() -> some View {
        modifier(SimiModifier())
    }
}

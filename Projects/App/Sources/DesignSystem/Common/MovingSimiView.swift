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
            Image(image)
                .resizable()
                .scaledToFit()
                .padding(.bottom, 50)
                .animationSimi(yOffset: yOffset)
        }
    }
}

#Preview {
    MovingSimiView(image: "SimiLogin")
}

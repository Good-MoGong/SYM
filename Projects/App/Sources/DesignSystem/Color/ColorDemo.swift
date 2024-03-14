//
//  ColorDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

import SwiftUI

struct ColorDemo: View {
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color.main)
                .frame(width: 70, height: 70)
            
            HStack {
                Rectangle()
                    .foregroundColor(Color.symBlack)
                    .frame(width: 50, height: 50)
                
                Rectangle()
                    .foregroundColor(Color.symGray1)
                    .frame(width: 50, height: 50)
                
                Rectangle()
                    .foregroundColor(Color.symGray2)
                    .frame(width: 50, height: 50)
                
                Rectangle()
                    .foregroundColor(Color.symGray3)
                    .frame(width: 50, height: 50)
                
                Rectangle()
                    .foregroundColor(Color.symGray4)
                    .frame(width: 50, height: 50)
            }
        }
    }
}

#Preview {
    ColorDemo()
}

//
//  ContentView.swift
//  SYM
//
//  Created by 박서연 on 2023/12/20.
//  Copyright © 2023 Mogong. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Image("TestImage")
        }
        .frame(height: 50)
        .scrollIndicators(.visible)
        .padding()
    }
}

#Preview {
    ContentView()
}

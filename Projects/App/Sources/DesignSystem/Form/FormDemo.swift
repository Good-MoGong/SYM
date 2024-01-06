//
//  FormDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

// Demo
import SwiftUI

struct FormDemo: View {
    var body: some View {
        VStack {
            TextView()
            DefaultTextField()
            ErrorTextField()
        }
    }
}

#Preview {
    FormDemo()
}

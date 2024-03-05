//
//  DismissKeyBoard.swift
//  SYM
//
//  Created by 민근의 mac on 3/4/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct DismissKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboard())
    }
}

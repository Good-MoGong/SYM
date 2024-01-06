//
//  ScrollTextFieldView.swift
//  SYM
//
//  Created by 전민돌 on 1/5/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct TextView: View {
    @State private var isFocused: Bool = false
    @State private var text: String = "hi"
    @State private var inputHeight: CGFloat = 40

    var body: some View {
        UITextViewRepresentable(text: $text, isFocused: $isFocused, inputHeight: $inputHeight)
        .frame(width: 334, height: 172)
        .cornerRadius(30)
        .padding(.all, 20)
    }
}

struct UITextViewRepresentable: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    @Binding var inputHeight: CGFloat

    func makeUIView(context: UIViewRepresentableContext<UITextViewRepresentable>) -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.delegate = context.coordinator
        textView.font = UIFont(name: "Avenir", size: 16) // 폰트랑 사이즈 변경 필요
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1) // Color 변경 필요
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 18, bottom: 16, right: 18)
        return textView
    }

    func makeCoordinator() -> UITextViewRepresentable.Coordinator {
        Coordinator(text: self.$text, isFocused: self.$isFocused, inputHeight: $inputHeight)
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewRepresentable>) {
        uiView.text = self.text
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var isFocused: Bool
        @Binding var inputHeight: CGFloat

        let maxHeight: CGFloat = 250

        init(text: Binding<String>, isFocused: Binding<Bool>, inputHeight: Binding<CGFloat>) {
            self._text = text
            self._isFocused = isFocused
            self._inputHeight = inputHeight
        }

        func textViewDidChange(_ textView: UITextView) {
            let spacing = textView.font!.lineHeight
            if textView.contentSize.height > inputHeight && inputHeight <= maxHeight - spacing {
                inputHeight += spacing
            } else if text == "" {
                inputHeight = 40
            }
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            self.text = textView.text ?? ""
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            self.isFocused = true
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            self.isFocused = false
        }
    }
}

#Preview {
    TextView()
}

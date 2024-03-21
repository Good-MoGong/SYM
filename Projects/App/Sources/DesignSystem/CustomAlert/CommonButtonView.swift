////
////  CommonButtonView.swift
////  SYM
////
////  Created by 박서연 on 2024/01/27.
////  Copyright © 2024 Mogong. All rights reserved.
////
//
//import SwiftUI
//
///// 팝업 뷰 생성시 겹치는 색상 뷰
//struct CommonButtonView: View {
//    let title: String
//    let desc: String
//    
//    var body: some View {
//        VStack(spacing: 12) {
//            Text(title)
//                .font(.bold(18))
//            Text(desc)
//                .font(.medium(14))
//                .lineSpacing(3)
//                .padding(.vertical, 3)
//                .multilineTextAlignment(.center)
//        }
//    }
//}
//
//#Preview {
//    CommonButtonView(title: "title", desc: "desc")
//}
//
//// 팝업 배경 모디파이어
//struct CustomPopupModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .padding(23)
//            .background(Color.white)
//            .cornerRadius(15)
//            .padding(.horizontal, 45)
//    }
//}
//
//extension View {
//    func customPopupModifier() -> some View {
//        self.modifier(CustomPopupModifier())
//    }
//}

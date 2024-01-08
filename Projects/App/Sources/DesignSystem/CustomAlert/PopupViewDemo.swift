//
//  AlertDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//
import SwiftUI

struct PopupDemo: View {
    @State private var isShowingPopup = false
    @State private var isShowingGuide = true
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Button(action: {
                    self.isShowingGuide.toggle()
                }, label: {
                    Text("가이드 라인 팝업 뷰 사용 방법")
                })
                
                Button(action: {
                    self.isShowingPopup.toggle()
                }, label: {
                    Text("일반 커스텀 팝업 뷰 사용 방법")
                })
            }
        }
        /// 가이드 라인 팝업 뷰 사용 방법
        .popup(isShowing: $isShowingGuide,
               type: .guide,
               title: "생각이 잘 떠오르지 않으세요?",
               desc: "잠시동안 눈을 감고 그때의 상황을 떠올려봐요. \n거창하지 않은 작은 생각이라도 좋아요!",
               confirmHandler: {
            print("확인")
        },
               cancelHandler: {
            print("취소 버튼")
            self.isShowingGuide.toggle()
        })
        /// 일반 커스텀 팝업 뷰 사용 방법 -> 현재 취소 확인 둘 다 똑같이 동작하는 예시입니다.
        .popup(isShowing: $isShowingPopup,
               type: .doubleButton(leftTitle: "확인", rightTitle: "취소"),
               title: "로그아웃 하시겠어요?",
               desc: "",//"• 탈퇴 후 7일간은 재가입이 불가합니다. \n• 탈퇴 시 계정의 모든 정보는 삭제되며, \n   재가입후에도 복구 되지 않습니다.",
               confirmHandler: {
            print("확인")
            self.isShowingPopup.toggle()
        },
               cancelHandler: {
            print("취소 버튼")
            self.isShowingPopup.toggle()
        })
    }
}

#Preview {
    PopupDemo()
}

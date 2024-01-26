//
//  AlertDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//
//import SwiftUI
//
//struct PopupDemo: View {
//    @State private var isShowingPopup = false
//    @State private var isShowingGuide = false
//    @State private var isShowingAlone = true
//    
//    var body: some View {
//        VStack(spacing: 10) {
//            Button(action: {
//                self.isShowingGuide.toggle()
//            }, label: {
//                Text("가이드 라인 팝업 뷰 사용 방법")
//            })
//            
//            Button(action: {
//                self.isShowingPopup.toggle()
//            }, label: {
//                Text("일반 커스텀 팝업 뷰 사용 방법")
//            })
//            
//            Button(action: {
//                self.isShowingAlone.toggle()
//            }, label: {
//                Text("로그아웃 버튼 테스트")
//            })
//        }
//        /// 가이드 라인 팝업 뷰 사용 방법
//        .popup(isShowing: $isShowingGuide,
//               type: .guide(title: "알겠어요"),
//               title: "생각이 잘 떠오르지 않으세요?",
//               boldDesc: "",
//               desc: "잠시동안 눈을 감고 그때의 상황을 떠올려봐요. 거창하지 않은 작은 생각이라도 좋아요!",
//               confirmHandler: {
//            self.isShowingGuide.toggle()
//            print("확인")
//        },
//               cancelHandler: {
//            print("취소 버튼")
//            self.isShowingGuide.toggle()
//        })
//        
//        
//        /// 일반 커스텀 팝업 뷰 사용 방법 -> 현재 취소 확인 둘 다 똑같이 동작하는 예시입니다.
//        .popup(isShowing: $isShowingPopup,
//               type: .doubleButton(leftTitle: "아니", rightTitle: "아주 좋았어!"),
//               title: "로그아웃 하시겠어요?",
//               boldDesc: "탈퇴 전 유의 사항",
//               desc: "• 탈퇴 후 7일간은 재가입이 불가합니다. \n• 탈퇴 시 계정의 모든 정보는 삭제되며, \n   재가입후에도 복구 되지 않습니다.",
//               confirmHandler: {
//            print("아니")
//            self.isShowingPopup.toggle()
//        },
//               cancelHandler: {
//            print("좋았어 버튼")
//            self.isShowingPopup.toggle()
//        })
//        
//        /// 로그아웃 버튼
//        .popup(isShowing: $isShowingAlone,
//               type: .doubleButton(leftTitle: "아니", rightTitle: "아주 좋았어"),
//               title: "기록이 도움이 됐나요?",
//               boldDesc: "",
//               desc: "") {
//            self.isShowingAlone.toggle()
//        } cancelHandler: {
//            self.isShowingAlone.toggle()
//        }
//    }
//}
//
//#Preview {
//    PopupDemo()
//}

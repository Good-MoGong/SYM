////
////  AlertDemo.swift
////  SYM
////
////  Created by 박서연 on 2024/01/04.
////  Copyright © 2023 Mogong. All rights reserved.
////
//import SwiftUI
//struct PopupDemo: View {
//    @State private var isShowingPopup = false
//    @State private var isShowingGuide = true
//    @State private var isShowingAlone = false
//    
//    var body: some View {
//        ZStack {
//            Color.red
//            VStack(spacing: 10) {
//                Button(action: {
//                    self.isShowingGuide.toggle()
//                }, label: {
//                    Text("가이드 라인 팝업 뷰 사용 방법")
//                })
//                
//                Button(action: {
//                    self.isShowingPopup.toggle()
//                }, label: {
//                    Text("탈퇴 버튼")
//                })
//                
//                Button(action: {
//                    self.isShowingAlone.toggle()
//                }, label: {
//                    Text("로그아웃 버튼")
//                })
//            }
//        }
//        /// 가이드 라인 팝업 뷰 사용 방법
//        .popup(isShowing: $isShowingGuide,
//               type: .guide(title: "닫기"),
//               title: "[사건] 쓰기 꿀팁!",
//               desc: "언제, 어디서, 누가 관련되었는지 기록하며 \n사건을 요약하는 제목을 붙여보세요!\n고민하지 말고 생각나는대로 적어봐요:)",
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
//        
//        /// 일반 커스텀 팝업 뷰 사용 방법 -> 현재 취소 확인 둘 다 똑같이 동작하는 예시입니다.
//        .popup(isShowing: $isShowingPopup,
//               type: .doubleButton(leftTitle: "그만두기", rightTitle: "탈퇴하기"),
//               title: "탈퇴 하시겠어요?",
//               desc: "사용하신 계정 정보는 회원 탈퇴 후\n모두 삭제되며, 복구가 불가합니다.",
//               confirmHandler: {
//            print("아니")
//            self.isShowingPopup.toggle()
//        },
//               cancelHandler: {
//            print("좋았어 버튼")
//            self.isShowingPopup.toggle()
//        })
//        
////        /// 로그아웃 버튼
//        .popup(isShowing: $isShowingAlone,
//               type: .doubleButton(leftTitle: "그만두기", rightTitle: "로그아웃"),
//               title: "정말 로그아웃 하시겠어요?",
//               desc: "로그아웃 후에는 서비스 이용이 불가해요.") {
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

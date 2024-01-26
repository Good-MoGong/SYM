//
//  PopupViewModifier.swift
//  SYM
//
//  Created by 박서연 on 2024/01/05.
//  Copyright © 2024 Mogong. All rights reserved.
//
import SwiftUI

public enum PopupType {
    /// 버튼이 2개인 팝뷰, 왼쪽메인 오른쪽 그레이5
    case doubleButton(leftTitle: String, rightTitle: String)
    /// 가이드라인 팝뷰 (버튼1개)
    case guide(title: String)
    /// 버튼이 2개인 팝뷰, 왼쪽 그레이5 오른쪽메인
    case switchColorDoubleBtn(leftTitle: String, rightTitle: String)
}

struct PopupView: ViewModifier {
    @Binding var isShowing: Bool
    /// 팝업 타입
    let type: PopupType
    /// 팝업뷰 제목
    @State var title: String
    /// 팝업뷰 소제목
    @State var boldDesc: String
    /// 팝업뷰 내용
    @State var desc: String
    /// 팝업뷰 확인 버튼 함수
    let confirmHandler: () -> Void
    /// 팝업뷰 취소 버튼 함수
    let cancelHandler: () -> Void
    
    init(isShowing: Binding<Bool>,
         type: PopupType,
         title: String,
         boldDesc: String,
         desc: String,
         confirmHandler: @escaping () -> Void,
         cancelHandler: @escaping () -> Void) {
        self._isShowing = isShowing
        self.type = type
        self.title = title
        self.boldDesc = boldDesc
        self.desc = desc
        self.confirmHandler = confirmHandler
        self.cancelHandler = cancelHandler
    }
    
    public func body(content: Content) -> some View {
        if isShowing {
            switch type {
            case .doubleButton(_, _):
                ZStack {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                    VStack {
                        CommonDoubleBtnView(title: $title, boldDesc: $boldDesc, desc: $desc)
                        bottomView
                    }
                    .customPopupModifier()
                }
            case .guide:
                ZStack {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                    VStack(alignment: .center) {
                        Text(title)
                            .font(PretendardFont.h5Bold)
                        Spacer().frame(height: 15)
                        Text(desc)
                            .font(PretendardFont.smallMedium)
                            .lineSpacing(1.5)
                            .multilineTextAlignment(.center)
                        Spacer().frame(height: 32)
                        bottomView
                        
                    }
                    .customPopupModifier()
//                    .padding(.horizontal, 20)
//                    .frame(maxWidth: .infinity)
//                    .padding(.top, 25)
//                    .padding(.bottom, 25)
//                    .background(Color.white)
//                    .cornerRadius(15)
//                    .padding(.horizontal, 60)
                }
            case .switchColorDoubleBtn(_, _):
                ZStack {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                    VStack {
                        CommonDoubleBtnView(title: $title, boldDesc: $boldDesc, desc: $desc)
                        bottomView
                    }
                    .customPopupModifier()
                }
            }
        } else {
            content
        }
    }
    
    @ViewBuilder private var bottomView: some View {
        switch type {
        case .doubleButton(let leftTitle, let rightTitle):
            multiButtonView(leftTitle: leftTitle, rightTitle: rightTitle)
        case .guide(let title):
            guideView(title: title)
        case .switchColorDoubleBtn(let leftTitle, let rightTitle):
            switchColorView(leftTitle: leftTitle, rightTitle: rightTitle)
        }
    }
    
    func multiButtonView(leftTitle: String, rightTitle: String) -> some View {
        HStack(spacing: 20) {
            Text(leftTitle)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .background(Color.main)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onTapGesture {
                    confirmHandler()
                }
            
            Text(rightTitle)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.symGray5)
                .background(Color.symGray1)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onTapGesture {
                    cancelHandler()
                }
        }
        .font(PretendardFont.h4Bold)
        .padding(.horizontal, 10)
    }
    
    func guideView(title: String) -> some View {
        VStack {
            Text(title)
                .padding(.vertical, 11)
                .frame(maxWidth: .infinity)
                .background(Color.bright)
                .font(PretendardFont.bodyBold)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .onTapGesture {
                    cancelHandler()
                }
        }
    }
    
    func switchColorView(leftTitle: String, rightTitle: String) -> some View {
        HStack(spacing: 20) {
            Text(leftTitle)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.symGray5)
                .background(Color.symGray1)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onTapGesture {
                    confirmHandler()
                }
            
            Text(rightTitle)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .background(Color.main)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onTapGesture {
                    cancelHandler()
                }
        }
        .font(PretendardFont.h4Bold)
        .padding(.horizontal, 10)
    }
}

public extension View {
    func popup(isShowing: Binding<Bool>,
               type: PopupType,
               title: String,
               boldDesc: String,
               desc: String,
               confirmHandler: @escaping () -> Void,
               cancelHandler: @escaping () -> Void)
    -> some View {
        self.modifier(PopupView(isShowing: isShowing,
                                type: type,
                                title: title,
                                boldDesc: boldDesc,
                                desc: desc,
                                confirmHandler: confirmHandler,
                                cancelHandler: cancelHandler))
    }
}

struct PopupDemo: View {
    @State private var isShowingPopup = true
    @State private var isShowingGuide = false
    @State private var isShowingAlone = false
    @State private var isShowingSwitch = false
    
    var body: some View {
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
            
            Button(action: {
                self.isShowingAlone.toggle()
            }, label: {
                Text("로그아웃 버튼 테스트")
            })
            
            Button(action: {
                self.isShowingSwitch.toggle()
            }, label: {
                Text("Switch 버튼 테스트")
            })
        }
        /// 가이드 라인 팝업 뷰 사용 방법
        .popup(isShowing: $isShowingGuide,
               type: .guide(title: "알겠어요"),
               title: "생각이 잘 떠오르지 않으세요?",
               boldDesc: "",
               desc: "잠시동안 눈을 감고 그때의 상황을 떠올려봐요. 거창하지 않은 작은 생각이라도 좋아요!",
               confirmHandler: {
            self.isShowingGuide.toggle()
            print("확인")
        },
               cancelHandler: {
            print("취소 버튼")
            self.isShowingGuide.toggle()
        })
        
        
        /// 일반 커스텀 팝업 뷰 사용 방법 -> 현재 취소 확인 둘 다 똑같이 동작하는 예시입니다.
        .popup(isShowing: $isShowingPopup,
               type: .doubleButton(leftTitle: "확인", rightTitle: "취소"),
               title: "탈퇴 하시겠어요?",
               boldDesc: "탈퇴 전 유의 사항",
               desc: "• 탈퇴 후 7일간은 재가입이 불가합니다. \n• 탈퇴 시 계정의 모든 정보는 삭제되며, \n   재가입후에도 복구 되지 않습니다.",
               confirmHandler: {
            print("아니")
            self.isShowingPopup.toggle()
        },
               cancelHandler: {
            print("좋았어 버튼")
            self.isShowingPopup.toggle()
        })
        
        /// 로그아웃 버튼
        .popup(isShowing: $isShowingAlone,
               type: .doubleButton(leftTitle: "확인", rightTitle: "취소"),
               title: "기록이 도움이 됐나요?",
               boldDesc: "",
               desc: "") {
            self.isShowingAlone.toggle()
        } cancelHandler: {
            self.isShowingAlone.toggle()
        }
        
        /// 로그아웃 버튼
        .popup(isShowing: $isShowingSwitch,
               type: .switchColorDoubleBtn(leftTitle: "아니", rightTitle: "아주 좋았어!"),
               title: "기록이 도움이 됐나요?",
               boldDesc: "",
               desc: "") {
            self.isShowingSwitch.toggle()
        } cancelHandler: {
            self.isShowingSwitch.toggle()
        }
    }
}

#Preview {
    PopupDemo()
}

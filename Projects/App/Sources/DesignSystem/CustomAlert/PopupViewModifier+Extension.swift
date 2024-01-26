//
//  PopupViewModifier.swift
//  SYM
//
//  Created by 박서연 on 2024/01/05.
//  Copyright © 2024 Mogong. All rights reserved.
//
import SwiftUI

public enum PopupType {
    case doubleButton(leftTitle: String, rightTitle: String)
    case guide(title: String)
}

struct PopupView: ViewModifier {
    @Binding var isShowing: Bool
    /// 팝업 타입
    let type: PopupType
    /// 팝업뷰 제목
    let title: String
    /// 팝업뷰 소제목
    let boldDesc: String
    /// 팝업뷰 내용
    let desc: String
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
                        Spacer().frame(height: 12)
                        Text(title)
                            .font(PretendardFont.h3Bold)
                        
                        if !boldDesc.isEmpty {
                            Spacer().frame(height: 10)
                            Text(boldDesc)
                                .font(PretendardFont.smallMedium)
                                .foregroundColor(Color.errorRed)
                            Spacer().frame(height: 10)
                        }
                        
                        if !desc.isEmpty {
                            Text(desc)
                                .font(.custom(PretendardFont.medium, size: 10))
                                .lineSpacing(2)
                                .multilineTextAlignment(.leading)
                         
                        }
                        Spacer().frame(height: 40)
                        bottomView
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 25)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 40)
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
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 25)
                    .padding(.bottom, 25)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 60)
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
        }
    }
    
    func multiButtonView(leftTitle: String, rightTitle: String) -> some View {
        HStack(spacing: 20) {
            Text(leftTitle)
                .padding(.vertical, 19)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.2)
                .foregroundColor(Color.symGray5)
                .background(Color.symGray1)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onTapGesture {
                    confirmHandler()
                }
            
            Text(rightTitle)
                .padding(.vertical, 19)
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

import SwiftUI

struct PopupDemo: View {
    @State private var isShowingPopup = false
    @State private var isShowingGuide = false
    @State private var isShowingAlone = true
    
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
               type: .doubleButton(leftTitle: "아니", rightTitle: "아주 좋았어!"),
               title: "로그아웃 하시겠어요?",
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
               type: .doubleButton(leftTitle: "아니", rightTitle: "아주 좋았어!"),
               title: "기록이 도움이 됐나요?",
               boldDesc: "",
               desc: "") {
            self.isShowingAlone.toggle()
        } cancelHandler: {
            self.isShowingAlone.toggle()
        }
    }
}

#Preview {
    PopupDemo()
}

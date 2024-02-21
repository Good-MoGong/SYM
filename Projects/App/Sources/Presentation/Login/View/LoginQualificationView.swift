//
//  LoginQualificationView.swift
//  SYM
//
//  Created by 박서연 on 2024/02/21.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

//struct LoginQualificationView: View {
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            Color.black
//                .opacity(0.3)
//                .ignoresSafeArea()
//            VStack(alignment: .leading) {
//                Text("약관에 동의해주세요")
//                    .font(PretendardFont.h4Bold)
//                    .foregroundColor(.symGray6)
//                Spacer().frame(height: 20)
//                VStack(spacing: 14) {
//                    Rectangle()
//                        .fill(Color.symGray3)
//                        .frame(height: 1)
//                    HStack(spacing: 10) {
//                        Image("checkGray")
//                        Spacer().frame(width: 10)
//                        Text("개인정보 처리방침 동의 (필수)")
//                            .font(PretendardFont.bodyMedium)
//                            .foregroundColor(.symGray6)
//                        Spacer()
//                        Image("chevronRight")
//                    }
//                    
//                    HStack(spacing: 10) {
//                        Image("checkGray")
//                        Spacer().frame(width: 10)
//                        Text("서비스 이용 약관 동의 (필수)")
//                            .font(PretendardFont.bodyMedium)
//                            .foregroundColor(.symGray6)
//                        Spacer()
//                        Image("chevronRight")
//                    }
//                }
//                Spacer().frame(height: 30)
//                
//                Button {
//                    
//                } label: {
//                    Text("완료")
//                }
//                .buttonStyle(MainButtonStyle.init(isButtonEnabled: true))
//                
//    //            .buttonStyle(MainButtonStyle(isButtonEnabled: 1 <= nickname.count && nickname.count < 6))
//            }
//            .padding(23)
//            .background(.white)
//        }
//    }
//}

struct LoginPopupView: ViewModifier {
    @Binding var isShowing: Bool

    init(isShowing: Binding<Bool>) {
        self._isShowing = isShowing
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay {
                ZStack(alignment: .bottom) {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                    VStack {
                        VStack(alignment: .leading) {
                            Spacer().frame(height: 40)
                            Text("약관에 동의해주세요")
                                .font(PretendardFont.h3Bold)
                                .foregroundColor(.symGray6)
                            Spacer().frame(height: 20)
                            VStack(spacing: 14) {
                                Rectangle()
                                    .fill(Color.symGray3)
                                    .frame(height: 1)
                                HStack(spacing: 10) {
                                    Image("checkGray")
                                    Spacer().frame(width: 10)
                                    Text("개인정보 처리방침 동의 (필수)")
                                        .font(PretendardFont.h4Medium)
                                        .foregroundColor(.symGray6)
                                    Spacer()
                                    Image("chevronRight")
                                }
                                
                                HStack(spacing: 10) {
                                    Image("checkGray")
                                    Spacer().frame(width: 10)
                                    Text("서비스 이용 약관 동의 (필수)")
                                        .font(PretendardFont.h4Medium)
                                        .foregroundColor(.symGray6)
                                    Spacer()
                                    Image("chevronRight")
                                }
                            }
                            Spacer().frame(height: 30)
                            
                            Button {
                                
                            } label: {
                                Text("완료")
                            }
                            .buttonStyle(MainButtonStyle.init(isButtonEnabled: true))
                            Spacer().frame(height: 30)
                        }
                        .padding(.horizontal, 24)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .opacity(isShowing ? 1 : 0)
                    .animation(.easeInOut, value: isShowing)
                }
            }
    }
}

public extension View {
    func loginPopUp(isShowing: Binding<Bool>)
    -> some View {
        self.modifier(LoginPopupView(isShowing: isShowing))
    }
}
    
//public extension View {
//    func loginPopUp(isShowing: Binding<Bool>,
//               title: String,
//               boldDesc: String,
//               desc: String,
//               confirmHandler: @escaping () -> Void,
//               cancelHandler: @escaping () -> Void)
//    -> some View {
//        self.modifier(LoginPopupView(isShowing: isShowing,
//                                title: title,
//                                boldDesc: boldDesc,
//                                desc: desc,
//                                confirmHandler: confirmHandler,
//                                cancelHandler: cancelHandler))
//    }
//}

struct LoginQualificationView: View {
    @State private var isShowingGuide = true
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            VStack(spacing: 10) {
                Button(action: {
                    self.isShowingGuide.toggle()
                }, label: {
                    Text("가이드 라인 팝업 뷰 사용 방법")
                })
            }
        }
        /// 가이드 라인 팝업 뷰 사용 방법
        .loginPopUp(isShowing: $isShowingGuide)
    }
}

#Preview {
    LoginQualificationView()
}

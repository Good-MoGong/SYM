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
                        Text(title)
                            .font(PretendardFont.h5Bold)
                        Spacer().frame(height: 12)
                        
                        if !boldDesc.isEmpty {
                            Text(boldDesc)
                                .font(PretendardFont.smallMedium)
                                .foregroundColor(Color.symRed)
                            Spacer().frame(height: 4)
                        }
                        
                        if !desc.isEmpty {
                            Text(desc)
                                .font(.custom(PretendardFont.medium, size: 10))
                                .lineSpacing(2)
                                .multilineTextAlignment(.leading)
                         
                        }
                        Spacer().frame(height: 20)
                        bottomView
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 25)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 60)
                }
            case .guide:
                ZStack {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                    VStack(alignment: .center) {
                        Text(title)
                            .font(PretendardFont.h4Bold)
                        Spacer().frame(height: 15)
                        Text(desc)
                            .font(PretendardFont.bodyMedium)
                            .lineSpacing(1.5)
                            .multilineTextAlignment(.center)
                        Spacer().frame(height: 28)
                        bottomView
                        
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 25)
                    .padding(.bottom, 25)
                    .background(Color.symWhite)
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
        HStack(spacing: 30) {
            Text(leftTitle)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.symBlack)
                .background(Color.symPink)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .onTapGesture {
                    confirmHandler()
                }
            
            Text(rightTitle)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.symBlack)
                .background(Color.symGray2)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .onTapGesture {
                    cancelHandler()
                }
        }
        .font(PretendardFont.bodyMedium)
        .padding(.horizontal, 20)
    }
    
    func guideView(title: String) -> some View {
        VStack {
            Text(title)
                .padding(.vertical, 11)
                .frame(maxWidth: .infinity)
                .background(Color.symPink)
                .font(PretendardFont.bodyMedium)
                .clipShape(RoundedRectangle(cornerRadius: 15))
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

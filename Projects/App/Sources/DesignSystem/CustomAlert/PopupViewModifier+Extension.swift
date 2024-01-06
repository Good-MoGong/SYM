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
    case guide
}

struct PopupView: ViewModifier {
    @Binding var isShowing: Bool
    let type: PopupType
    let title: String
    let desc: String
    let confirmHandler: () -> Void
    let cancelHandler: () -> Void
    
    init(isShowing: Binding<Bool>,
         type: PopupType,
         title: String,
         desc: String,
         confirmHandler: @escaping () -> Void,
         cancelHandler: @escaping () -> Void) {
        self._isShowing = isShowing
        self.type = type
        self.title = title
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
                            .font(DesignSystem.FontStyles.symH3)
                            .fontWeight(.bold)
                        Spacer().frame(height: 10)
                        if !desc.isEmpty {
                            Text(desc)
                                .font(DesignSystem.FontStyles.symBody)
                                .lineSpacing(2)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer().frame(height: 14)
                        
                        bottomView
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                    .padding(.bottom, 10)
                    .background(Color.white)
                    .cornerRadius(30)
                    .padding(.horizontal, 30)
                }
            case .guide:
                ZStack {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack {
                            Text(title)
                                .font(DesignSystem.FontStyles.symH3)
                                .fontWeight(.bold)
                            Spacer()
                            bottomView
                                .frame(alignment: .trailing)
                        }
                        Spacer().frame(height: 20)
                        Text(desc)
                            .font(DesignSystem.FontStyles.symBody)
                            .lineSpacing(1.5)
                            .multilineTextAlignment(.leading)
                        
                        Spacer().frame(height: 20)
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                    .padding(.bottom, 25)
                    .background(Color.white)
                    .cornerRadius(30)
                    .padding(.horizontal, 30)
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
        case .guide:
            guideView()
        }
    }
    
    func multiButtonView(leftTitle: String, rightTitle: String) -> some View {
        HStack(spacing: 10) {
            Text(leftTitle)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.gray)
                .cornerRadius(10)
                .onTapGesture {
                    cancelHandler()
                }
            Text(rightTitle)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.red)
                .cornerRadius(10)
                .onTapGesture {
                    confirmHandler()
                }
        }
        .font(DesignSystem.FontStyles.symH5)
        .foregroundColor(Color.yellow)
        .padding(.horizontal, 20)
    }
    
    func guideView() -> some View {
        HStack {
            Image(systemName: "xmark")
                .foregroundColor(Color.black)
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
               desc: String,
               confirmHandler: @escaping () -> Void,
               cancelHandler: @escaping () -> Void)
    -> some View {
        self.modifier(PopupView(isShowing: isShowing,
                                type: type,
                                title: title,
                                desc: desc,
                                confirmHandler: confirmHandler,
                                cancelHandler: cancelHandler))
    }
}

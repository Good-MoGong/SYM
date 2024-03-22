//
//  CustomAlert.swift
//  DesignSystem
//
//  Created by 박서연 on 2024/03/21.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import SwiftUI

public enum PopupType {
    case doubleButton(leftTitle: String, rightTitle: String)
    case guide(title: String)
}

public struct PopupView: ViewModifier {
    @Binding var isShowing: Bool

    let type: PopupType
    let title: String
    let desc: String
    let confirmHandler: () -> Void
    let cancelHandler: () -> Void
    let fontHeight = UIFont.preferredFont(forTextStyle: .caption1).lineHeight
    
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
        content
            .overlay {
                ZStack {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                    switch type {
                    case .doubleButton(_, _):
                        ZStack {
                            VStack(alignment: .center, spacing: 18) {
                                Spacer().frame(height: 3) // 총 26 .top
                                CommonButtonView(title: title, desc: desc)
                                bottomView
                            }
                            .customPopupModifier()
                        }
                    case .guide:
                        ZStack {
                            VStack(alignment: .center, spacing: 18) {
                                CommonButtonView(title: title, desc: desc)
                                bottomView
                            }
                            .customPopupModifier()
                        }
                    }
                }
                .opacity(isShowing ? 1 : 0)
                .animation(.easeIn, value: isShowing)
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
        HStack(spacing: 22) {
            Text(leftTitle)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.gray5_69707B)
                .background(Color.gray1_F3F5F8)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    confirmHandler()
                }
            
            Text(rightTitle)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .background(Color.main_FF7E7E)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    cancelHandler()
                }
        }
        .font(.bold(16))
        .padding(.horizontal, 10)
    }
    
    func guideView(title: String) -> some View {
        Text(title)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .foregroundColor(Color.white)
            .background(Color.main_FF7E7E)
            .font(.bold(16))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture {
                cancelHandler()
            }
    }
}

public extension View {
    public func popup(isShowing: Binding<Bool>,
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

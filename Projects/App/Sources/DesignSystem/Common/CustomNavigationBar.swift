//
//  CustomNavigationBar.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct CustomNavigationBarModifier<C, R>: ViewModifier where C: View, R: View {
    @Environment(\.dismiss) var dismiss
    
    let centerView: (() -> C)?
    let rightView: (() -> R)?
    let isShowingBackButton: Bool?
    
    init(centerView: (() -> C)? = nil, rightView: (() -> R)? = nil, isShowingBackButton: Bool? = true) {
        self.centerView = centerView
        self.rightView = rightView
        self.isShowingBackButton = isShowingBackButton
    }
    
    func body(content: Content) -> some View {
        VStack {
            ZStack {
                HStack {
                    if isShowingBackButton ?? true {
                        Button {
                            dismiss()
                            print("dismiss")
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                    
                    self.rightView?()
                        .foregroundStyle(Color.symBlack)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                
                HStack {
                    Spacer()
                    
                    self.centerView?()
                        .font(PretendardFont.h4Bold)
                    
                    Spacer()
                }
            }
            .background((Color.white).ignoresSafeArea(.all, edges: .top))
            
            Rectangle()
                .foregroundStyle(Color.symGray3)
                .frame(height: 1)
            
            content
            
            Spacer()
        }
        .toolbar(.hidden)
    }
}

extension View {
    func customNavigationBar<C, R>(
        centerView: @escaping (() -> C),
        rightView: @escaping (() -> R),
        isShowingBackButton: Bool? = true
    ) -> some View where C: View, R: View {
        modifier(
            CustomNavigationBarModifier(centerView: centerView,
                                        rightView: rightView,
                                        isShowingBackButton: isShowingBackButton
                                       )
        )
    }
    
    func customNavigationBar<C>(
        centerView: @escaping (() -> C),
        isShowingBackButton: Bool
    ) -> some View where C: View {
        modifier(
            CustomNavigationBarModifier(
                centerView: centerView,
                rightView: {
                    EmptyView()
                },
                isShowingBackButton: isShowingBackButton)
        )
    }
}

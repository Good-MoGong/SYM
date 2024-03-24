//
//  File.swift
//  DesignSystem
//
//  Created by 박서연 on 2024/03/22.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

public struct CustomNavigationBarModifier<C, R>: ViewModifier where C: View, R: View {
    @Environment(\.dismiss) var dismiss
    @GestureState private var dragOffset = CGSize.zero
    /// Popup 메시지 등장 유무
    @Binding var availablePopup: Bool
    /// Popup 메시지 등장 토글
    @Binding var popupToggle: Bool
    
    /// navigation 제목 뷰
    let centerView: (() -> C)?
    /// navigation trailing item
    let rightView: (() -> R)?
    /// leading 백 버튼 유무, 기본 값 true
    let isShowingBackButton: Bool?
    
    public init(centerView: (() -> C)? = nil, rightView: (() -> R)? = nil, isShowingBackButton: Bool? = true, availablePopup: Binding<Bool> = .constant(false), popupToggle: Binding<Bool> = .constant(false)) {
        self.centerView = centerView
        self.rightView = rightView
        self.isShowingBackButton = isShowingBackButton
        self._availablePopup = availablePopup
        self._popupToggle = popupToggle
    }
    
    public func body(content: Content) -> some View {
        VStack {
            ZStack {
                HStack {
                    if isShowingBackButton ?? true {
                        Button {
                            if availablePopup == false{
                                dismiss()
                                print("dismiss")
                            } else {
                                popupToggle = true
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .padding(10)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                    
                    self.rightView?()
                        .foregroundStyle(Color.black2D2D2D)
                        .font(.medium(20))
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                
                HStack {
                    Spacer()
                    
                    self.centerView?()
                        .font(.medium(20))
                    
                    Spacer()
                }
            }
            .background((Color.white).ignoresSafeArea(.all, edges: .top))
            
            content
        }
        .contentShape(Rectangle())
        .gesture(DragGesture().onEnded { value in
            // 여기서 제스처를 인식하고 뒤로 이동하도록 처리해야 합니다.
            if value.translation.width > 100 {
                if availablePopup == false{
                    dismiss()
                    print("dismiss")
                } else {
                    popupToggle = true
                }
            }
        })
        .toolbar(.hidden)
    }
}

public extension View {
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
    
    func customNavigationBar<C, R>(
        centerView: @escaping (() -> C),
        rightView: @escaping (() -> R),
        isShowingBackButton: Bool? = true,
        availablePopup: Binding<Bool> = .constant(false),
        popupToggle: Binding<Bool> = .constant(false)
    ) -> some View where C: View, R: View {
        modifier(
            CustomNavigationBarModifier(centerView: centerView,
                                        rightView: rightView,
                                        isShowingBackButton: isShowingBackButton,
                                        availablePopup: availablePopup,
                                        popupToggle: popupToggle
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

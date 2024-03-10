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
    
    init(centerView: (() -> C)? = nil, rightView: (() -> R)? = nil, isShowingBackButton: Bool? = true, availablePopup: Binding<Bool> = .constant(false), popupToggle: Binding<Bool> = .constant(false)) {
        self.centerView = centerView
        self.rightView = rightView
        self.isShowingBackButton = isShowingBackButton
        self._availablePopup = availablePopup
        self._popupToggle = popupToggle
    }
    
    func body(content: Content) -> some View {
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
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                    
                    self.rightView?()
                        .foregroundStyle(Color.symBlack)
                        .font(PretendardFont.h3Medium)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                
                HStack {
                    Spacer()
                    
                    self.centerView?()
                        .font(PretendardFont.h3Medium)
                    
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

// 추가 작업 중
//extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//}

//
//  MainTab.swift
//  SYM
//
//  Created by 박서연 on 2024/01/24.
//  Copyright © 2024 Mogong. All rights reserved.
//
import SwiftUI

enum MainTab: Int, CaseIterable, Identifiable {
    case home, mypage
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .home:
            CalendarMainView()
        case .mypage:
            MypageView()
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .mypage:
            return "마이페이지"
        }
    }
    
    var imageName: String {
        switch self {
        case .home:
            return "Home"
        case .mypage:
            return "mypage"
        }
    }
    
    var id: Self { self }
}

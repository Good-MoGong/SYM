//
//  MainTab.swift
//  SYM
//
//  Created by 박서연 on 2024/01/24.
//  Copyright © 2024 Mogong. All rights reserved.
//
import SwiftUI

enum MainTab: Int, CaseIterable, Identifiable {
    case home, diary, alarm, myPage
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .home:
            EmptyView()
        case .diary:
            EmptyView()
        case .alarm:
            EmptyView()
        case .myPage:
            EmptyView()
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .diary:
            return "감정일기"
        case .alarm:
            return "알림"
        case .myPage:
            return "마이페이지"
        }
    }
    
    var imageName: String {
        switch self {
        case .home:
            return "house"
        case .diary:
            return "pencil"
        case .alarm:
            return "alarm"
        case .myPage:
            return "person"
        }
    }
    
    var id: Self { self }
}

////
////  MainView.swift
////  SYM
////
////  Created by 박서연 on 2024/01/09.
////  Copyright © 2024 Mogong. All rights reserved.
////
//

import SwiftUI

struct MainView: View {
    @StateObject private var tabBarViewModel = TabBarViewModel()
    
    var body: some View {
        NavigationStack {
            TabView(selection: $tabBarViewModel.selected) {
                ForEach(MainTab.allCases) { tab in
                    tab.view
                }
                .toolbarBackground(.hidden, for: .tabBar)
            }
            .overlay {
                VStack {
                    Spacer()
                    TabBarView(tabBarViewModel: tabBarViewModel)
                }
            }
            .onAppear() {
                UITabBar.appearance().barTintColor = .white
            }
        }
    }
}
//struct CustomTabView: View {
//    @Binding var selectedTab: Tab
//    
//    var body: some View {
//        Spacer().frame(height: 11)
//        HStack {
//            Button {
//                selectedTab = .first
//            } label: {
//                VStack(spacing: 4) {
//                    Image(systemName: "house")
//                        .font(.system(size: 24))
//                    Text("홈")
//                        .font(PretendardFont.smallMedium)
//                }
//            }.foregroundColor(selectedTab.rawValue == "first" ? Color.symBlack : Color.symGray3)
//            
//            Spacer()
//            Button {
//                selectedTab = .second
//            } label: {
//                VStack(spacing: 4) {
//                    Image(systemName: "square.and.pencil")
//                        .font(.system(size: 24))
//                    Text("기록")
//                        .font(PretendardFont.smallMedium)
//                }
//            }.foregroundColor(selectedTab.rawValue == "second" ? Color.symBlack : Color.symGray3)
//            
//            Spacer()
//            Button {
//                selectedTab = .third
//            } label: {
//                VStack(spacing: 4) {
//                    Image(systemName: "calendar")
//                        .font(.system(size: 24))
//                    Text("캘린더")
//                        .font(PretendardFont.smallMedium)
//                }.foregroundColor(selectedTab.rawValue == "third" ? Color.symBlack : Color.symGray3)
//            }
//        }
//        .padding(.horizontal, 45)
//    }
//}

#Preview {
    MainView()
}

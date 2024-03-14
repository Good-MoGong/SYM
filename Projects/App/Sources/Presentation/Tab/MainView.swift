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
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var tabBarViewModel = TabBarViewModel()
    @StateObject private var appVersionModel = AppVersionViewModel()
    
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
                appVersionModel.appUpdateCheck()
            }
        }
        // 업데이트 로직 추가
        .alert("업데이트 알림", isPresented: $appVersionModel.isUpdated, actions: {
            Button {
                Task {
                   await appVersionModel.switchAppStoreForUpdateApp()
                }
            } label: {
                Text("업데이트")
            }
        }, message: {
            Text("새로운 업데이트 정보가 존재합니다.\n업데이트 후 이용해주세요.\n현재 \(AppVersion.shared.appVersion) 버전")
        })
    }
}

#Preview {
    MainView()
}

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
#Preview {
    MainView()
}

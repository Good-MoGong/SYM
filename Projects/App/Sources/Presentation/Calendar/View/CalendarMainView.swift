//
//  CalendarMainView.swift
//  SYM
//
//  Created by 안지영 on 1/29/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct CalendarMainView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State var currentDate: Date = Date()
    @State var selectDate: Date = Date()
    @State var isShowingOrganizeView: Bool = false
    
    @StateObject var calendarViewModel = CalendarViewModel(calendarUseCase: CalendarUseCase(calendarRepository: CalendarRepository()))
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("CalendarBackground")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    HeaderView()
                        .padding(.horizontal, 20)
                        .padding(.top)
                        .padding(.bottom, -15)
                    
                    ScrollView {
                        CalendarDetailView(currentDate: $currentDate, selectDate: $selectDate, isShowingOrganizeView: $isShowingOrganizeView, calendarViewModel: calendarViewModel)
                            .padding(20)
                        RecordView(beforeRecord: calendarViewModel.completeRecord)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 20)
                .scrollIndicators(.hidden)
                // 하위뷰 말고 상위뷰에 있어야함.. main에서 OrganizeView를 보내니까 올때도 mainView로,,
                .navigationDestination(isPresented: $isShowingOrganizeView) {
                    RecordOrganizeView(organizeViewModel: calendarViewModel, isShowingOrganizeView: $isShowingOrganizeView)
                }
                .onAppear {
                    // 오늘날짜 페치해서 RecordView 어떻게 나타낼지
                    calendarViewModel.todayrecordFetch()
                    // 데이터 전체 페치
                    calendarViewModel.recordWholeFetch()
                    calendarViewModel.userID = authViewModel.userId ?? ""
                }
            }
        }
    }
}

// MARK: - HeaderView: 환영글
struct HeaderView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // ~님 -> 나중에 닉네임으로 변경
                Text("\(authViewModel.nickName ?? "모공")님, 반가워요!")
                    .foregroundStyle(Color.symBlack)
                Text("오늘의 기분은 어때요?")
                    .foregroundStyle(Color.main)
            }
            .font(PretendardFont.h3Bold)
            
            Spacer(minLength: 0)
        }
        .padding(.leading, 15)
        .padding(.bottom, 40)
    }
}

#Preview {
    CalendarMainView()
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}

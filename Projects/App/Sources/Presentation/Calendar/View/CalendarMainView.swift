//
//  CalendarMainView.swift
//  SYM
//
//  Created by 안지영 on 1/29/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct CalendarMainView: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @State var currentDate: Date = Date()
    @State var selectDate: Date = Date()
    
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
                        CalendarDetailView(currentDate: $currentDate, 
                                           selectDate: $selectDate, 
                                           calendarViewModel: calendarViewModel)
                            .padding(20)
                        RecordView(existRecord: calendarViewModel.diaryExists(on: selectDate.formatToString()),
                                   calendarViewModel: calendarViewModel,
                                   selectDate: selectDate)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 20)
                .scrollIndicators(.hidden)
                .onAppear {
                    // 오늘날짜 페치해서 RecordView 어떻게 나타낼지
                    calendarViewModel.todayrecordFetch()
                    // 데이터 전체 페치
                    calendarViewModel.recordWholeFetch()
                    calendarViewModel.userID = authViewModel.userId ?? ""
                }
                .animation(.easeIn, value: currentDate)
                .toastView(toast: $calendarViewModel.impossibleMessage)
            }
        }
    }
}

// MARK: - HeaderView: 환영글
struct HeaderView: View {
    @State private var nickname: String = UserDefaultsKeys.nickname
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // ~님 -> 나중에 닉네임으로 변경
                Text("\(nickname)님, 반가워요!")
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
    CalendarMainView(authViewModel: AuthenticationViewModel(container: DIContainer(services: Services())))
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}

//
//  CalendarMainView.swift
//  SYM
//
//  Created by 안지영 on 1/29/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import DesignSystem

struct CalendarMainView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var currentDate: Date = Date()
    @State private var selectDate: Date = Date()
    @State private var isShowingOrganizeView: Bool = false
    @State private var isShowingRecordView: Bool = false
    
    @StateObject private var calendarViewModel = CalendarViewModel(calendarUseCase: CalendarUseCase(calendarRepository: CalendarRepository()))
    
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
                        .padding(.bottom, -30)
                    
                    ScrollView {
                        CalendarDetailView(currentDate: $currentDate,
                                           selectDate: $selectDate,
                                           calendarViewModel: calendarViewModel)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        CalendarRecordView(calendarViewModel: calendarViewModel,
                                           isShowingOrganizeView: $isShowingOrganizeView,
                                           isShowingRecordView: $isShowingRecordView,
                                           selectDate: $selectDate,
                                           existRecord: calendarViewModel.diaryExists(on: selectDate.formatToString()))
                        .padding(.horizontal, 20)
                    }
                }
                .navigationDestination(isPresented: $isShowingRecordView) {
                    RecordStartView(isShowingOrganizeView: $isShowingRecordView, selectDate: selectDate)
                }
                .navigationDestination(isPresented: $isShowingOrganizeView) {
                    RecordOrganizeView(organizeViewModel: calendarViewModel, isShowingOrganizeView: $isShowingOrganizeView)
                }
                .padding(.bottom, 20)
                .scrollIndicators(.hidden)
                .onAppear {
                    calendarViewModel.observeCoreData()
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
    @AppStorage("nickname") private var nickname = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(nickname)님, 반가워요!")
                    .foregroundStyle(Color.symBlack)
                Text("오늘의 기분은 어때요?")
                    .foregroundStyle(Color.main)
            }
            .font(.bold(20))
            
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

//
//  CalendarMainView.swift
//  SYM
//
//  Created by 안지영 on 1/29/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct CalendarMainView: View {
    @State var currentDate: Date = Date()
    @State var selectDate: Date = Date()
    @State private var nickname: String = "모공모공"
    @State var isShowingOrganizeView: Bool = false
    @StateObject var calendarViewModel = CalendarViewModel(calendarUseCase: CalendarUseCase(calendarRepository: CalendarRepository()))
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("CalendarBackground")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    CalendarDetailView(nickname: $nickname, currentDate: $currentDate, selectDate: $selectDate, calendarViewModel: calendarViewModel)
                        .padding(20)
                    RecordView(beforeRecord: calendarViewModel.completeRecord, nickname: nickname)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
                .scrollIndicators(.hidden)
                .onAppear {
                    calendarViewModel.recordDiary.date = Date().formatToString()
                    // 오늘 날짜 데이터 페치, 이걸로 RecordView가 바뀜
                    calendarViewModel.recordSpecificFetch()
                    // 데이터 전체 페치
                    calendarViewModel.recordWholeFetch()
                }
            }
        }
    }
}

#Preview {
    CalendarMainView()
}

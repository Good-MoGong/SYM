//
//  CalendarDetailView.swift
//  SYM
//
//  Created by 안지영 on 1/29/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct CalendarDetailView: View {
    @State private var isShowingDateChangeSheet: Bool = false
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    private let weekday: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack {
            YearMonthHeaderView(calendarViewModel: calendarViewModel,
                                isShowingDateChangeSheet: $isShowingDateChangeSheet)
            CalendarView(calendarViewModel: calendarViewModel,
                         weekday: weekday)
        }
    }
}

// MARK: - YearMonthHeaderView: 연도, 월
struct YearMonthHeaderView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var isShowingDateChangeSheet: Bool
    
    var body: some View {
        HStack {
            // 연도, 월 텍스트
            Text("\(calendarViewModel.getYearAndMonthString(currentDate: calendarViewModel.currentDate)[0])년 \(calendarViewModel.getYearAndMonthString(currentDate: calendarViewModel.currentDate)[1])")
                .font(.title3.bold())
            
            // 날짜 이동 시트 버튼
            Button(action: {
                isShowingDateChangeSheet.toggle()
            }, label: {
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.black)
            })
        }
        .sheet(isPresented: $isShowingDateChangeSheet,
               content: { DatePicker(calendarViewModel: calendarViewModel,
                                     isShowingDateChangeSheet: $isShowingDateChangeSheet)
            
                .presentationDetents([.fraction(0.4)])
        })
    }
}

// MARK: - CalendarView: 캘린더뷰
struct CalendarView: View {
    @State private var offset: CGSize = CGSize()
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    let weekday: [String]
    
    var body: some View {
        VStack {
            WeekdayHeaderView(weekday: weekday)
            
            DatesGridView(calendarViewModel: calendarViewModel)
        }
        .padding(.top, 20)
        // currentMonth 바뀔 때 마다
        .onChange(of: calendarViewModel.currentMonth) { _ in
            // 현재 달력이 보여주는 month로 현재날짜 지정해서 달력 보여주기
            calendarViewModel.currentDate = calendarViewModel.getCurrentMonth(addingMonth: calendarViewModel.currentMonth)
        }
        // 옆으로 스크롤해서 month 넘기기
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    let calender = Calendar.current
                    let selectyear = calender.component(.year, from: calendarViewModel.currentDate) // currentDate = 현재 Calender의 Date
                    let selectMonth = calender.component(.month, from: calendarViewModel.currentDate)
                    let presentMonth = calender.component(.month, from: Date())
                    
                    if gesture.translation.width < -20 { // 드래그 수치 80에서 20으로 변경
                        if selectMonth == presentMonth { // Calender의 Month와 현재 Month가 같으면 다음 Month로 넘어가지 않음
                            
                        } else {
                            calendarViewModel.currentMonth += 1
                            calendarViewModel.selectedMonth += 1
                        }
                    } else if gesture.translation.width > 20 { // 드래그 수치 80에서 20으로 변경
                        if selectyear == 2024 && selectMonth == 1 { // Calender의 Year가 2024, Month가 1이면 이전 Month로 넘어가지 않음
                        } else {
                            calendarViewModel.currentMonth -= 1
                            calendarViewModel.selectedMonth -= 1
                        }
                    }
                    self.offset = CGSize()
                }
        )
    }
}

// MARK: - WeekdayHeaderView: 요일
struct WeekdayHeaderView: View {
    
    let weekday: [String]
    
    var body: some View {
        HStack {
            ForEach(weekday, id: \.self) { day in
                Text(day)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                // 만약 일요일이라면 글씨색 red
                    .foregroundStyle(day == "일" ? Color.errorRed : Color.symBlack)
            }
        }
        .padding(.bottom, 5)
    }
}

// MARK: - CalendarGridView: 날짜 그리드
struct DatesGridView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        // 달력 그리드
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(calendarViewModel.extractDate(currentMonth: calendarViewModel.currentMonth)) { value in
                if value.day != -1 {
                    DateButton(value: value, 
                               calendarViewModel: calendarViewModel,
                               selectDate: $calendarViewModel.selectDate)
                        .onTapGesture {
                            calendarViewModel.checkingDate = value.date
                            calendarViewModel.popupDate = true
                            calendarViewModel.checkingDateFuture()
                        }
                } else {
                    // 날짜 공백때문에 -1이 있을경우 숨긴다
                    Text("\(value.day)").hidden()
                }
            }
        }
    }
}

// MARK: - 날짜버튼
struct DateButton: View {
    var value: DateValue
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var selectDate: Date
    
    // 오늘인지 아닌지
    private var isToday: Bool {
        Calendar.current.isDateInToday(value.date)
    }
    // 해당 날짜가 무슨 요일인지 (일요일이면 foregroundColor red로 바꿀때 사용)
    private var dayOfWeek: Int {
        Calendar.current.component(.weekday, from: value.date)
    }
    // 날짜가 선택되었을 때
    private var isSelected: Bool {
        calendarViewModel.isSameDay(date1: value.date, date2: selectDate)
    }
    
    var body: some View {
        VStack {
            Button {
                selectDate = value.date
            } label: {
                VStack(spacing: 3) {
                    Text(isToday ? "오늘" : "")
                        .font(.medium(12))
                        .foregroundStyle(Color.errorRed)
                        .padding(.bottom, -5)
                    
                    Text("\(value.day)")
                        .font(.bold(18))
                        .fontWeight(.bold)
                        .foregroundColor(calendarViewModel.diaryExists(on: value.date.formatToString()) ? (dayOfWeek == 1 ? Color.errorRed : Color.symGray5) : (dayOfWeek == 1 ? Color.sub : Color.symGray4))
                    
                    Circle()
                        .fill(calendarViewModel.diaryExists(on: value.date.formatToString()) ?
                              Color.main : Color.white)
                        .frame(width: 6, height: 6)
                }
                .background(
                    Circle()
                        .fill(isSelected ? Color.medium : Color.white)
                        .frame(width: 50, height: 50)
                        .opacity(isSelected ? 1 : 0)
                )
            }
            .disabled(value.date > Date() ? true : false)
        }
    }
}

#Preview {
    CalendarMainView()
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}

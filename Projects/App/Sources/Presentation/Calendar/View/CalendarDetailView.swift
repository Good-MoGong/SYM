//
//  CalendarDetailView.swift
//  SYM
//
//  Created by 안지영 on 1/29/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct CalendarDetailView: View {
    @State private var currentMonth: Int = 0
    @State private var isShowingDateChangeSheet: Bool = false
    @State var selectedYear: Int = Calendar.current.component(.year, from: .now)
    @State var selectedMonth: Int = Calendar.current.component(.month, from: .now)
 
    @Binding var currentDate: Date
    @Binding var selectDate: Date
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    private let weekday: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack {
            YearMonthHeaderView(selectedYear: $selectedYear, selectedMonth: $selectedMonth, currentMonth: $currentMonth, currentDate: $currentDate, isShowingDateChangeSheet: $isShowingDateChangeSheet)
            CalendarView(currentMonth: $currentMonth, currentDate: $currentDate, selectDate: $selectDate, selectedYear: $selectedYear, selectedMonth: $selectedMonth, calendarViewModel: calendarViewModel, weekday: weekday)
        }
    }
}

// MARK: - YearMonthHeaderView: 연도, 월
struct YearMonthHeaderView: View {
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int
    @Binding var currentMonth: Int
    @Binding var currentDate: Date
    @Binding var isShowingDateChangeSheet: Bool
    
    var body: some View {
        HStack {
            // 연도, 월 텍스트
            Text("\(getYearAndMonthString(currentDate: currentDate)[0])년 \(getYearAndMonthString(currentDate: currentDate)[1])")
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
               content: { DatePicker(selectedYear: $selectedYear,
                                     selectedMonth: $selectedMonth,
                                     isShowingDateChangeSheet: $isShowingDateChangeSheet,
                                     currentMonth: $currentMonth,
                                     currentDate: $currentDate)
            
                .presentationDetents([.fraction(0.4)])
        })
    }
    
    /// 현재 연도, 월 String으로 변경하는 formatter로 배열 구하는 함수
    private func getYearAndMonthString(currentDate: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        formatter.locale = Locale(identifier: "ko_kr")
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
}

// MARK: - CalendarView: 캘린더뷰
struct CalendarView: View {
    
    @State private var offset: CGSize = CGSize()
    
    @Binding var currentMonth: Int
    @Binding var currentDate: Date
    @Binding var selectDate: Date
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    let weekday: [String]
    
    var body: some View {
        VStack {
            WeekdayHeaderView(weekday: weekday)
            
            DatesGridView(selectDate: $selectDate, 
                          currentMonth: $currentMonth,
                          calendarViewModel: calendarViewModel)
        }
        .padding(.top, 20)
        // currentMonth 바뀔 때 마다
        .onChange(of: currentMonth) { _ in
            // 현재 달력이 보여주는 month로 현재날짜 지정해서 달력 보여주기
            currentDate = getCurrentMonth(addingMonth: currentMonth)
        }
        // 옆으로 스크롤해서 month 넘기기
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    let calender = Calendar.current
                    let selectyear = calender.component(.year, from: currentDate) // currentDate = 현재 Calender의 Date
                    let selectMonth = calender.component(.month, from: currentDate)
                    let presentMonth = calender.component(.month, from: Date())
                    
                    if gesture.translation.width < -80 {
                        if selectMonth == presentMonth { // Calender의 Month와 현재 Month가 같으면 다음 Month로 넘어가지 않음
                            
                        } else {
                            currentMonth += 1
                            selectedMonth += 1
                        }
                    } else if gesture.translation.width > 80 {
                        if selectyear == 2024 && selectMonth == 1 { // Calender의 Year가 2024, Month가 1이면 이전 Month로 넘어가지 않음
                        } else {
                            currentMonth -= 1
                            selectedMonth -= 1
                        }
                    }
                    self.offset = CGSize()
                }
        )
        .onAppear() {
            selectDate = Date()
        }
    }
    /// 현재 캘린더에 보이는 month 구하는 함수
    private func getCurrentMonth(addingMonth: Int) -> Date {
        // 현재 날짜의 캘린더
        let calendar = Calendar.current
        
        // 현재 날짜의 month에 addingMonth의 month를 더해서 새로운 month를 만들어
        // 만약 오늘이 1월 27일이고 addingMonth에 2를 넣으면 3월 27일이됨
        guard let currentMonth = calendar.date(byAdding: .month, value: addingMonth, to: Date()) else { return Date() }
        
        return currentMonth
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
        .padding(.bottom, 15)
    }
}

// MARK: - CalendarGridView: 날짜 그리드
struct DatesGridView: View {
    
    @Binding var selectDate: Date
    @Binding var currentMonth: Int
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        // 달력 그리드
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(extractDate(currentMonth: currentMonth)) { value in
                if value.day != -1 {
                    DateButton(value: value, 
                               calendarViewModel: calendarViewModel,
                               selectDate: $selectDate)
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
    
    /// 현재 캘린더에 보이는 month 구하는 함수
    private func getCurrentMonth(addingMonth: Int) -> Date {
        // 현재 날짜의 캘린더
        let calendar = Calendar.current
        
        // 현재 날짜의 month에 addingMonth의 month를 더해서 새로운 month를 만들어
        // 만약 오늘이 1월 27일이고 addingMonth에 2를 넣으면 3월 27일이됨
        guard let currentMonth = calendar.date(byAdding: .month, value: addingMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    /// 해당 월의 모든 날짜들을 DateValue 배열로 만들어주는 함수, 모든 날짜를 배열로 만들어야 Grid에서 보여주기 가능
    private func extractDate(currentMonth: Int) -> [DateValue] {
        let calendar = Calendar.current
        
        // getCurrentMonth가 리턴한 month 구해서 currentMonth로
        let currentMonth = getCurrentMonth(addingMonth: currentMonth)
        
        // currentMonth가 리턴한 month의 모든 날짜 구하기
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            // 여기서 date = 2023-12-31 15:00:00 +0000
            let day = calendar.component(.day, from: date)
            
            // 여기서 DateValue = DateValue(id: "6D2CCF74-1217-4370-B3AC-1C2E2D9566C9", day: 1, date: 2023-12-31 15:00:00 +0000)
            return DateValue(day: day, date: date)
        }
        
        // days로 구한 month의 가장 첫날이 시작되는 요일구하기
        // Int값으로 나옴. 일요일 1 ~ 토요일 7
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        // month의 가장 첫날이 시작되는 요일 전을 채워주는 과정
        // 만약 1월 1일이 수요일에 시작된다면 일~화요일까지 공백이니까 이 자리를 채워주어야 수요일부터 시작되는 캘린더 모양이 생성됨
        // 그래서 만약 수요일(4)이 시작이라고 하면 일(1)~화(3) 까지 for-in문 돌려서 공백 추가
        // 캘린더 뷰에서 월의 첫 주를 올바르게 표시하기 위한 코드
        for _ in 0 ..< firstWeekday - 1 {
            // 여기서 "day: -1"은 실제 날짜가 아니라 공백을 표시한 개념, "date: Date()"도 임시
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
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
        isSameDay(date1: value.date, date2: selectDate)
    }
    
    var body: some View {
        VStack {
            Button {
                selectDate = value.date
                if calendarViewModel.diaryExists(on: value.date.formatToString()) {
                    calendarViewModel.recordDiary.date = selectDate.formatToString()
                    calendarViewModel.recordSpecificFetch()
                }
            } label: {
                VStack(spacing: 3) {
                    Text(isToday ? "오늘" : "")
                        .font(PretendardFont.smallMedium)
                        .foregroundStyle(Color.errorRed)
                        .padding(.bottom, -5)
                    
                    Text("\(value.day)")
                        .font(PretendardFont.h4Bold)
                        .fontWeight(.bold)
                        .foregroundColor(calendarViewModel.diaryExists(on: value.date.formatToString()) ? Color.symGray5 : (dayOfWeek == 1 ? Color.errorRed : Color.symGray4))
                    
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
    
    /// 두 날짜가 같은 날인지 확인하는 함수
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

#Preview {
    CalendarMainView(authViewModel: AuthenticationViewModel(container: DIContainer(services: Services())))
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}

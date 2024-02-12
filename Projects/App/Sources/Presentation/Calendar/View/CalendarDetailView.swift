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
    
    @Binding var nickname: String
    @Binding var currentDate: Date
    @Binding var selectDate: Date
    
    private let weekday: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack {
            HeaderView(nickname: $nickname)
            YearMonthHeaderView(currentMonth: $currentMonth, currentDate: $currentDate, isShowingDateChangeSheet: $isShowingDateChangeSheet)
            CalendarView(currentMonth: $currentMonth, currentDate: $currentDate, selectDate: $selectDate, weekday: weekday)
        }
    }
}

// MARK: - HeaderView: 환영글
struct HeaderView: View {
    
    @Binding var nickname: String
    
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

// MARK: - YearMonthHeaderView: 연도, 월
struct YearMonthHeaderView: View {
    
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
               content: { DateChangeSheetView(
                isShowingDateChangeSheet: $isShowingDateChangeSheet,
                currentMonth: $currentMonth,
                currentDate: $currentDate
               )
               .presentationDetents([.fraction(0.4)])
        })
    }
    
    /// 현재 연도, 월 String으로 변경하는 formatter로 배열 구하는 함수
    func getYearAndMonthString(currentDate: Date) -> [String] {
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
    
    let weekday: [String]
    
    var body: some View {
        VStack {
            WeekdayHeaderView(weekday: weekday)
            DatesGridView(selectDate: $selectDate, currentMonth: $currentMonth)
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
                    if gesture.translation.width < -100 {
                        currentMonth += 1
                    } else if gesture.translation.width > 100 {
                        currentMonth -= 1
                    }
                    self.offset = CGSize()
                }
        )
        .onAppear() {
            selectDate = Date()
        }
    }
    /// 현재 캘린더에 보이는 month 구하는 함수
    func getCurrentMonth(addingMonth: Int) -> Date {
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
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        // 달력 그리드
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(extractDate(currentMonth: currentMonth)) { value in
                if value.day != -1 {
                    DateButton(value: value, selectDate: $selectDate)
                } else {
                    // 날짜 공백때문에 -1이 있을경우 숨긴다
                    Text("\(value.day)").hidden()
                }
            }
        }
    }
    
    /// 현재 캘린더에 보이는 month 구하는 함수
    func getCurrentMonth(addingMonth: Int) -> Date {
        // 현재 날짜의 캘린더
        let calendar = Calendar.current
        
        // 현재 날짜의 month에 addingMonth의 month를 더해서 새로운 month를 만들어
        // 만약 오늘이 1월 27일이고 addingMonth에 2를 넣으면 3월 27일이됨
        guard let currentMonth = calendar.date(byAdding: .month, value: addingMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    /// 해당 월의 모든 날짜들을 DateValue 배열로 만들어주는 함수, 모든 날짜를 배열로 만들어야 Grid에서 보여주기 가능
    func extractDate(currentMonth: Int) -> [DateValue] {
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
    
    @State var isShowingRecordView = false
    
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
        Button {
            selectDate = value.date
            isShowingRecordView = true
        } label: {
            VStack(spacing: 3) {
                if isToday {
                    Text("오늘")
                        .font(PretendardFont.smallMedium)
                        .foregroundStyle(Color.errorRed)
                        .padding(.bottom, -5)
                } else {
                    Text("오늘")
                        .font(PretendardFont.smallMedium)
                        .foregroundStyle(isSelected ? Color.medium : Color.white)
                        .padding(.bottom, -5)
                }
                Text("\(value.day)")
                    .font(PretendardFont.h4Bold)
                    .fontWeight(.bold)
                    .foregroundStyle(dayOfWeek == 1 ? Color.errorRed : Color.symGray4)
                Circle()
                    .fill(isToday ? Color.main : Color.white)
                    .frame(width: 6, height: 6)
            }
            .background(
                Circle()
                    .fill(isSelected ? Color.medium : Color.white)
                    .frame(width: 50, height: 50)
                    .opacity(isSelected ? 1 : 0)
            )
        }
        .navigationDestination(isPresented: $isShowingRecordView) {
            RecordOrganizeView()
        }
    }
    
    /// 두 날짜가 같은 날인지 확인하는 함수
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}


// MARK: - DateChangeSheetView: 날짜 변경 sheet
struct DateChangeSheetView: View {
    
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    var years: [Int] {
        let yearArray = [2024, 2025, 2026, 2027, 2028]
        return removeCommasFromNumbers(numbers: yearArray)
    }
    var months: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        return dateFormatter.monthSymbols
    }
    
    @Binding var isShowingDateChangeSheet: Bool
    @Binding var currentMonth: Int
    @Binding var currentDate: Date
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                Picker(selection: $selectedYear, label: Text("Year")) {
                    ForEach(years, id: \.self) { year in
                        Text("\(year)년").tag(year)
                    }
                }
                .pickerStyle(.wheel)
                .clipShape(.rect.offset(x: -16))
                .padding(.trailing, -16)
                
                Picker(selection: $selectedMonth, label: Text("Month")) {
                    ForEach(1...12, id: \.self) { month in
                        Text("\(months[month - 1])").tag(month)
                    }
                }
                .pickerStyle(.wheel)
                .clipShape(.rect.offset(x: 16))
                .padding(.leading, -16)
            }
            Spacer()
            
            Button(action: {
                // 선택된 날짜를 생성
                let selectedDate = createNewDate(year: selectedYear, month: selectedMonth)
                // 현재 날짜와 선택된 날짜 사이의 차이(개월 수)를 계산
                let difference = Calendar.current.dateComponents([.month], from: Calendar.current.startOfDay(for: Date()), to: selectedDate).month ?? 0
                // 계산된 차이를 currentMonth에 반영
                currentMonth = difference
                // 현재 날짜 업데이트
                currentDate = selectedDate
                // 날짜 변경 시트 닫기
                isShowingDateChangeSheet.toggle()
            }, label: {
                Text("완료")
            })
            .buttonStyle(MainButtonStyle(isButtonEnabled: true))
        }
        .padding(20)
        .onAppear {
            selectedYear = Calendar.current.component(.year, from: currentDate)
            selectedMonth = Calendar.current.component(.month, from: currentDate)
        }
    }
    
    /// 선택된 연도와 월로 새로운 Date를 생성
    private func createNewDate(year: Int, month: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month + 1
        components.day = 1
        
        guard let newDate = Calendar.current.date(from: components) else {
            fatalError("Failed to create a new date.")
        }
        return newDate
    }
    
    ///
    private func removeCommasFromNumbers(numbers: [Int]) -> [Int] {
        // 연도를 형식화하는 NumberFormatter 생성
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none

        // 형식화된 연도를 배열에 추가
        var formattedYears: [Int] = []
        for number in numbers {
            if let formattedYear = numberFormatter.string(from: NSNumber(value: number)) {
                formattedYears.append(Int(formattedYear) ?? 0)
            }
        }
        return formattedYears
    }

}

#Preview {
    NavigationStack {
        CalendarMainView()
    }
}
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
    
    @Binding var currentDate: Date
    @Binding var selectDate: Date
    
    private let weekday: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    // ~님 -> 나중에 닉네임으로 변경
                    Text("모공모공님, 반가워요!")
                        .foregroundStyle(Color.symBlack)
                    Text("오늘의 기분은 어때요?")
                        .foregroundStyle(Color.sub)
                }
                .font(PretendardFont.h3Bold)
                
                Spacer(minLength: 0)
            }
            .padding(.leading, 37)
            .padding(.bottom, 33)
            
            // MARK: 연도, 월 헤더뷰 (여기 나눌 수 있으면 나누기)
            HStack {
                // 이전달 넘기는 버튼
                Button(action: {
                    currentMonth -= 1
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.black)
                })
                
                // 연도, 월 텍스트
                Text("\(getYearAndMonthString(currentDate: currentDate)[0])년 \(getYearAndMonthString(currentDate: currentDate)[1])")
                    .font(.title3.bold())
                    .padding(.horizontal, 28)
                
                // 다음달로 넘기는 버튼
                Button(action: {
                    currentMonth += 1
                }, label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.black)
                })
            }
            
            // MARK: Calendar View
            VStack {
                // 요일 view
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
                .padding(.bottom, 24)
                
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                // 달력 그리드
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(extractDate(currentMonth: currentMonth)) { value in
                        // 그 날이 무슨 요일인지 확인하는 상수. 이걸로 일요일이면 날짜 색 빨간색으로 바꿔주려고 선언
                        let dayOfWeek = Calendar.current.component(.weekday, from: value.date)
                        
                        VStack {
                            // 공백 채워주려고 있는 -1 때문에 이렇게 조건문으로
                            if value.day != -1 {
                                // 오늘 날짜이면
                                if isSameDay(date1: currentDate, date2: value.date) {
                                        Text("\(value.day)")
                                            .fontWeight(.bold)
                                        // 일요일이면 색 변경
                                            .foregroundStyle(dayOfWeek == 1 ? Color.errorRed : Color.symGray4)
                                            .background(
                                                Circle()
                                                    .fill(Color.medium)
                                                    .frame(width: 43, height: 43)
                                            )
                                    // 오늘이 아니면
                                    } else {
                                        Text("\(value.day)")
                                            .fontWeight(.bold)
                                        // 일요일이면 색 변경
                                            .foregroundStyle(dayOfWeek == 1 ? Color.errorRed : Color.symGray4)
                                        // 오늘날짜 뒤에 배경
                                            .background(
                                                Circle()
                                                    .fill(Color.white)
                                                    .frame(width: 43, height: 43)
                                            )
                                    }
                            // 공백인날이면 (-1 이면)
                            } else {
                                Text("\(value.day)")
                                    .foregroundStyle(.white)
                            }
                        }
                        // 날짜 누를때마다 해당 날짜가 selectDate
                        .onTapGesture {
                            selectDate = value.date
                            print(selectDate)
                        }
                    }
                }
            }
            .padding(20)
            // currentMonth 바뀔 때 마다
            .onChange(of: currentMonth) { _ in
                // 현재 달력이 보여주는 month로 현재날짜 지정해서 달력 보여주기
                currentDate = getCurrentMonth(addingMonth: currentMonth)
            }
        }
    }
}

private extension CalendarDetailView {
    /// 두 날짜가 같은 날인지 확인하는 함수
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    /// 현재 연도, 월 String으로 변경하는 formatter로 배열 구하는 함수
    func getYearAndMonthString(currentDate: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        formatter.locale = Locale(identifier: "ko_kr")
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
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

#Preview {
    CalendarMainView()
}

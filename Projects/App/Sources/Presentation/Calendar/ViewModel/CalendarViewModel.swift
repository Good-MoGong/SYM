//
//  CalendarDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

import Foundation
import CoreData
import Combine
import DesignSystem

final class CalendarViewModel: RecordConditionFetch {
    
    var userID: String = ""
    
    private let calendarUseCase: CalendarUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // 서연 추가
    @Published var impossibleMessage: Toast?
    @Published var checkingDate: Date = Date()
    @Published var popupDate: Bool = false
    
    @Published var recordDiary: Diary = .init(date: "", event: "", idea: "", emotions: [], action: "", gptAnswer: "")
    @Published var recordDiaryArray: [Diary] = []
    @Published var completeRecord: Bool = true
    @Published var isShowingRecordView: Bool = false
    @Published var isShowingOrganizeView: Bool = false
    
    @Published var currentDate: Date = Date()
    @Published var currentMonth: Int = 0
    @Published var selectDate: Date = Date()
    @Published var selectedYear: Int = Calendar.current.component(.year, from: .now)
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: .now)
    
    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
        recordWholeFetch()
    }
    
    /// NSMagagedObjectContext가 저장이 완료될 때마다 전체 페치 시행하는 함수
    func observeCoreData() {
        NotificationCenter.default.publisher(for: NSManagedObjectContext.didSaveObjectsNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.recordWholeFetch()
            }
            .store(in: &cancellables)
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
    
    // 서연 추가
    /// 현재 기준 미래날짜인지 아닌지 확인 -> 미래날짜일 경우 date button disabled
    func checkingDateFuture() {
        if popupDate {
            self.impossibleMessage = .init(message: "미래 날짜는 아직 기록할 수 없어요")
        } else {
            self.impossibleMessage = nil
        }
    }
    
    ///  특정 날짜 기록 불러오기
    func recordSpecificFetch() {
        calendarUseCase.fetchRecord(date: recordDiary.date) { diary, isSuccess in
            DispatchQueue.main.async {
                self.recordDiary = diary
                self.completeRecord = isSuccess
            }
        }
    }
    
    /// 전체 기록 불러오기
    func recordWholeFetch() {
        calendarUseCase.fetchWholeRecord { diaryArray in
            DispatchQueue.main.async {
                self.recordDiaryArray = diaryArray
            }
        }
    }
    
    /// 특정 날짜에 대한 기록이 존재하는지 확인
    func diaryExists(on dateString: String) -> Bool {
        return recordDiaryArray.contains(where: { diary -> Bool in
            return diary.date == dateString
        })
    }
    
    /// 기록 업데이트
    func updateRecord(updateDiary: Diary) {
        recordDiary.event = updateDiary.event
        recordDiary.idea = updateDiary.idea
        recordDiary.action = updateDiary.action
        recordDiary.gptAnswer = updateDiary.gptAnswer
        
        Task {
            await calendarUseCase.updateRecord(userID: userID, diary: recordDiary)
        }
    }
}

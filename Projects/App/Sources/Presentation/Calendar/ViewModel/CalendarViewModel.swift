//
//  CalendarDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

import Foundation

final class CalendarViewModel: RecordConditionFetch {
    
    private let calendarUseCase: CalendarUseCase
    
    @Published var recordDiary: Diary = .init(date: "", event: "", idea: "", emotions: [], action: "")
    @Published var recordDiaryArray: [Diary] = []
    @Published var completeRecord: Bool = true
    @Published var isShowingRecordView = false
    
    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
    }
    
    ///  특정 날짜 기록 불러오기
    func recordSpecificFetch() {
        calendarUseCase.fetchRecord(date: recordDiary.date) { diary, isSuccess in
            DispatchQueue.main.async {
                self.recordDiary = diary
            }
        }
    }
    
    ///  오늘 날짜 기록 불러오기
    func todayrecordFetch() {
        calendarUseCase.fetchRecord(date: Date().formatToString()) { diary, isSuccess in
            DispatchQueue.main.async {
                self.recordDiary = diary
                // RecordView의 beforeRecord랑 반대로 동작해서 반대로 값 넣어줘야함
                self.completeRecord = !isSuccess
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
}

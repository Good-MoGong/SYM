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
    @Published var completeRecord: Bool = true
    @Published var isShowingRecordView = false
    
    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
    }
    
    func recordSpecificFetch() {
        calendarUseCase.fetchRecord(date: recordDiary.date) { diary, isSuccess in
            DispatchQueue.main.async {
                self.recordDiary = diary
                // RecordView의 beforeRecord랑 반대로 동작해서 반대로 값 넣어줘야함
                self.completeRecord = !isSuccess
                self.isShowingRecordView = isSuccess
            }
        }
    }
}

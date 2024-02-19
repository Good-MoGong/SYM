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
    
    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
    }
    
    func recordSpecificFetch() {
        calendarUseCase.fetchRecord(date: recordDiary.date) { diary, isSuccess in
            DispatchQueue.main.async {
                self.recordDiary = diary
                // isSuccess Bool 값 받아서 어떻게 할건지
            }
        }
    }
}

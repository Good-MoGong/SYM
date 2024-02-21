//
//  CalendarUseCase.swift
//  SYM
//
//  Created by 안지영 on 2/19/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation


protocol CalendarUseCaseProtocol {
   func fetchRecord(date: String, completion: @escaping (Diary, Bool) -> Void)
}

final class CalendarUseCase: CalendarUseCaseProtocol {
    
    private let calendarRepository: CalendarRepository
    
    init(calendarRepository: CalendarRepository) {
        self.calendarRepository = calendarRepository
    }
    
    func fetchRecord(date: String, completion: @escaping (Diary, Bool) -> Void) {
        calendarRepository.fetchRecord(date: date) { diary, isSuccess in
            completion(diary, isSuccess)
        }
    }
    
    func fetchWholeRecord(completion: @escaping ([Diary]) -> Void) {
        calendarRepository.fetchWholeRecord { diaryArray in
            completion(diaryArray)
        }
    }
}

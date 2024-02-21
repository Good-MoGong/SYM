//
//  CalendarRepository.swift
//  SYM
//
//  Created by 안지영 on 2/19/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

protocol CalendarRepositoryProtocol {
    func fetchRecord(date: String, completion: @escaping (Diary, Bool) -> Void)
}

final class CalendarRepository: CalendarRepositoryProtocol {
    
    private let coreDataManager = CoreDataManger.shared
    private var fetchDiary: Diary = .init(date: "", event: "", idea: "", emotions: [], action: "")
    private var fetchDiaryArray: [Diary] = []
    
    /// 특정 날짜 기록 불러오기
    func fetchRecord(date: String, completion: @escaping (Diary, Bool) -> Void) {
        let diaryEntitys = coreDataManager.retrieve(type: DiaryEntity.self, column: \.date, comparision: .equal, value: date)
        let isFetchSuccess = diaryEntitys.isEmpty ? false : true
        if let diaryEntity = diaryEntitys.first {
            self.fetchDiary = Diary(
                date: diaryEntity.date,
                event: diaryEntity.event,
                idea: diaryEntity.idea,
                emotions: diaryEntity.emotion,
                action: diaryEntity.action
            )
        } else {
            self.fetchDiary = Diary(date: "", event: "", idea: "", emotions: [], action: "")
        }

        completion(fetchDiary, isFetchSuccess)
    }
    
    /// 전체 기록 불러오기
    func fetchWholeRecord(completion: @escaping ([Diary]) -> Void) {
        let diaryEntitys = coreDataManager.retrieve(type: DiaryEntity.self)
        for diary in diaryEntitys {
            let fetchDiary = Diary(date: diary.date, event: diary.event, idea: diary.idea, emotions: diary.emotion, action: diary.action)
            self.fetchDiaryArray.append(fetchDiary)
        }
        completion(fetchDiaryArray)
    }
}

//
//  RecordRepository.swift
//  SYM
//
//  Created by 민근의 mac on 2/14/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

protocol RecordRepositoryProtocal {
    func saveRecord(diary: Diary) async -> Bool
    func fetchRecord(date: String, completion: @escaping (Diary, Bool) -> Void)
}

final class RecordRepository: RecordRepositoryProtocal {
    
    private let coreDataManager = CoreDataManger.shared
    private var fetchDiary: Diary = .init(date: "", event: "", idea: "", emotions: [], action: "")
   
    func saveRecord(diary: Diary) async -> Bool {
        let context = coreDataManager.newContextForBackgroundThread()
        return await context.perform {
            self.coreDataManager.create(contextValue: context) {
                let diaryInfo = DiaryEntity(context: context)
                print("\(diary)")
                diaryInfo.userId = ""
                diaryInfo.date = diary.date
                diaryInfo.event = diary.event
                diaryInfo.idea = diary.idea
                diaryInfo.emotion = diary.emotions
                diaryInfo.action = diary.action
            }
        }
    }
    
    func fetchRecord(date: String, completion: @escaping (Diary, Bool) -> Void) {
        let diaryEntitys = coreDataManager.retrieve(type: DiaryEntity.self, column: \.date, comparision: .equal, value: date)
        let isFetchSuccess = diaryEntitys.isEmpty ? false : true
        if let diaryEntity = diaryEntitys.first {
            self.fetchDiary = Diary(date: diaryEntity.date , event: diaryEntity.event , idea: diaryEntity.idea, emotions: diaryEntity.emotion , action: diaryEntity.action)
        } else {
            self.fetchDiary = Diary(date: "", event: "", idea: "", emotions: [], action: "")
        }

        completion(fetchDiary,isFetchSuccess)
    }
}
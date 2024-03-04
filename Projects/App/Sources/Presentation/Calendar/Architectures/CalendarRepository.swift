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
    func updateRecord(userID: String, diary: Diary) async -> Bool
}

final class CalendarRepository: CalendarRepositoryProtocol {
    
    private let coreDataManager = CoreDataManger.shared
    private let fireBaseManager = FirebaseManager.shared
    
    private var fetchDiary: Diary = .init(date: "", event: "", idea: "", emotions: [], action: "", gptAnswer: "")
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
                action: diaryEntity.action,
                gptAnswer: diaryEntity.gptAnswer
            )
        } else {
            self.fetchDiary = Diary(date: "", event: "", idea: "", emotions: [], action: "", gptAnswer: "")
        }

        completion(fetchDiary, isFetchSuccess)
    }
    
    /// 전체 기록 불러오기
    func fetchWholeRecord(completion: @escaping ([Diary]) -> Void) {
        let diaryEntitys = coreDataManager.retrieve(type: DiaryEntity.self)
        for diary in diaryEntitys {
            let fetchDiary = Diary(date: diary.date, event: diary.event, idea: diary.idea, emotions: diary.emotion, action: diary.action, gptAnswer: diary.gptAnswer)
            self.fetchDiaryArray.append(fetchDiary)
        }
        completion(fetchDiaryArray)
    }
    
    func updateRecord(userID: String, diary: Diary) async -> Bool {
        do {
            // Core Data에 업데이트하는 비동기 코드
            try await updateToCoreData(diary: diary)
            // Firebase에 업데이트하는 비동기 코드
            try await updateToFirebase(userID: userID, diary: diary)
            // 두 작업이 모두 완료되면 true를 반환
            return true
        } catch {
            // 실패한 경우에는 false를 반환
            return false
        }
    }
    
    private func updateToFirebase(userID: String, diary: Diary) async throws {
        try await fireBaseManager.updateDiaryFireStore(userID: userID, data: diary)
        print("Firebase 업데이트 성공")
    }
    
    private func updateToCoreData(diary: Diary) async throws {
        let context = coreDataManager.newContextForBackgroundThread()
        _ = await context.perform {
            self.coreDataManager.update(type: DiaryEntity.self, column: \.date, value: diary.date, contextValue: context) {
                let diaryInfo = DiaryEntity(context: context)
                diaryInfo.date = diary.date
                diaryInfo.event = diary.event
                diaryInfo.idea = diary.idea
                diaryInfo.emotion = diary.emotions
                diaryInfo.action = diary.action
            }
        }
    }
}

//
//  RecordRepository.swift
//  SYM
//
//  Created by 민근의 mac on 2/14/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import Combine

protocol RecordRepositoryProtocal {
    func saveRecord(userID: String, diary: Diary) async -> Bool
    func fetchRecord(date: String, completion: @escaping (Diary, Bool) -> Void)
    func updateRecord(userID: String, diary: Diary) async -> Bool
    func makeGPTRequest(text: String) -> AnyPublisher<String?, Error>
}

final class RecordRepository: RecordRepositoryProtocal {
    
    private let coreDataManager = CoreDataManger.shared
    private let chatGPTManager = ChatGPTManager.shared
    private let fireBaseManager = FirebaseManager.shared
    private let userID = ""
    private var fetchDiary: Diary = .init(date: "", event: "", idea: "", emotions: [], action: "", gptAnswer: "")
    private var cancellables = Set<AnyCancellable>()
    
    func saveRecord(userID: String, diary: Diary) async -> Bool {
        do {
            // Core Data에 저장하는 비동기 코드
            try await saveToCoreData(diary: diary)
            // Firebase에 저장하는 비동기 코드
            try await saveToFirebase(userID: userID, diary: diary)
            // 두 작업이 모두 완료되면 true를 반환
            return true
        } catch {
            // 실패한 경우에는 false를 반환
            return false
        }
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
    
    private func saveToFirebase(userID: String, diary: Diary) async throws {
        try await fireBaseManager.saveDiaryFireStore(userID: userID, data: diary)
        print("Firebase 저장 성공")
    }
    
    private func saveToCoreData(diary: Diary) async throws {
        let context = coreDataManager.newContextForBackgroundThread()
        _ = await context.perform {
            self.coreDataManager.create(contextValue: context) {
                let diaryInfo = DiaryEntity(context: context)
                diaryInfo.date = diary.date
                diaryInfo.event = diary.event
                diaryInfo.idea = diary.idea
                diaryInfo.emotion = diary.emotions
                diaryInfo.action = diary.action
                diaryInfo.gptAnswer = diary.gptAnswer
            }
        }
        print("CoreData 저장 성공")
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
                diaryInfo.gptAnswer = diary.gptAnswer
            }
        }
    }
    
    func fetchRecord(date: String, completion: @escaping (Diary, Bool) -> Void) {
        let diaryEntitys = coreDataManager.retrieve(type: DiaryEntity.self, column: \.date, comparision: .equal, value: date)
        let isFetchSuccess = diaryEntitys.isEmpty ? false : true
        if let diaryEntity = diaryEntitys.first {
            self.fetchDiary = Diary(date: diaryEntity.date , event: diaryEntity.event , idea: diaryEntity.idea, emotions: diaryEntity.emotion , action: diaryEntity.action, gptAnswer: diaryEntity.gptAnswer)
        } else {
            self.fetchDiary = Diary(date: "", event: "", idea: "", emotions: [], action: "", gptAnswer: "")
        }
        
        completion(fetchDiary,isFetchSuccess)
    }
    
    func makeGPTRequest(text: String) -> AnyPublisher<String?, Error> {
        guard let publisher = ChatGPTManager.shared.makeRequest(text: text) else {
                return Just(nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }

            return publisher
                .receive(on: DispatchQueue.main)
                .map {$0}
                .eraseToAnyPublisher()
        }
}

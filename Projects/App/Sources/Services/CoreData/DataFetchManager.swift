//
//  DataFetchManager.swift
//  SYM
//
//  Created by 안지영 on 2/29/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import CoreData
import FirebaseFirestore

final class DataFetchManager {
    
    static let shared = DataFetchManager()
    
    private let firebaseManager = FirebaseManager.shared
    private let coreDataManager = CoreDataManger.shared
    private let diary: Diary = .init(date: "", event: "", idea: "", emotions: [], action: "", gptAnswer: "")

    /// 로그인시, userID로 코어데이터, Firebase data fetch
    func fetchData(userID: String) async {
        do {
            // 1. Core Data에서 데이터 조회
            let localDiaries: [DiaryEntity] = coreDataManager.retrieve(type: DiaryEntity.self)
            
            if !localDiaries.isEmpty {
                // 1-1. Core Data에 데이터가 있으면 리턴
                print("⭐️⭐️⭐️Core Data에서 데이터를 성공적으로 조회했습니다.")
                return
            } else {
                // 1-2. CoreData에 데이터 없음 -> Firebase에서 데이터 조회
                // 2. Firebase에서 데이터 조회
                let fetchedDiaries: [Diary] = try await firebaseManager.fetchDiaryFireStore(userID: userID, data: diary)
                
                if fetchedDiaries.isEmpty {
                    // 2-1. Firebase에도 데이터가 없으면 리턴
                    print("⭐️⭐️⭐️Firebase에 데이터가 없습니다.")
                    return
                } else {
                    // 2-2. Firebase에 데이터가 있음 -> Core Data에 Firebase 데이터 저장
                    let context = coreDataManager.newContextForBackgroundThread()
                    _ = await context.perform {
                        for diary in fetchedDiaries {
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
                    }
                    print("⭐️⭐️⭐️CoreData 저장 성공")
                }
            }
        } catch {
            print("⭐️⭐️⭐️데이터 동기화 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    /// 코어데이터 삭제
    func deleteCoreData() {
        coreDataManager.deleteAll(type: DiaryEntity.self)
    }
}

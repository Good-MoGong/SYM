//
//  RecordUseCase.swift
//  SYM
//
//  Created by 민근의 mac on 2/14/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import Combine

final class RecordUseCase {
    
    private let recordRepository: RecordRepository
    
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    func saveRecord(userID: String, diary: Diary) async -> Bool {
        return await recordRepository.saveRecord(userID: userID, diary: diary)
    }
    
    func updateRecord(userID: String, diary: Diary) async -> Bool {
        return await recordRepository.updateRecord(userID: userID, diary: diary)
    }
    
    func fetchRecord(date: String, completion: @escaping (Diary, Bool) -> Void) {
        recordRepository.fetchRecord(date: date) { diary, isSuccess in
            completion(diary,isSuccess)
        }
    }
    
    func makeGPTRequest(diary: Diary) -> AnyPublisher<String?, Error>  {
        // 일기 작성 전 원하는 응답을 위한 고정 텍스트
        let constantText = "다음 문장에 대해 100자 이상, 공백 포함 150자 내로 공감해줘. 친근한 말투의 반말로 해줘."
        // 감정 부분 문자열로 생성
        let emotionsText = "나는" + diary.emotions.joined(separator: ", ") + "감정을 느꼈어."
        let mainText = diary.event + "." + diary.action + "." + diary.idea + "."
        let text = constantText + mainText + emotionsText
        
        return recordRepository.makeGPTRequest(text: text)
    }
}

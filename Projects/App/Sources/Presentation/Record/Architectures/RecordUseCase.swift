//
//  RecordUseCase.swift
//  SYM
//
//  Created by 민근의 mac on 2/14/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import Combine

protocol RecordUseCaseProtocol {
   func saveRecord(diary: Diary) async -> Bool
   func fetchRecord(date: String, completion: @escaping (Diary, Bool) -> Void)
}


final class RecordUseCase: RecordUseCaseProtocol {
   
    private let recordRepository: RecordRepository
    
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    func saveRecord(diary: Diary) async -> Bool {
        return await recordRepository.saveRecord(diary: diary)
    }
    
    func fetchRecord(date: String, completion: @escaping (Diary, Bool) -> Void) {
        recordRepository.fetchRecord(date: date) { diary, isSuccess in 
            completion(diary,isSuccess)
        }
    }
}

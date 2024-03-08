//
//  CalendarDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

import Foundation
import CoreData
import Combine

final class CalendarViewModel: RecordConditionFetch {
    
    var userID: String = ""
    
    private let calendarUseCase: CalendarUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // 서연 추가
    @Published var impossibleMessage: Toast?
    @Published var checkingDate: Date = Date()
    @Published var popupDate: Bool = false
    
    @Published var recordDiary: Diary = .init(date: "", event: "", idea: "", emotions: [], action: "", gptAnswer: "")
    @Published var recordDiaryArray: [Diary] = []
    @Published var completeRecord: Bool = true
    @Published var isShowingRecordView = false
    
    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
        recordWholeFetch()
    }
    
    /// NSMagagedObjectContext가
    func observeCoreData() {
        NotificationCenter.default.publisher(for: NSManagedObjectContext.didSaveObjectsNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.recordWholeFetch()
            }
            .store(in: &cancellables)
    }
    
    // 서연 추가
    /// 현재 기준 미래날짜인지 아닌지 확인 -> 미래날짜일 경우 date button disabled
    func checkingDateFuture() {
        if popupDate {
            self.impossibleMessage = .init(message: "미래 날짜는 아직 기록할 수 없어요")
        } else {
            self.impossibleMessage = nil
        }
    }
    
    ///  특정 날짜 기록 불러오기
    func recordSpecificFetch() {
        calendarUseCase.fetchRecord(date: recordDiary.date) { diary, isSuccess in
            DispatchQueue.main.async {
                self.recordDiary = diary
                self.completeRecord = isSuccess
            }
        }
    }
    
    /// 전체 기록 불러오기
    func recordWholeFetch() {
        calendarUseCase.fetchWholeRecord { diaryArray in
            DispatchQueue.main.async {
                self.recordDiaryArray = diaryArray
            }
        }
    }
    
    /// 특정 날짜에 대한 기록이 존재하는지 확인
    func diaryExists(on dateString: String) -> Bool {
        return recordDiaryArray.contains(where: { diary -> Bool in
            return diary.date == dateString
        })
    }
    
    /// 기록 업데이트
    func updateRecord(updateDiary: Diary) {
        recordDiary.event = updateDiary.event
        recordDiary.idea = updateDiary.idea
        recordDiary.action = updateDiary.action
        recordDiary.gptAnswer = updateDiary.gptAnswer
        
        Task {
            await calendarUseCase.updateRecord(userID: userID, diary: recordDiary)
        }
    }
}

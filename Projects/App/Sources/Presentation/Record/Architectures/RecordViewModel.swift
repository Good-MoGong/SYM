//
//  RecordViewModel.swift
//  SYM
//
//  Created by 민근의 mac on 2/3/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import Combine

final class RecordViewModel: RecordConditionFetch {
    
    private let recordUseCase: RecordUseCase
    @Published var recordOrder: RecordOrder = .event
    @Published var recordDiary: Diary = .init(date: "", event: "", idea: "", emotions: [], action: "")
    @Published var currentText: String = ""
    @Published var selectedEmotion: EmotionType = .joy
    @Published var selectedDatailEmotion: [String] = []
    @Published var gptAnswerText: String = ""
    
    @Published var isShowingOutPopUp: Bool = false
    @Published var isShowingGuidePopUp: Bool = false
    @Published var isShowingCompletionView: Bool = false
    @Published var isShowingOrganizeView: Bool = false
    @Published var isShowingToastMessage: Toast? = nil
    
    init(recordUseCase: RecordUseCase) {
        self.recordUseCase = recordUseCase
    }
    
    @MainActor
    func movePage(to direction: PageDirection) {
        guard let currentIndex = RecordOrder.allCases.firstIndex(of: recordOrder) else { return }
        
        saveCurrentText()
        if recordOrder == .event && direction == .previous {
            self.writeLater()
        }
        else if recordOrder == .action && direction == .next {
            recordDiary.date = Date().formatToString()
            Task {
                self.isShowingCompletionView = await recordUseCase.saveRecord(diary: recordDiary)
            }
        } else {
            withAnimation {
                let indexOffset = direction == .previous ? -1 : 1
                self.recordOrder = RecordOrder.allCases[currentIndex + indexOffset]
            }
        }
        updateCurrentText()
    }
    

    
    func recordSpecificFetch() {
        recordUseCase.fetchRecord(date: recordDiary.date) { diary, isSuccess in
            DispatchQueue.main.async {
                self.recordDiary = diary
                self.isShowingOrganizeView = isSuccess
            }
        }
    }
    
    func writeLater() {
        isShowingOutPopUp = true
    }
    
    func showGuide() {
        isShowingGuidePopUp = true
    }
    
    func selectEmotion(selected: EmotionType) {
        self.selectedEmotion = selected
    }
    
    func selectedDatailEmotion(selected: String) -> Bool {
        
        if let index = self.selectedDatailEmotion.firstIndex(of: selected) {
            // 이미 값이 있는 경우, 삭제하고 false 반환
            self.selectedDatailEmotion.remove(at: index)
            return false
        } else {
            // 값이 없는 경우, 추가하고 true 반환
            if selectedDatailEmotion.count < 5 {
                self.selectedDatailEmotion.append(selected)
                return true
            }
            isShowingToastMessage = .init(message: "감정단어는 최대 5개까지 선택할 수 있어요")
            return false
        }
    }
    
    private func saveCurrentText() {
        switch recordOrder {
        case .event: recordDiary.event = currentText
        case .idea: recordDiary.idea = currentText
        case .emotions: recordDiary.emotions = self.selectedDatailEmotion
        case .action: recordDiary.action = currentText
        }
    }
    
    private func updateCurrentText() {
        switch recordOrder {
        case .event: currentText = recordDiary.event
        case .idea: currentText = recordDiary.idea
        case .emotions: self.selectedDatailEmotion = recordDiary.emotions
        case .action: currentText = recordDiary.action
        }
    }
    
    func makeGPTRequest() {
        recordUseCase.makeGPTRequest(diary: recordDiary) { gptAnswer in
            self.gptAnswerText = gptAnswer
            
        }
    }
}

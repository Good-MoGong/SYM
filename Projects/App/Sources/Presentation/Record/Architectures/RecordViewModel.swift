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
    
    let recordUseCase: RecordUseCase
    var userID: String = ""
    @Published var recordOrder: RecordOrder = .event
    @Published var recordDiary: Diary = .init(date: "", event: "", idea: "", emotions: [], action: "", gptAnswer: "")
    @Published var currentText: String = ""
    @Published var selectedEmotion: EmotionType = .joy
    @Published var selectedDatailEmotion: [String] = []
    
    @Published var isShowingOutPopUp: Bool = false
    @Published var isShowingGuidePopUp: Bool = false
    @Published var isShowingCompletionView: Bool = false
    @Published var isShowingOrganizeView: Bool = false
    @Published var isShowingToastMessage: Toast? = nil
    @Published var isGPTLoading: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
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
            makeGPTRequest()
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
            print("😵‍💫\(isSuccess)")
            DispatchQueue.main.async {
                self.recordDiary = diary
                self.isShowingOrganizeView = isSuccess
            }
        }
    }
    
    @MainActor
    func updateRecord(updateDiary: Diary) {
        recordDiary.event = updateDiary.event
        recordDiary.idea = updateDiary.idea
        recordDiary.action = updateDiary.action
        recordDiary.gptAnswer = updateDiary.gptAnswer
        
        Task {
            await recordUseCase.updateRecord(userID: userID, diary: recordDiary)
        }
    }
    
    @MainActor
    func makeGPTRequest() {
        isShowingCompletionView = true
        isGPTLoading = true
                recordUseCase.makeGPTRequest(diary: recordDiary)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            self.isGPTLoading = false
                        case .failure(let error):
                            print("Error making GPT request: \(error)")
                            self.isGPTLoading = false
                        }
                    } receiveValue: { gptAnswer in
                        self.recordDiary.gptAnswer = gptAnswer ?? "시미가 공감할 수 없는 글이에요.."
                        self.saveRecord()
                    }
                    .store(in: &cancellables)
    }
    
    func saveRecord() {
        Task {
            await recordUseCase.saveRecord(userID: userID, diary: recordDiary)
        }
    }
    
    @MainActor
    func writeLater() {
        isShowingOutPopUp = true
    }
    @MainActor
    func showGuide() {
        isShowingGuidePopUp = true
    }
    @MainActor
    func selectEmotion(selected: EmotionType) {
        self.selectedEmotion = selected
    }
    @MainActor
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
    @MainActor
    private func saveCurrentText() {
        switch recordOrder {
        case .event: recordDiary.event = currentText
        case .idea: recordDiary.idea = currentText
        case .emotions: recordDiary.emotions = self.selectedDatailEmotion
        case .action: recordDiary.action = currentText
        }
    }
    
    @MainActor
    private func updateCurrentText() {
        switch recordOrder {
        case .event: currentText = recordDiary.event
        case .idea: currentText = recordDiary.idea
        case .emotions: self.selectedDatailEmotion = recordDiary.emotions
        case .action: currentText = recordDiary.action
        }
    }
}

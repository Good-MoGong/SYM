//
//  RecordViewModel.swift
//  SYM
//
//  Created by 민근의 mac on 2/3/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import Combine

class RecordViewModel: ObservableObject {
    
    @Published var recordOrder: RecordOrder = .event
    @Published var recordDiary: Diary = .init(date: "", event: "", idea: "", emotions: [], action: "")
    @Published var currentText: String = ""
    @Published var selectedEmotion: EmotionType = .joy
    @Published var selectedDatailEmotion: (EmotionType,[String]) = (EmotionType.joy, [""])
    
    @Published var isShowingOutPopUp: Bool = false
    @Published var isShowingCompletionView: Bool = false
    @Published var isShowingOrganizeView: Bool = false
    
    
    
    func movePage(to direction: PageDirection) {
        guard let currentIndex = RecordOrder.allCases.firstIndex(of: recordOrder) else { return }
        
        saveCurrentText()
        if recordOrder == .event && direction == .previous {
            self.writeLater()
        }
        else if recordOrder == .action && direction == .next {
            recordDiary.date = formatDateToString(date: Date())
            isShowingCompletionView = true
        } else {
            let indexOffset = direction == .previous ? -1 : 1
            recordOrder = RecordOrder.allCases[currentIndex + indexOffset]
        }
        updateCurrentText()
    }
 
    
    func seeRecord() {
        isShowingOrganizeView = true
    }
    func writeLater() {
        isShowingOutPopUp = true
    }
    
    func selectEmotion(selected: EmotionType) {
        self.selectedEmotion = selected
        self.selectedDatailEmotion.0 = selected
    }
    
    private func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 원하는 포맷으로 설정
        
        return dateFormatter.string(from: date)
    }
    
    private func saveCurrentText() {
        switch recordOrder {
        case .event: recordDiary.event = currentText
        case .idea: recordDiary.idea = currentText
        case .emotions: recordDiary.emotions = [currentText]
        case .action: recordDiary.action = currentText
        }
    }
    
    private func updateCurrentText() {
        switch recordOrder {
        case .event: currentText = recordDiary.event
        case .idea: currentText = recordDiary.idea
        case .emotions: currentText = recordDiary.emotions.last ?? ""
        case .action: currentText = recordDiary.action
        }
    }
}

enum RecordOrder: CaseIterable {
    case event
    case idea
    case emotions
    case action
    
    var symMent: String {
        switch self {
        case .event:
            "오늘 무슨 일이 있으셨나요?"
        case .idea:
            "그 일에 대해 어떤 생각이 들었나요?"
        case .emotions:
            "당시 내가 느낀 감정은 무엇인가요?"
        case .action:
            "어떤 행동을 하셨나요?"
        }
    }
}

enum PageDirection {
    case previous
    case next
}

enum EmotionType: String, CaseIterable {
    case joy = "기쁨"
    case sadness = "슬픔"
    case fear = "두려움"
    case disgust = "불쾌"
    case anger = "분노"
    
    var detailEmotion: [String] {
        switch self {
        case .joy:
            ["즐거운","","","",""]
        case .sadness:
            ["슬픔","","","",""]
        case .fear:
            ["두려운","","","",""]
        case .disgust:
            ["불쾌함","","","",""]
        case .anger:
            ["분노하는","","","",""]
        }
    }
}

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
    @Published var selectedDatailEmotion: [String] = []
    
    @Published var isShowingOutPopUp: Bool = false
    @Published var isShowingCompletionView: Bool = false
    @Published var isShowingOrganizeView: Bool = false
    @Published var isShowingToastMessage: Bool = false
    
    
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
            isShowingToastMessage.toggle()
            return false
        }
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
            ["감동적인","감사한","자신있는","재미있는","편안한","행복한","휼가분한","활기찬","자랑스러운","설레는","신나는","사랑스러운"]
        case .sadness:
            ["서운한","그리운","막막한","미안한","서러운","실망한","안타까운","후회스러운","허전한","우울한","외로운","괴로운"]
        case .fear:
            ["걱정스러운","긴장하는","무서운","깜짝놀란","불안한","혼란스러운","당황한","메스꺼운","좌절스러운","의기소침한","비참한","조마조마한"]
        case .disgust:
            ["곤란한","불편한","귀찮은","어색한","부끄러운","지루한","부담스러운","피곤한","부러운","황당한","찝찝한","매스꺼운"]
        case .anger:
            ["답답한","미운","원망스러운","지긋지긋한","짜증나는","억울한","화가나는","역겨운","신경질나는","기분이상한","눈물나는","우려스러운"]
        }
    }
}
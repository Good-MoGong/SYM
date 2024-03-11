//
//  RecordEnum.swift
//  SYM
//
//  Created by 민근의 mac on 2/21/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

enum RecordOrder: String, CaseIterable {
    case event = "사건"
    case idea = "생각"
    case emotions = "감정"
    case action = "행동"
    
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
    
    var guideMent: String {
        switch self {
        case .event:
            "언제, 어디서, 누가 관련되었는지 기록하며 사건을 요약하는 제목을 붙여보세요!\n고민하지 말고 생각나는대로 적어봐요:)"
        case .idea:
            "긍정, 부정적인 생각 모두 있는 그대로 적으며 ~하다고 생각했다, 왜~일까?와 같은 표현을 활용하면 더욱 명확히 표현할 수 있어요!"
        case .emotions:
            "당시 느낀 감정이 무엇인지 솔직하게 골라보세요!"
        case .action:
            "어떻게 행동했는지, 그래서 결과는 어땠는지 돌이켜보며 해당 행동이 나에게 어떤 영향을 미쳤는지 기록해보세요!"
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
            ["감동적인","감사한","자신있는","재미있는","편안한","행복한","홀가분","활기찬","자랑스러운","설레는","신나는","사랑스러운"]
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

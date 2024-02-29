//
//  Alarm.swift
//  SYM
//
//  Created by 박서연 on 2024/02/23.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

struct AlarmInfo: Hashable {
    static let title: String = "오늘 하루 어떤 감정을 느끼셨나요?"
    static let body: String = bodyList.randomElement() ?? "오늘의 감정을 기록하고 내일의 나를 발견해보세요"
    
    static let bodyList = ["오늘의 감정을 기록하고 내일의 나를 발견해보세요",
                               "어떤 감정이든 공유해주세요. 함께할 때 더 의미 있어요!",
                               "시미는 언제든지 기록을 시작할 준비가 되어있어요!",
                               "bodyList4"]
}

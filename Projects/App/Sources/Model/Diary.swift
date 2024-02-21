//
//  Diary.swift
//  SYM
//
//  Created by 박서연 on 2024/01/29.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

struct Diary: Codable {
    /// 날짜
    var date: String
    /// 사건
    var event: String
    /// 생각
    var idea: String
    /// 감정
    var emotions: [String]
    /// 행동
    var action: String
}

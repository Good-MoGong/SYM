//
//  DiaryViewModel.swift
//  SYM
//
//  Created by 안지영 on 2/3/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

class DiaryViewModel: ObservableObject {
    @Published var diaryArray: [Diary] = [
        Diary(date: Date(timeIntervalSinceNow: 36400), text: "이건 첫번째 테스트")
    ]
}

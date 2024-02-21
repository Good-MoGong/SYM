//
//  RecordConditionFetch.swift
//  SYM
//
//  Created by 안지영 on 2/18/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

protocol RecordConditionFetch: ObservableObject {
    
    var recordDiary: Diary { get set }

    func recordSpecificFetch()
}

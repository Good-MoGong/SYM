//
//  DateValue.swift
//  SYM
//
//  Created by 안지영 on 1/29/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

struct DateValue: Identifiable {
    var id: String = UUID().uuidString
    var day: Int
    var date: Date
}

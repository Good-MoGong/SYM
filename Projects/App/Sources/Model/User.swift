//
//  User.swift
//  SYM
//
//  Created by 박서연 on 2024/01/29.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct User: Codable {
    var id: String
    var name: String
    var diary: [Diary]?
}

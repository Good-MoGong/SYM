//
//  UserDefaultsKeys.swift
//  SYM
//
//  Created by 박서연 on 2024/03/02.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

// 유저디폴트 키 모음
struct UserDefaultsKeys {
    static let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
    static let loginProvider = UserDefaults.standard.string(forKey: "loginProvider") ?? ""
    static let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
}

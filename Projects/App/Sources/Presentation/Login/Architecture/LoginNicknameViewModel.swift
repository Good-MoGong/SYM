//
//  LoginNicknameViewModel.swift
//  SYM
//
//  Created by 박서연 on 2024/02/28.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import FirebaseAuth

class LoginNicknameViewModel: ObservableObject {
    @Published var nickname = ""
    @Published var isPressed: Bool = false
    @Published var user: User = .init(id: "", name: "")
    @Published var nicknameRules = NickNameRules.defult
    @Published var containsSpecialCharacter = false
    private let firebaseService = FirebaseService.shared
    
    func koreaLangCheck(_ input: String) -> Bool {
        let pattern = "^[가-힣a-zA-Z\\s]*$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(location: 0, length: input.utf16.count)
            if regex.firstMatch(in: input, options: [], range: range) != nil {
                return true
            }
        }
        return false
    }
    
    func addNicknametoFirebase() {
        // 유저 정보 닉네임까지 받아서 firestore에 추가
        if let userID = Auth.auth().currentUser?.uid {
            user.id = userID
            user.name = nickname
            user.diary = []
            firebaseService.createUserInFirebase(user: user)
        }
    }
    
}

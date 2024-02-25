//
//  FirebaseService.swift
//  SYM
//
//  Created by 박서연 on 2024/02/19.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseService {
    static let shared = FirebaseService()
    private init() { }
    
    let db = Firestore.firestore()

    // firestore에 유저 데이터 추가하기
    func createUserInFirebase(user: User) {
        let documentRef = db.collection("User").document(user.id)
        
        do {
            try documentRef.setData(from: user)
        } catch let error{
            print("\(error.localizedDescription)")
        }
    }
    
    // 탈퇴시 삭제되는 유저 정보를 찾는 함수
    
}

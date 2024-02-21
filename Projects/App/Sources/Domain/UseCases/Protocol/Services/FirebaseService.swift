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
    
    // firebase 에 닉네임이 저장되어 있는지 아닌지 확인하기
    func checkUserNickname(userID: String) -> Bool {
        let checkDB = db.collection("User").document(userID)
        var returnValue = false
        checkDB.getDocument { (document, error) in
            if let document = document, document.exists {
                returnValue = true
            } else {
                returnValue = false
            }
        }
        
        print("returnValue: \(returnValue)")
        return returnValue
    }
}

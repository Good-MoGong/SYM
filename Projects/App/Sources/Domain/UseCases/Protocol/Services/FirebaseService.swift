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
            print("🔥 Firebase DEBUG: Firestore의 User DB에 유저 추가시 에러 발생 \(error.localizedDescription)")
        }
    }
    
    // 탈퇴시 삭제되는 유저 정보를 찾는 함수 일단 User 디비만 삭제
    // (만약 일기 데이터로 인하여 하위 컬렉션 생성시.. 하위 컬렉션은 삭제되지 않음(파베에서 제공x)
    func deleteUserData(user: String, completion: @escaping (Bool) -> Void) {
        let documentRef = db.collection("User").document(user).delete() { error in
            if let error = error {
                print("🔥 Firebase DEBUG: User의 Firestore 문서 삭제 중 에러 발생 \(error.localizedDescription)")
                completion(false)
            } else {
                print("🔥 Firebase DEBUG: User의 Firestore 문서 삭제 완료")
                completion(true)
            }
        }
    }
}

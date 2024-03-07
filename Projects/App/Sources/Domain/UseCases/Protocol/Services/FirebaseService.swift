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
import Combine
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
//    func deleteUserData(user: String, completion: @escaping (Bool) -> Void) {
//        let _ = db.collection("User").document(user).delete() { error in
//            if let error = error {
//                print("🔥 Firebase DEBUG: User의 Firestore 문서 삭제 중 에러 발생 \(error.localizedDescription)")
//                completion(false)
//            } else {
//                print("🔥 Firebase DEBUG: User의 Firestore 문서 삭제 완료")
//                completion(true)
//            }
//        }
//    }
    
    // 서버에서 닉네임 값 가져오기
    func checkingUserNickname(userID: String, completion: @escaping (Bool) -> Void) {
        let _ = db.collection("User").document(userID).getDocument { document, error in
            if let error = error {
                print("🔥 Firebase DEBUG: Nickname 정보 패치 중 에러 발생\(error.localizedDescription)")
                completion(false)
            } else {
                if let document = document, document.exists {
                    print("🔥 Firebase DEBUG: Nickname 정보 서버에 있음!!")
                    if let nickname = document.data()?["name"] as? String {
                        UserDefaults.standard.set(nickname, forKey: "nickname")
                        completion(true)
                    }
                } else {
                    print("🔥 Firebase DEBUG: Nickname 정보 UserDefault에 저장 실패")
                    completion(false)
                }
            }
        }
    }
    
    // Firebase Auth에서 삭제
    func deleteFirebaseAuth(completion: @escaping (Bool) -> Void) {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("🔥 Firebase DEBUG: firebase auth에서 회원 삭제 중 에러 발생 \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("🔥 Firebase DEBUG: firebase auth에서 회원 삭제 성공")
                    completion(true)
                }
            }
        } else {
            print("🔥 Firebase DEBUG: firebase auth에 회원정보가 존재하지 않습니다.")
        }
    }
    
    func deleteFriebaseAuth() -> AnyPublisher<Void, Error> {
        Future { promise in
            self.deleteFirebaseAuth { result in
                if result {
                    promise(.success(()))
                } else {
                    promise(.failure(() as! Error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // Firebase에서 유저필드에 있는 Diary 컬렉션의 모든 문서필드 지우기
    func deleteDiarySubcollection(forUserID userID: String, completion: @escaping (Bool) -> Void) {
        let userRef = db.collection("User").document(userID)
        let diaryRef = userRef.collection("Diary")
        
        diaryRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("🔥Firebase DEBUG: Diary 문서 값 가져올때 에러발생: \(error)")
                return
            } else {
                guard let snapshot = snapshot else { return }
                
                for document in snapshot.documents {
                    let documentID = document.documentID
                    diaryRef.document(documentID).delete { (error) in
                        if let error = error {
                            print("🔥Firebase DEBUG: Diary 문서 삭제 중 에러 발생: \(error)")
                        } else {
                            print("🔥Firebase DEBUG: Diary 삭제완료 ")
                        }
                    }
                }
            }
        }
        
        userRef.delete() { error in
            if let error = error {
                print("🔥Firebase DEBUG: User Collection 삭제 중 에러 발생")
                completion(false)
            } else {
                print("🔥Firebase DEBUG: User Collection 까지 삭제 완료")
                print("\(Auth.auth().currentUser)")
                completion(true)
            }
        }
    }
    
}

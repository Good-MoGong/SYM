//
//  ServicesDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

// Demo

import Foundation
import FirebaseFirestore

final class FirebaseManager {
    
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()
    
    func fetchDiaryID(userID: String, date: String, completion: (String) -> Void) async throws {
        guard !date.isEmpty else { return }
        
        let collectionRef = db.collection("User").document(userID).collection("Diary")
        var diaryID = ""
        
        do {
          let querySnapshot = try await collectionRef.whereField("date", isEqualTo: date)
            .getDocuments()
          for document in querySnapshot.documents {
              diaryID = document.documentID
          }
            
            completion(diaryID)
            
        } catch {
          print("Error getting documents: \(error)")
        }
    }
    
    ///기록 저장
    func saveDiaryFireStore<T: Codable>(userID: String, data: T) async throws {
        
        guard !userID.isEmpty else { return }
        
        let collectionRef = db.collection("User").document(userID).collection("Diary")
        
        do {
            try collectionRef.addDocument(from: data.self)
        } catch {
            throw error
        }
    }
    
    func updateDiaryFireStore(userID: String, data: Diary) async throws {
        guard !userID.isEmpty else { return }
        
        print(data.date)
        
        var collectionRef = db.collection("User").document(userID)
        
        try await fetchDiaryID(userID: userID, date: data.date) { diaryID in
            collectionRef = db.collection("User").document(userID).collection("Diary").document(diaryID)
            print(diaryID)
        }
        
        do {
            try await collectionRef.setData([
                "event": data.event,
                "idea": data.idea,
                "emotions": data.emotions,
                "action" : data.action,
                "gptAnswer" : data.gptAnswer
              ], merge: true)
        } catch {
            throw error
        }
    }
    
    ///앱삭제 or 핸드폰 변경시 전체 데이터 fetch
    func fetchDiaryFireStore<T: Codable>(userID: String, data: T) async throws -> [T] {
        
        guard !userID.isEmpty else { return [] }
        
        let collectionRef = db.collection("User").document(userID).collection("Diary")
        do {
            let querySnapshot = try await collectionRef.getDocuments()
            let data = try querySnapshot.documents.compactMap { document in
                return try document.decode(as: T.self)
            }
            return data
        } catch {
            throw error
        }
    }
}

extension QueryDocumentSnapshot {
    func decode<T: Decodable>(as type: T.Type) throws -> T {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data(), options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: jsonData)
        } catch {
            throw error
        }
    }
}

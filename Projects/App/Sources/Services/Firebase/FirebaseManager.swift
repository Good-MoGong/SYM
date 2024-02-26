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

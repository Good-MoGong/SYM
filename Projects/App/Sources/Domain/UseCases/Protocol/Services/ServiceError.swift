//
//  ServiceError.swift
//  LMessenger
//
//  Created by 박서연 on 2024/01/24.
//

import Foundation

// 에러 - 서비스 단에서 다루는 에러
enum ServiceError: Error {
    case error(Error)
}

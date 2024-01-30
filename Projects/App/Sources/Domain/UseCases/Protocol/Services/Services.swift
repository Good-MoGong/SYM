//
//  Services.swift
//  LMessenger
//
//  Created by 박서연 on 2024/01/24.
//

import Foundation

protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    
    init() {
        self.authService = AuthenticationService()
    }
}

// preview용 서비스 프로토콜 생성
class stubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
}

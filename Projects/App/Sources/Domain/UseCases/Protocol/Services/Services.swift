//
//  Services.swift
//  LMessenger
//
//  Created by 박서연 on 2024/01/24.
//

import Foundation

// DIContainer와 소통하는 서비스 로직 (인증에 대한 서비스를 가지고 있음)
protocol ServiceType {
    var authService: AuthenticationServiceType { get set } // 인증 서비스
    var pushNotificationService: PushNotificationServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    var pushNotificationService: PushNotificationServiceType
    
    init() {
        self.authService = AuthenticationService()
        self.pushNotificationService = PushNotificationService()
    }
}

// preview용 서비스 프로토콜 생성
class stubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var pushNotificationService: PushNotificationServiceType = PushNotificationService()
}

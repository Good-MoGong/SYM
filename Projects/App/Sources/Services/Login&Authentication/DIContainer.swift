//
//  DIContainer.swift
//  SYM
//
//  Created by 박서연 on 2024/01/29.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

class DIContainer: ObservableObject {
    // 서비스 목록 관리
    
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
    
}

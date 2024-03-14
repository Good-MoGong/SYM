//
//  AppVersionViewModel.swift
//  SYM
//
//  Created by 박서연 on 2024/03/14.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

class AppVersionViewModel: ObservableObject {
    @Published var isUpdated: Bool = false
    
    func appUpdateCheck() {
        let system = AppVersion.shared
        
        if !system.compareMinorVersions(appVersion: system.appVersion, storeVersion: system.appStoreVersion) {
            DispatchQueue.main.async {
                self.isUpdated = true
            }
        }
    }
    
    func switchAppStoreForUpdateApp() async {
        await AppVersion.shared.openAppStore()
    }
}

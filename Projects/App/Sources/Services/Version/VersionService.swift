//
//  VersionService.swift
//  SYM
//
//  Created by 박서연 on 2024/03/14.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

final class AppVersion {
    static let shared: AppVersion = .init()
    
    /// 우리 앱 앱스토어 링크
    private let appStoreOpenUrlString: String
    private let appleID: String
    /// 현재 앱버전 정보
    let appVersion: String
    /// 앱스토어에서의 앱버전 정보
    var appStoreVersion: String
    
    private init() {
        self.appleID = Bundle.main.object(forInfoDictionaryKey: "App_ID") as? String ?? ""
        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1"
        self.appStoreVersion = "1"
        self.appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(self.appleID)"
        Task {
            self.appStoreVersion = await self.latestVersion()
        }
    }
    
    /// 앱 스토어 최신 정보 확인
    private func latestVersion() async -> String {
        do {
            guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)") else {
                return "1"
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let results = json?["results"] as? [[String: Any]]
            let appStoreVersion = results?[0]["version"] as? String
            
            return appStoreVersion ?? "1"
        } catch {
            return "1"
        }
    }
    
    func compareMinorVersions(appVersion: String, storeVersion: String) -> Bool {
    
        let app = String(appVersion.prefix(1)) // 현재 엑스코드 버전
        let store = String(storeVersion.prefix(1)) // 현재 앱스토어 버전
        
        let doubleApp = Double(app)
        let doubleStore = Double(store)
        
        guard let doubleApp, let doubleStore else {
            return true
        }
        
        // 1.0.0 이렇게 3자리를 기준으로 제일 앞선 자리가 작으면 강제 업데이트행
        if doubleApp < doubleStore { // 설치버전 < 앱스토어 버전
            return false // 업데이트 필요
        } else {
            return true // 업데이트 불필요
        }
    }
    
    // 앱 스토어로 이동 -> urlStr 에 appStoreOpenUrlString 넣으면 이동
    func openAppStore() async {
        guard let url = URL(string: self.appStoreOpenUrlString) else { return }
        if await UIApplication.shared.canOpenURL(url) {
            await UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

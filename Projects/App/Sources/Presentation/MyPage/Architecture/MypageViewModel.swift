//
//  MypageViewModel.swift
//  SYM
//
//  Created by 박서연 on 2024/03/14.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import SwiftUI

class MypageViewModel: ObservableObject {
    @Published var appVersion: String = ""
    @Published var nowVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    // 앱스토어 버전 (앱스토어에 출시되고 약 24시간 이후 출시된 앱 버전 가져오므로 주의!!)
    func latestVersion() {
        guard let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
            return
        }
        
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleIdentifier)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard error == nil,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results.first?["version"] as? String else {
                return
            }
            
            DispatchQueue.main.async {
                self?.nowVersion = appStoreVersion
            }
        }
        
        task.resume()
    }
    
    /// 리뷰 남기기로 이동
    func moveWritingReviews() {
        guard let appID = Bundle.main.object(forInfoDictionaryKey: "App_ID") as? String else { return }
        
        if let appstoreUrl = URL(string: "https://apps.apple.com/app/id/\(appID)") {
            var urlComp = URLComponents(url: appstoreUrl, resolvingAgainstBaseURL: false)
            urlComp?.queryItems = [
                URLQueryItem(name: "action", value: "write-review")
            ]
            guard let reviewUrl = urlComp?.url else {
                return
            }
            UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
        }
    }
}

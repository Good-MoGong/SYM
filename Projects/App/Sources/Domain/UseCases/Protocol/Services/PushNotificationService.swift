//
//  PushNotificationService.swift
//  SYM
//
//  Created by 박서연 on 2024/02/22.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import FirebaseMessaging

protocol PushNotificationServiceType {
    // 권한추가 메서드
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    // 알림 추가
    func settingPushNotification()
}

class PushNotificationService: NSObject, PushNotificationServiceType {
    // 데이터 저장 테스트
    private let firebaseService = FirebaseService.shared
    
    // 오늘 날짜
    let todayDate: String
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    override init() {
        self.todayDate = dateFormatter.string(from: Date())
    }
    
    /// 실질적인 알림 세팅 함수
    func settingPushNotification() -> Void {
        settingNotification(alarmInfo: AlarmInfo.firdayAlarm)
        settingNotification(alarmInfo: AlarmInfo.SaturdayAlarm)
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error {
                completion(false)
                print("⏰ ALARM DEBUG: Push Notification 권한 설정에서 에러 발생 \(error.localizedDescription)")
            } else {
                completion(true)
            }
        }
    }
    
    /// 오늘 날짜와 appstorge에 저장된 날짜 가져와서 비교하기
    func checkUserAccessDate() -> Int {
        let userLastAccessedDate = UserDefaults.standard.string(forKey: "lastAccessedDate") ?? ""
        
        guard let lastAccessDate = dateFormatter.date(from: userLastAccessedDate),
              let todayAccessDate = dateFormatter.date(from: todayDate) else { return 0 }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastAccessDate, to: todayAccessDate)
        return components.day ?? 1000000
    }
    
    // 알람 생성
    func settingNotification(alarmInfo: AlarmInfo) {
        if self.checkUserAccessDate() < 7 {
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.weekday = alarmInfo.weekday
            dateComponents.hour = alarmInfo.hour
            dateComponents.minute = alarmInfo.minute
            
            let content = UNMutableNotificationContent()
            content.title = alarmInfo.title
            content.sound = UNNotificationSound.default
            content.subtitle = alarmInfo.subtitle
            content.body = alarmInfo.body
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("⏰ ALARM DEBUG: 알림 생성 완료!")
            }
        }
    }
}

// 프리뷰용
class StubPushNotificationService: PushNotificationServiceType {
    func settingPushNotification() { }
    func requestAuthorization(completion: @escaping (Bool) -> Void) { }
}

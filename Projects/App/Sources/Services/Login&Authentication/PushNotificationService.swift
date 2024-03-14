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

    // 알람 세팅 함수
    func settingPushNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = AlarmInfo.title
        content.body = AlarmInfo.body
        
        let repeatCount = 10
            
        // 반복문을 사용하여 여러 알림을 예약
        for i in 1...repeatCount {
            // 저녁 7시
            var dateComponents = DateComponents()
            dateComponents.hour = 19 // 저녁 7시
            dateComponents.minute = 0
            dateComponents.second = 0
            
            // i일 후의 날짜 계산 -> 오늘 날짜를 기준으로 3일 후를 계산하기
            let triggerDate = Calendar.current.date(byAdding: .day, value: i * 3, to: Date())!
            
            // triggerDate에 시간을 설정
            let triggerDateWithTime = Calendar.current.date(bySettingHour: dateComponents.hour!, minute: dateComponents.minute!, second: dateComponents.second!, of: triggerDate)!
            
            // 알림 요청 생성 -> 식별자로 인하여 중복 안 됨
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerDateWithTime.timeIntervalSinceNow, repeats: false)
            let request = UNNotificationRequest(identifier: "\(i)Days Later", content: content, trigger: trigger)
            
            // 알림 예약
            center.add(request) { error in
                if let error = error {
                    print("⏰ 알림 설정 실패: \(error.localizedDescription)")
                } else {
                    print("⏰ 알림 설정 완료 \(i)일 후")
                }
            }
        }
    }
}

// 프리뷰용
class StubPushNotificationService: PushNotificationServiceType {
    func settingPushNotification() { }
    func requestAuthorization(completion: @escaping (Bool) -> Void) { }
}

//
//  PushNotificationService.swift
//  SYM
//
//  Created by 박서연 on 2024/02/22.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import FirebaseMessaging

struct AlarmInfo {
    let weekday: Int
    let hour: Int
    let minute : Int
    let title: String = "마음을 기록한지 \(PushNotificationService().checkUserAccessDate())일 이 지났어요"
    let subtitle: String = subTitleList.randomElement() ?? "시미를 확인해주세요!"
    let body: String = bodyList.randomElement() ?? "오늘 하루를 기록해보는건 어떤가요?"
    
    static let TitleList = ["Title First1", "Title First2", "Title First3", "Title First4"]
    static let subTitleList = ["subTitleList1", "subTitleList2", "subTitleList3", "subTitleList4"]
    static let bodyList = ["body1", "body2", "body3", "body4"]
    
    static let firdayAlarm = AlarmInfo(weekday: 6, hour: 21, minute: 46)
    static let SaturdayAlarm = AlarmInfo(weekday: 6, hour: 21, minute: 46)
}

protocol PushNotificationServiceType {
    // 권한추가 메서드
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    // 알림 추가
    func settingPushNotification()
}

class PushNotificationService: NSObject, PushNotificationServiceType {
    
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
                print("🔔 DEBUG: Push Notification ERROR \(error.localizedDescription)")
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
        
        print("⏰⏰ 유저의 최근 값 \(userLastAccessedDate)")
        print("⏰⏰ 유저의 최근 값 \(todayDate)")
        
        return components.day ?? 1000000
    }
    
    // 알람 조건 세팅
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

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
    private var userAlarmSetting = UserDefaults.standard.bool(forKey: "userAlarmSetting") // 알람 세팅 유무 확인
    private var alarmCount = UserDefaults.standard.integer(forKey: "alarmCount") // 알람 카운팅
    
    // 오늘 날짜
    let todayDate: String
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    let todayWeek: String
    let weekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    let dayOfWeekMapping: [String: Int] = [
        "일요일": 1,
        "월요일": 2,
        "화요일": 3,
        "수요일": 4,
        "목요일": 5,
        "금요일": 6,
        "토요일": 7
    ]
    
    var weekday: Int {
        guard let weekday = dayOfWeekMapping[todayWeek] else {
            // 매칭값 없으면 무조건 일요일
            return 1
        }
        return weekday
    }
    
    override init() {
        self.todayDate = dateFormatter.string(from: Date())
        self.todayWeek = weekFormatter.string(from: Date())
    }
    
    /// 실질적인 알림 세팅 함수
    func settingPushNotification() {
        print("⏰ setting값: \(userAlarmSetting)")
        // setting = true 라면 유저의 알람상태는 이미 세팅되어 있는 상태임!!
        
//        if !userAlarmSetting {
            // 이렇게 분기처리를 해주지 않으면 앱을 껐다 킬때마다 알람이 누적돼서 쌓이기 때문에 최조 시점때 bool 타입을 변경하여 처리해놓음
            settingNotification(alarmInfo: AlarmInfo(weekday: weekday,
                                                     hour: 0,
                                                     minute: 1))
            
//            print("⏰ 알람 세팅함수 실행완료")
//            UserDefaults.standard.set(true, forKey: "userAlarmSetting")
//        }
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
    
    // 알람 생성 - 3일 이상일 경우 랜덤 문구로 한번씩 보내기, 10번 이상 보냈는데 미 접속시 알람 그만 보내기
    func settingNotification(alarmInfo: AlarmInfo) {
        if self.checkUserAccessDate() >= 1 { 
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.weekday = alarmInfo.weekday
            dateComponents.hour = alarmInfo.hour
            dateComponents.minute = alarmInfo.minute
            
            let content = UNMutableNotificationContent()
            content.title = alarmInfo.title
            content.subtitle = alarmInfo.subtitle
            content.sound = UNNotificationSound.default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("⏰ ALARM DEBUG: 디폴트 알람 생성 완료!")
                
                // MARK: - 알람 카운팅하기
                self.alarmCount = self.alarmCount + 1
                UserDefaults.standard.set(self.alarmCount, forKey: "alarmCount")
                print("⏰ ALARM DEBUG: 알림 카운트 + 1 완료!")
            }
        }
    }
}

// 프리뷰용
class StubPushNotificationService: PushNotificationServiceType {
    func settingPushNotification() { }
    func requestAuthorization(completion: @escaping (Bool) -> Void) { }
}

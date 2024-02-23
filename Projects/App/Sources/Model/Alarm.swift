//
//  Alarm.swift
//  SYM
//
//  Created by 박서연 on 2024/02/23.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

// local PushNotification을 위한 데이터
struct AlarmInfo: Hashable {
    lazy var alarmInitTime: String = dateFormatter.string(from: Date())
    let weekday: Int
    let hour: Int
    let minute : Int
    let title: String = "마음을 기록한지 \(PushNotificationService().checkUserAccessDate())일 이 지났어요"
    let subtitle: String = subTitleList.randomElement() ?? "시미를 확인해주세요!"
    let body: String = bodyList.randomElement() ?? "오늘 하루를 기록해보는건 어떤가요?"
    
    static let TitleList = ["Title First1", "Title First2", "Title First3", "Title First4"]
    static let subTitleList = ["subTitleList1", "subTitleList2", "subTitleList3", "subTitleList4"]
    static let bodyList = ["body1", "body2", "body3", "body4"]
        
    static let sampleAlarm = [AlarmInfo(weekday: 6, hour: 21, minute: 00),
                              AlarmInfo(weekday: 4, hour: 22, minute: 00),
                              AlarmInfo(weekday: 1, hour: 14, minute: 00),
                              AlarmInfo(weekday: 2, hour: 16, minute: 00)]
    
    // 알람 데이터 생성시 날짜까지 같이 저장
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
}

// 날짜 지정하기
//struct AlarmInfo: Hashable {
//    var alarmInitTime: String {
//        dateFormatter.string(from: Date())
//    }
//    
//    var alarmInitWeek: String {
//        weekDateFormatter.string(from: Date())
//    }
//    
//    // Define a mapping from day of the week to weekday number
//    let dayOfWeekMapping: [String: Int] = [
//        "Sunday": 1,
//        "Monday": 2,
//        "Tuesday": 3,
//        "Wednesday": 4,
//        "Thursday": 5,
//        "Friday": 6,
//        "Saturday": 7
//    ]
//    
//    var weekday: Int {
//        guard let weekday = dayOfWeekMapping[alarmInitWeek] else {
//            // 매칭값 없으면 무조건 일요일
//            return 1
//        }
//        return weekday
//    }
//    
//    let hour: Int
//    let minute: Int
//    let title: String
//    let subtitle: String
//    let body: String
//    
//    static let TitleList = ["Title First1", "Title First2", "Title First3", "Title First4"]
//    static let subTitleList = ["subTitleList1", "subTitleList2", "subTitleList3", "subTitleList4"]
//    static let bodyList = ["body1", "body2", "body3", "body4"]
//    
//    static let firdayAlarm = AlarmInfo(weekday: 6, hour: 23, minute: 19,
//                                       title: "시미에 방문한지 \(PushNotificationService().checkUserAccessDate())일이 지났어요!",
//                                       subtitle: subTitleList.randomElement() ?? "시미를 확인해주세요!",
//                                       body: bodyList.randomElement() ?? "오늘 하루는 어땠나요?")
//    
//    static let SaturdayAlarm = AlarmInfo(weekday: 7, hour: 23, minute: 20,
//                                         title: "시미에 방문한지 \(PushNotificationService().checkUserAccessDate())일이 지났어요!",
//                                         subtitle: subTitleList.randomElement() ?? "시미를 확인해주세요!",
//                                         body: bodyList.randomElement() ?? "오늘 하루는 어땠나요?")
//    
//    static let sampleAlarm = [
//        AlarmInfo(weekday: 7, hour: 21, minute: 00, title: "랜덤1", subtitle: "", body: ""),
//        AlarmInfo(weekday: 4, hour: 22, minute: 00, title: "", subtitle: "", body: ""),
//        AlarmInfo(weekday: 2, hour: 14, minute: 00, title: "", subtitle: "", body: ""),
//        AlarmInfo(weekday: 3, hour: 16, minute: 00, title: "", subtitle: "", body: "")
//    ]
//    
//    // When creating alarm data, save it by date
//    let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        return formatter
//    }()
//    
//    let weekDateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE"
//        return formatter
//    }()
//    
//    init(weekday: Int, hour: Int, minute: Int, title: String, subtitle: String, body: String) {
//        self.hour = hour
//        self.minute = minute
//        self.title = title
//        self.subtitle = subtitle
//        self.body = body
//    }
//}

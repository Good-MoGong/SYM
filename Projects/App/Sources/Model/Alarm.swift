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
    
    // 나중에 랜덤 데이터 들어갈 자리
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

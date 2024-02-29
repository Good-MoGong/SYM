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
    
    let title: String = "오늘 하루 어떤 감정을 느끼셨나요?"// "마음을 기록한지 \(PushNotificationService().checkUserAccessDate())일 이 지났어요"
    let subtitle: String = subTitleList.randomElement() ?? "오늘의 감정을 기록하고 내일의 나를 발견해보세요"
    // let body: String = bodyList.randomElement() ?? "오늘 하루를 기록해보는건 어떤가요?"
    
    // 나중에 랜덤 데이터 들어갈 자리
    static let TitleList = ["Title First1", "Title First2", "Title First3", "Title First4"]
    
    static let subTitleList = ["오늘의 감정을 기록하고 내일의 나를 발견해보세요",
                               "어떤 감정이든 공유해주세요. 함께할 때 더 의미 있어요!",
                               "시미는 언제든지 기록을 시작할 준비가 되어있어요!",
                               "subTitleList4"]
    
    // static let bodyList = ["body1", "body2", "body3", "body4"]
        
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

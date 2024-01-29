//
//  DateExtension.swift
//  SYM
//
//  Created by 안지영 on 1/29/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

extension Date {
    // 현재 월의 날짜를 Date 배열로 만들어주는 함수
    func getAllDates() -> [Date] {
        // 현재날짜 캘린더 가져오는거
        let calendar = Calendar.current
        // 현재 월의 첫 날(startDate) 구하기 -> 일자를 지정하지 않고 year와 month만 구하기 때문에 그 해, 그 달의 첫날을 이렇게 구할 수 있음
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        // 현재 월(해당 월)의 일자 범위(날짜 수 가져오는거)
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        // range의 각각의 날짜(day)를 Date로 맵핑해서 배열로!!
        return range.compactMap { day -> Date in
            // to: (현재 날짜, 일자)에 day를 더해서 새로운 날짜를 만듦
            calendar.date(byAdding: .day, value: day - 1, to: startDate) ?? Date()
        }
    }
}

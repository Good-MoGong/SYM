//
//  CalendarRecordView.swift
//  SYM
//
//  Created by 안지영 on 3/4/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import DesignSystem

enum RecordViewText {
    case beforeRecord
    case afterRecord
    case noRecord
    
    var stringValue: String {
        switch self {
        case .beforeRecord:
            "감정 일기가 기록되지 않았어요\n시미가 당신을 기다리고 있어요!"
        case .afterRecord:
            "꾸준한 감정일기는 자신을 단단히\n만들어준답니다! 내일도 와주실거죠?"
        case .noRecord:
            "감정을 기록하지 않은 날이라\n볼 수 있는 일기가 존재하지 않아요"
        }
    }
}

struct CalendarRecordView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    /// 기록 전, 후를 bool로 구분
    var existRecord: Bool
    
    /// 해당 날짜가 오늘인지 아닌지
    var isDateInToday: Bool {
        Calendar.current.isDateInToday(calendarViewModel.selectDate)
    }
    /// 해당 날짜가 어제인지 아닌지
    var isDateInYesterday: Bool {
        Calendar.current.isDateInYesterday(calendarViewModel.selectDate)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(existRecord ? "감정 일기 작성 완료!" : (
                    isDateInToday ? "오늘의 기록" : (
                        isDateInYesterday ? "어제의 기록" : "기록이 없는 날이에요!")))
                .font(.bold(16))
                
                Text(existRecord ? RecordViewText.afterRecord.stringValue : (isTodayOrYesterday(date: calendarViewModel.selectDate) ?
                                                                             RecordViewText.beforeRecord.stringValue : RecordViewText.noRecord.stringValue))
                .lineSpacing(5)
                .font(.medium(13))
                .padding(.vertical, 5)
                
                if existRecord == true {
                    // 기록이 있을 경우
                    Button {
                        calendarViewModel.recordDiary.date = calendarViewModel.selectDate.formatToString()
                        calendarViewModel.recordSpecificFetch()
                        calendarViewModel.isShowingOrganizeView = true
                    } label: {
                        Text("기록 보러가기")
                            .font(.bold(16))
                            .padding(.vertical, -5)
                    }
                    .buttonStyle(CustomButtonStyle(MainButtonStyle(isButtonEnabled: true)))
                } else if isTodayOrYesterday(date: calendarViewModel.selectDate) {
                    // 기록이 없고, 날짜가 오늘 또는 어제인 경우
                    Button {
                        calendarViewModel.isShowingRecordView = true
                    } label: {
                        Text("감정 기록하기")
                            .font(.bold(16))
                            .padding(.vertical, -5)
                    }
                    .buttonStyle(CustomButtonStyle(MainButtonStyle(isButtonEnabled: true)))
                }
            }
            Spacer()
            
            // 기록 있으면
            Image(existRecord ? "SimiSparkle" : "SimiMain")
                .resizable()
                .scaledToFit()
                .frame(width: .symWidth * 0.28, height: .symWidth * 0.28)
        
        }
        .frame(width: .symWidth * 0.8)
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.bright)
        )
    }
    
    /// 해당 날짜가 오늘 or 어제인지 아닌지 확인하는 함수
    func isTodayOrYesterday(date: Date?) -> Bool {
        guard let date = date else { return false }
        let today = Calendar.current.isDateInToday(date)
        let yesterday = Calendar.current.isDateInYesterday(date)
        return today || yesterday
    }
}

#Preview {
    CalendarRecordView(calendarViewModel: CalendarViewModel(calendarUseCase: CalendarUseCase(calendarRepository: CalendarRepository())), existRecord: true)
}

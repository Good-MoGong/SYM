//
//  RecordView.swift
//  SYM
//
//  Created by 변상필 on 1/29/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

enum RecordViewText {
    case beforeRecord
    case afterRecord
    case noRecord
    case mypageRecord(count: Int)
    
    var stringValue: String {
        switch self {
        case .beforeRecord:
            "감정 일기가 기록되지 않았어요\n시미가 당신을 기다리고 있어요!"
        case .afterRecord:
            "꾸준한 감정일기는 자신을 단단히\n 만들어준답니다! 내일도 와주실거죠?"
        case .noRecord:
            "감정을 기록하지 않은 날이에요.\n오늘은 시미와 감정을 기록해볼까요?"
        case let .mypageRecord(count):
            "\(count)개의 감정기록이 담겨있네요!\n시미가 당신의 의견을 기다리고 있어요"
        }
    }
}

struct RecordView: View {
    /// mainView에서 쓰이는지, mypage에서 쓰이는지
    var isShowingMainView: Bool = true
    /// 기록 전, 후를 bool로 구분
    var existRecord: Bool?
    var recordCount: Int = 0
    
    @State private var isShowingCompleteRecordView: Bool = false
    @State private var isShowingRecordView: Bool = false
    @State private var nickname: String = UserDefaultsKeys.nickname
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var selectDate: Date?
    var yesterday: Bool {
        Calendar.current.isDate(selectDate ?? Date(), inSameDayAs: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if isShowingMainView {
                    Text(existRecord ?? false ? "감정 일기 작성 완료!" : (
                        selectDate == Date() ? "오늘의 기록" : (
                            yesterday ? "어제의 기록" : "기록이 없어요!")))
                    .font(PretendardFont.h4Bold)
                    .padding(.bottom, 12)
                } else {
                    NavigationLink {
                        MyAccountInfo()
                    } label: {
                        HStack {
                            Text("\(nickname)님")
                                .font(PretendardFont.h4Bold)
                            Image(systemName: "chevron.right")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 12)
                }
                
                VStack(alignment: .leading) {
                    Text(isShowingMainView ? (existRecord ?? false ?
                                              RecordViewText.afterRecord.stringValue : RecordViewText.beforeRecord.stringValue
                                             ) :
                            RecordViewText.mypageRecord(count: recordCount).stringValue)
                }
                .lineSpacing(8)
                .font(PretendardFont.bodyMedium)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.bottom, 12)
                Button {
                    if isShowingMainView && existRecord == false {
                        isShowingRecordView = true
                        print(isShowingRecordView)
                    } else if isShowingMainView && existRecord == true {
                        isShowingCompleteRecordView = true
                        print(isShowingCompleteRecordView)
                    }
                } label: {
                    Text(isShowingMainView ? (existRecord ?? false ? "기록 보러가기" : "감정 기록하기") : "시미에게 의견 보내기")
                        .font(isShowingMainView ? PretendardFont.h4Bold : PretendardFont.h5Medium)
                        .padding(.vertical, isShowingMainView ? -5 : 5)
                }
                .buttonStyle(isShowingMainView ? CustomButtonStyle(MainButtonStyle(isButtonEnabled: true)) : CustomButtonStyle(SubPinkButtonStyle()))
            }
            .navigationDestination(isPresented: $isShowingRecordView) {
                RecordStartView(isShowingOrganizeView: $isShowingRecordView)
            }
            .navigationDestination(isPresented: $isShowingCompleteRecordView) {
                RecordOrganizeView(organizeViewModel: calendarViewModel, isShowingOrganizeView: $isShowingCompleteRecordView)
            }
            
            Spacer()
            
            // 기록 있으면
            if existRecord ?? false {
                Image("SimiSmile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .symWidth * 0.3)
                
            } else {
                // 기록 없으면
                Image("SimiSad")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .symWidth * 0.3)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.bright)
        )
    }
}

#Preview {
    RecordView(existRecord: true, calendarViewModel: CalendarViewModel(calendarUseCase: CalendarUseCase(calendarRepository: CalendarRepository())), selectDate: Date())
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}

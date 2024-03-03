//
//  RecordView.swift
//  SYM
//
//  Created by 변상필 on 1/29/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

enum RecordViewText {
    case beforeRecordPast
    case beforeRecordToday
    case afterRecord
    case mypageRecord(count: Int)
    
    var stringValue: String {
        switch self {
        case .beforeRecordPast:
            "감정을 기록하지 않은 날이에요.\n오늘은 시미와 감정을 기록해 볼까요?"
        case .beforeRecordToday:
            "오늘의 감정이 기록되지 않았어요\n시미가 당신을 기다리고 있어요!"
        case .afterRecord:
            "꾸준한 감정일기는 자신을 단단히\n만들어준답니다! 내일도 와주실거죠?"
        case let .mypageRecord(count):
            "\(count)개의 감정기록이 담겨있네요!\n시미가 당신의 의견을 기다리고 있어요"
        }
    }
}

struct RecordView: View {
    /// mainView에서 쓰이는지, mypage에서 쓰이는지
    var isShowingMainView: Bool = true
    /// 기록 전, 후를 bool로 구분
    var beforeRecord: Bool?
    /// 감정이 기록되지 않았을 때 (과거, 오늘)
    var isRecordPast: Bool?
    var recordCount: Int = 0
    
    @State private var isShowingRecordView: Bool = false
    @State private var isShowingOrganizeView: Bool = false
    @State private var nickname: String = UserDefaultsKeys.nickname
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(titleText)
                    .font(.bold(18))
                    .padding(.bottom, 12)
                
                Text(contentText)
                    .lineSpacing(8)
                    .font(.medium(14))
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.bottom, 12)
                
                if isRecordPast ?? true {
                    Button {
                        if isShowingMainView && beforeRecord ?? true {
                            isShowingRecordView = true
                        } else {
                            isShowingOrganizeView = true
                            
                        }
                    } label: {
                        Text(actionButtonText)
                            .font(isShowingMainView ? PretendardFont.h4Bold : PretendardFont.h5Medium)
                            .padding(.vertical, isShowingMainView ? -5 : 5)
                    }
                    .buttonStyle(isShowingMainView ? CustomButtonStyle(MainButtonStyle(isButtonEnabled: true)) : CustomButtonStyle(SubPinkButtonStyle()))
                    .navigationDestination(isPresented: $isShowingRecordView) {
                        RecordStartView(isShowingOrganizeView: $isShowingRecordView)
                    }
                }
            }
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .symWidth * 0.3)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.bright)
        )
    }
    
    private var titleText: String {
        if isShowingMainView {
            if let beforeRecord = beforeRecord {
                return beforeRecord ? "기록이 없어요!" : "오늘의 기록"
            } else {
                return "감정일기 작성 완료"
            }
        } else {
            return "\(nickname)님"
        }
    }
    
    private var contentText: String {
        if isShowingMainView {
            if beforeRecord == true {
                if let isRecordPast = isRecordPast {
                    return !isRecordPast ? RecordViewText.beforeRecordPast.stringValue : RecordViewText.beforeRecordToday.stringValue
                } else {
                    return ""
                }
            } else {
                return RecordViewText.afterRecord.stringValue
            }
        } else {
            return RecordViewText.mypageRecord(count: recordCount).stringValue
        }
    }
    
    private var actionButtonText: String {
        if isShowingMainView {
            return beforeRecord ?? false ? "감정 기록하기" : "기록 보러가기"
        } else {
            return "시미에게 의견 보내기"
        }
    }
    
    private var imageName: String {
        return beforeRecord ?? false ? "SimiSad" : "SimiSmile"
    }
}

#Preview {
    RecordView(beforeRecord: true, isRecordPast: true)
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}

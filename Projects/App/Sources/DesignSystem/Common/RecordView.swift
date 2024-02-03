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
    case mypageRecord(count: Int)
    
    var stringValue: String {
        switch self {
        case .beforeRecord:
            "오늘의 감정이 기록되지 않았어요\n시미가 당신을 기다리고 있어요!"
        case .afterRecord:
            "꾸준한 감정일기는 자신을 단단히 만들어준답니다! 내일도 와주실거죠?"
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
    var nickname: String = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if isShowingMainView {
                    Text("오늘의 기록")
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
                    if isShowingMainView {
                        if beforeRecord ?? false {
                            Text("오늘의 감정이 기록되지 않았어요\n시미가 당신을 기다리고 있어요!")
                        } else {
                            Text("오늘의 감정을 기록했어요\n시미가 기뻐하고 있어요!")
                        }
                    } else {
                        Text("\(10)개의 감정기록이 담겨있네요!\n시미가 당신의 의견을 기다리고 있어요")
                    }
                }
                .lineSpacing(8)
                .font(PretendardFont.smallMedium)
                .padding(.bottom, 12)
                
                if isShowingMainView {
                    Button {
                        if beforeRecord ?? false {
                            print("기록하기")
                        } else {
                            print("보러가기")
                        }
                    } label: {
                        if beforeRecord ?? false {
                            Text("감정 기록하기")
                        } else {
                            Text("기록 보러가기")
                        }
                    }
                    .buttonStyle(MainButtonStyle(isButtonEnabled: true))
                } else {
                    Button {
                        print("의견 보내기")
                    } label: {
                        Text("시미에게 의견 보내기")
                            .font(PretendardFont.h5Medium)
                    }
                    .buttonStyle(SubPinkButtonStyle())
                }
            }
            .padding(.trailing, 23)
            
            Spacer()
            
            Image("Sample")
                .resizable()
                .frame(width: 100, height: 100)
                .scaledToFill()
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
    RecordView(beforeRecord: true)
}

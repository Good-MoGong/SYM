//
//  RecordDemo.swift
//  SYM
//
//  Created by 박서연 on 2024/01/04.
//  Copyright © 2023 Mogong. All rights reserved.
//

// Demo
import SwiftUI

struct RecordDemo: View {
    
    private let recordViewModel: RecordViewModel = RecordViewModel(recordUseCase: RecordUseCase(recordRepository: RecordRepository()))
    @State private var isShowingRecordView = false
    @State private var isShowingValidatePopup = false
    var body: some View {
        NavigationStack {
            VStack {
                Button("기록하기") {
                    isShowingRecordView = recordViewModel.validateRecord()
                    isShowingValidatePopup = !isShowingRecordView
                }
            }
            .navigationDestination(isPresented: $isShowingRecordView) {
                RecordStartView(isShowingRecordView: $isShowingRecordView)
            }
        }
        .popup(isShowing: $isShowingValidatePopup,
               type: .doubleButton(leftTitle: "새로 쓸래!", rightTitle: "괜찮아"),
               title: "이미 오늘 일기를 작성했어요",
               boldDesc: "일기는 하루에 한번만 작성 가능해요. 일기를 새로 작성할까요?",
               desc: "") {
            isShowingValidatePopup.toggle()
        } cancelHandler: {
            isShowingValidatePopup.toggle()
        }
    }
}

#Preview {
    RecordDemo()
}


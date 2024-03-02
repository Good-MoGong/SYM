//
//  RecordOrganizeView.swift
//  SYM
//
//  Created by 전민돌 on 1/27/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct RecordOrganizeView<viewModel: RecordConditionFetch>: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var organizeViewModel: viewModel
    @Binding var isShowingOrganizeView: Bool
    
    var body: some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.plain)
                .padding()
                Spacer()
                
                
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            
            HStack {
                Spacer()
                
                Text("\(organizeViewModel.recordDiary.date) 일기")
                    .font(PretendardFont.h4Medium)
                
                Spacer()
            }
        }
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Spacer(minLength: 33)
                
                Text("나의 감정")
                    .font(PretendardFont.h4Bold)
                    .padding(.leading, 20)
                    .padding(.bottom, -10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: Array(repeating: GridItem(), count: 1)) {
                        ForEach(organizeViewModel.recordDiary.emotions, id: \.self) { feeling in
                            Text(feeling)
                                .setTextBackground(.brightWithStroke)
                                .padding(.horizontal, 2)
                        }
                    }
                    .padding(.leading, 2)
                    .padding()
                }
                .padding(.bottom, 15)
                
                Text("나의 기록")
                    .font(PretendardFont.h4Bold)
                    .padding(.leading, 20)
                    .padding(.bottom, 7)
                
                ZStack {
                    Text(organizeViewModel.recordDiary.event) // 추후에 실제 기록으로 변경 필요
                        .setTextBackground(.sentenceField)
                    
                    isResolutionSentenceTitle(title: "사건")
                }
                .padding(.horizontal, 20)
                
                ZStack {
                    Text(organizeViewModel.recordDiary.idea) // 추후에 실제 기록으로 변경 필요
                        .setTextBackground(.sentenceField)
                    
                    isResolutionSentenceTitle(title: "생각")
                }
                .padding(.horizontal, 20)
                
                ZStack {
                    Text(organizeViewModel.recordDiary.action) // 추후에 실제 기록으로 변경 필요
                        .setTextBackground(.sentenceField)
                    
                    isResolutionSentenceTitle(title: "행동")
                }
                .padding(.horizontal, 20)
                
                ZStack {
                    Text(organizeViewModel.recordDiary.gptAnswer) // 추후에 실제 기록으로 변경 필요
                        .setTextBackground(.sentenceField)
                    
                    isResolutionSentenceTitle(title: "시미의 공감")
                }
                .padding(.horizontal, 20)
                
                Button("완료") {
                    isShowingOrganizeView = false
                }
                .buttonStyle(MainButtonStyle(isButtonEnabled: true))
                .padding(.horizontal, 20)
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    let screenSize = UIScreen.main.bounds.size.width
    
    func isResolutionSentenceTitle(title: String) -> some View {
        if screenSize == 375 { // 4.7, 5.8 inches
            return Text(title)
                .setTextBackground(.sentenceTitle)
                .padding(.trailing, 190)
                .padding(.bottom, 215)
        } else if screenSize == 414 { // 5.5, LCD 6.1, 6.5 inches
            return Text(title)
                .setTextBackground(.sentenceTitle)
                .padding(.trailing, 215)
                .padding(.bottom, 215)
        } else if screenSize == 390 || screenSize == 393 { // OLED 6.1 inches
            return Text(title)
                .setTextBackground(.sentenceTitle)
                .padding(.trailing, 200)
                .padding(.bottom, 215)
        } else if screenSize == 428 || screenSize == 430 { // 6.7 inches
            return Text(title)
                .setTextBackground(.sentenceTitle)
                .padding(.trailing, 210)
                .padding(.bottom, 215)
        } else { // mini model
            return Text(title)
                .setTextBackground(.sentenceTitle)
                .padding(.trailing, 165)
                .padding(.bottom, 230)
        }
    }
}

#Preview {
    RecordOrganizeView(organizeViewModel: RecordViewModel(recordUseCase: RecordUseCase(recordRepository: RecordRepository())), isShowingOrganizeView: .constant(false))
}

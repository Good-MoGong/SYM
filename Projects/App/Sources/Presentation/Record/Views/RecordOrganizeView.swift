//
//  RecordOrganizeView.swift
//  SYM
//
//  Created by 전민돌 on 1/27/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI
import DesignSystem

struct RecordOrganizeView<viewModel: RecordConditionFetch>: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var organizeViewModel: viewModel
    @Binding var isShowingOrganizeView: Bool
    @State var editToggle = false
    @State var availablePopup = false
    @State var popupToggle = false
    @State var updateDiary: Diary = .init(date: "", event: "", idea: "", emotions: [], action: "", gptAnswer: "")
    
    var body: some View {
        if editToggle == false {
            organizeView
                .customNavigationBar(centerView: {
                            Text("\(organizeViewModel.recordDiary.date) 일기")
                        .font(.medium(17))
                        }, rightView: {
                            EmptyView()
                        }, isShowingBackButton: true, availablePopup: $availablePopup, popupToggle: $popupToggle)
        } else {
            organizeView
                .customNavigationBar(centerView: {
                            Text("\(organizeViewModel.recordDiary.date) 일기")
                        .font(.medium(17))
                        }, rightView: {
                            EmptyView()
                        }, isShowingBackButton: true, availablePopup: $availablePopup, popupToggle: $popupToggle)
                .popup(isShowing: $popupToggle, type: .doubleButton(leftTitle: "중단하기", rightTitle: "이어쓰기"), title: "편집을 중단할까요?", desc: "편집을 중단하시면 지금까지\n수정한 내용이 모두 삭제돼요.", confirmHandler: { editToggle = false
                    popupToggle = false
                    availablePopup = false }, cancelHandler: { popupToggle = false })
        }
    }
    
    var organizeView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Spacer(minLength: 33)
                
                Text("나의 감정")
                    .font(.bold(18))
                    .padding(.leading, 20)
                    .padding(.bottom, -10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: Array(repeating: GridItem(), count: 1)) {
                        ForEach(organizeViewModel.recordDiary.emotions, id: \.self) { feeling in
                            Text(feeling)
                                .setTextBackground(.brightWithStroke)
                                .padding(.horizontal, 2)
                                .font(.medium(16))
                        }
                    }
                    .padding(.leading, 2)
                    .padding()
                }
                .padding(.bottom, 15)
                
                HStack {
                    Text("나의 기록")
                        .font(.bold(18))
                    
                    Spacer()
                    
                    Button {
                        bindingText()
                        editToggle = true
                        availablePopup = true
                    } label: {
                        if editToggle == false {
                            Text("편집")
                                .font(.bold(18))
                                .foregroundColor(Color.symGray3)
                        } else {
                            Text("")
                                .disabled(true)
                        }
                    }
                }
                .padding(.bottom, 7)
                .padding(.horizontal, 20)
                
                if editToggle == false {
                    ZStack {
                        Text(organizeViewModel.recordDiary.event)
                            .setTextBackground(.sentenceField)
                        
                        isResolutionSentenceTitle(title: "사건")
                    }
                    .padding(.horizontal, 20)
                    
                    ZStack {
                        Text(organizeViewModel.recordDiary.idea)
                            .setTextBackground(.sentenceField)
                        
                        isResolutionSentenceTitle(title: "생각")
                    }
                    .padding(.horizontal, 20)
                    
                    ZStack {
                        Text(organizeViewModel.recordDiary.action)
                            .setTextBackground(.sentenceField)
                        
                        isResolutionSentenceTitle(title: "행동")
                    }
                    .padding(.horizontal, 20)
                    
                    ZStack {
                        Text(organizeViewModel.recordDiary.gptAnswer)
                            .setTextBackground(.sentenceField)
                        
                        isResolutionSentenceTitle(title: "시미의 공감")
                    }
                    .padding(.horizontal, 20)
                } else {
                    ZStack {
                        TextEditor(text: $updateDiary.event)
                            .customStyle2(userInput: $updateDiary.event)
                            .frame(maxHeight: 214)
                        
                        isResolutionSentenceTitle(title: "사건")
                    }
                    .padding(.horizontal, 20)
                    
                    ZStack {
                        TextEditor(text: $updateDiary.idea)
                            .customStyle2(userInput: $updateDiary.idea)
                            .frame(maxHeight: 214)
                        
                        isResolutionSentenceTitle(title: "생각")
                    }
                    .padding(.horizontal, 20)
                    
                    ZStack {
                        TextEditor(text: $updateDiary.action)
                            .customStyle2(userInput: $updateDiary.action)
                            .frame(maxHeight: 214)
                        
                        isResolutionSentenceTitle(title: "행동")
                    }
                    .padding(.horizontal, 20)
                    
                    ZStack {
                        TextEditor(text: $updateDiary.gptAnswer)
                            .customStyle3(userInput: $updateDiary.gptAnswer)
                            .frame(maxHeight: 214)
                            .disabled(true)
                        
                        isResolutionSentenceTitle(title: "시미의 공감")
                    }
                    .padding(.horizontal, 20)
                }
                
                if editToggle == false {
                    Button("완료") {
                        isShowingOrganizeView = false
                    }
                    .buttonStyle(MainButtonStyle(isButtonEnabled: true))
                    .padding(.horizontal, 20)
                } else {
                    Button("수정완료") {
                        organizeViewModel.updateRecord(updateDiary: updateDiary)
                        editToggle = false
                        availablePopup = false
                    }
                    .buttonStyle(MainButtonStyle(isButtonEnabled: true))
                    .padding(.horizontal, 20)
                }
            }
        }
        .dismissKeyboardOnTap()
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
    
    func bindingText() {
        updateDiary.event = organizeViewModel.recordDiary.event
        updateDiary.idea = organizeViewModel.recordDiary.idea
        updateDiary.action = organizeViewModel.recordDiary.action
        updateDiary.gptAnswer = organizeViewModel.recordDiary.gptAnswer
    }
}

#Preview {
    RecordOrganizeView(organizeViewModel: RecordViewModel(recordUseCase: RecordUseCase(recordRepository: RecordRepository())), isShowingOrganizeView: .constant(false))
}

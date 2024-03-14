//
//  RecordView.swift
//  SYM
//
//  Created by 민근의 mac on 2/3/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI


struct RecordStartView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var recordViewModel: RecordViewModel = RecordViewModel(recordUseCase: RecordUseCase(recordRepository: RecordRepository()))
    @State private var isAppearAnimation: Bool = false
    @Binding var isShowingOrganizeView: Bool
    var selectDate: Date
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("RecordBackground")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        HStack {
                            Button {
                                recordViewModel.movePage(to: .previous)
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            .buttonStyle(.plain)
                            Spacer()
                            
                            Button {
                                recordViewModel.writeLater()
                            } label: {
                                Text("나중에 쓰기")
                                    .font(.medium(14))
                                    .foregroundColor(.symGray5)
                            }
                            .buttonStyle(.plain)
                        }
                        HStack {
                            Spacer()
                            
                            Text("감정일기")
                                .font(.medium(17))
                            
                            Spacer()
                        }
                    }
                    Spacer().frame(maxHeight: .symHeight * 0.02)
                    
                    HStack(spacing: 12) {
                        ForEach(RecordOrder.allCases, id: \.self) { index in // 1
                            Circle()
                                .fill(recordViewModel.recordOrder == index ? Color.main : Color.symGray2)
                                .frame(width: 8, height: 8)
                        }
                    }
                    Spacer().frame(maxHeight: .symHeight * 0.03)
                    
                    HStack {
                        Text(recordViewModel.recordOrder.symMent)
                            .font(.bold(20))
                        
                        Button {
                            recordViewModel.showGuide()
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.symGray3)
                        }
                        Spacer()
                    }
                    Spacer().frame(maxHeight: .symHeight * 0.01)
                    
                    if recordViewModel.recordOrder == .emotions {
                        HStack {
                            Text("감정단어는 최대 5개까지 선택할 수 있어요")
                                .font(.medium(12))
                            
                            Spacer()
                        }
                    }
                    Spacer().frame(maxHeight: .symHeight * 0.03)
                    
                    switch recordViewModel.recordOrder {
                    case .event, .idea, .action:
                        ScrollView {
                            Image("SimiCurious")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 100)
                            
                            Spacer().frame(height: 30)
                            
                            TextEditor(text: $recordViewModel.currentText)
                                .customStyle(placeholder: placeholderForRecordOrder(recordViewModel.recordOrder), userInput: $recordViewModel.currentText)
                                .frame(height: 200)
                            Spacer().frame(maxHeight: .symHeight * 0.03)
                        }
                        Button(recordViewModel.recordOrder == .action ? "기록하기" : "다음으로") {
                            recordViewModel.dismissKeyboard()
                            recordViewModel.movePage(to: .next)
                        }
                        .buttonStyle(MainButtonStyle(isButtonEnabled: !recordViewModel.currentText.isEmpty))
                        .disabled(recordViewModel.currentText.isEmpty)
                        
                    case .emotions:
                        Image("SimiWithJelly")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 100)
                        
                        Spacer().frame(height: 30)
                        
                        emotionSelectView
                            .frame(maxHeight: .infinity)
                        
                        Spacer().frame(maxHeight: .symHeight * 0.03)
                        Button("다음으로") {
                            recordViewModel.dismissKeyboard()
                            recordViewModel.movePage(to: .next)
                        }
                        .buttonStyle(MainButtonStyle(isButtonEnabled: !recordViewModel.selectedDatailEmotion.isEmpty))
                        .disabled(recordViewModel.selectedDatailEmotion.isEmpty)
                    }
                }
                .padding()
            }
        }
        .overlay(alignment: .center) {
            if recordViewModel.isGPTLoading {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    ProgressView(recordViewModel: recordViewModel)
                }
            }
        }
        .dismissKeyboardOnTap()
        .popup(isShowing: $recordViewModel.isShowingOutPopUp,
               type: .doubleButton(leftTitle: "그만두기", rightTitle: "이어쓰기"),
               title: PopupContent.stop.title,
               desc: PopupContent.stop.desc) {
            dismiss()
        } cancelHandler: {
            recordViewModel.isShowingOutPopUp.toggle()
        }
        .popup(isShowing: $recordViewModel.isShowingGuidePopUp, type: .guide(title: "닫기"),
               title: "[\(recordViewModel.recordOrder.rawValue)] 쓰기 꿀팁!",
               desc: "\(recordViewModel.recordOrder.guideMent)", confirmHandler: {
            
        }, cancelHandler: {
            recordViewModel.isShowingGuidePopUp.toggle()
        })
        .toastView(toast: $recordViewModel.isShowingToastMessage)
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $recordViewModel.isShowingCompletionView, content: {
            RecordCompletionView(recordViewModel: recordViewModel, isShowingOrganizeView: $isShowingOrganizeView)
        })
        .fullScreenCover(isPresented: $recordViewModel.isShowingSavePopUp, content: {
            RecordOrganizeView(organizeViewModel: recordViewModel, isShowingOrganizeView: $isShowingOrganizeView)
        })
        .onAppear {
            recordViewModel.recordDiary.date = selectDate.formatToString()
            recordViewModel.userID = authViewModel.userId ?? ""
            withAnimation {
                isAppearAnimation = true
                
            }
        }
    }
    
    func placeholderForRecordOrder(_ order: RecordOrder) -> String {
        switch order {
        case .event:
            return TextEditorContent.writtingDiary.rawValue
        case .idea:
            return TextEditorContent.writtingThink.rawValue
        case .action:
            return TextEditorContent.writtingAction.rawValue
        case .emotions:
            return ""
        }
    }
}

extension RecordStartView {
    @ViewBuilder
    private var emotionSelectView: some View {
        VStack {
            HStack {
                ForEach(EmotionType.allCases, id: \.self) { emotion in
                    VStack {
                        Rectangle()
                            .foregroundColor(Color.bright)
                            .frame(height: 8)
                        Button {
                            recordViewModel.selectEmotion(selected: emotion)
                            
                        } label: {
                            Text("\(emotion.rawValue)")
                                .font(.bold(18))
                                .foregroundColor(recordViewModel.selectedEmotion == emotion ? .main : .symGray4)
                        }
                        .foregroundColor(.primary)
                        
                        Capsule()
                            .foregroundColor(recordViewModel.selectedEmotion == emotion ? .main : .clear)
                            .frame(height: 5)
                    }
                }
            }
            .padding(.horizontal)
            .background(Color.bright)
            Spacer().frame(maxHeight: .symHeight * 0.02)
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                    ForEach(recordViewModel.selectedEmotion.detailEmotion, id: \.self) { item in
                        EmotionButton(
                            title: item,
                            isSelected: Binding(
                                get: { recordViewModel.selectedDatailEmotion.contains(item) },
                                set: { isSelected in
                                    if isSelected {
                                        _ = recordViewModel.selectedDatailEmotion(selected: item)
                                    } else {
                                        _ = recordViewModel.selectedDatailEmotion(selected: item)
                                    }
                                }
                            )
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.horizontal, -16)
    }
}

struct EmotionButton: View {
    var title: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Text(title)
                .font(.medium(16))
                .foregroundColor(isSelected ? .white : .black)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 11)
                .padding(.horizontal, 10)
                .padding(.vertical, 17)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.symGray2, lineWidth: 2)
                        .background(RoundedRectangle(cornerRadius: 30).fill(isSelected ? Color.sub : .white))
                )
        }
        .padding(4)
    }
}

#Preview {
    RecordStartView(isShowingOrganizeView: .constant(false), selectDate: Date())
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}

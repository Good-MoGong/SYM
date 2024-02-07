//
//  RecordView.swift
//  SYM
//
//  Created by 민근의 mac on 2/3/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI


struct RecordStartView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var recordViewModel: RecordViewModel = RecordViewModel()
    @Binding var isShowingRecordView: Bool
    var body: some View {
        NavigationStack {
            ZStack {
                Image("RecordBackground")
                    .resizable()
                    .ignoresSafeArea()
                VStack(spacing: .symHeight * 0.05) {
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
                                        .font(PretendardFont.bodyMedium)
                                        .foregroundColor(.symGray5)
                                }
                                .buttonStyle(.plain)
                            }
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            
                            HStack {
                                Spacer()
                                
                                Text("감정일기")
                                    .font(PretendardFont.h4Medium)
                                
                                Spacer()
                            }
                        }
                        HStack(spacing: 12) {
                            ForEach(RecordOrder.allCases, id: \.self) { index in // 1
                                Circle()
                                    .fill(recordViewModel.recordOrder == index ? Color.main : Color.symGray2)
                                    .frame(width: 8, height: 8)
                                   
                                   
                            }
                        }
                    }
                    HStack {
                        Text(recordViewModel.recordOrder.symMent)
                            .font(PretendardFont.h3Bold)
                            .overlay {
                                if recordViewModel.recordOrder == .emotions {
                                    HStack {
                                        Text("감정단어는 최대 5개까지 선택할 수 있어요")
                                            .font(PretendardFont.smallMedium)
                                            .offset(y: 25)
                                        Spacer()
                                    }
                                }
                            }
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.symGray3)
                        Spacer()
                    }
                    Image("Sample")
                    
                    switch recordViewModel.recordOrder {
                    case .event, .idea, .action:
                        TextEditor(text: $recordViewModel.currentText)
                            .customStyle(placeholder: TextEditorContent.writtingDiary.rawValue, userInput: $recordViewModel.currentText)
                            .frame(height: 200)
                        Spacer()
                        Button("다음으로") {
                            recordViewModel.movePage(to: .next)
                            
                        }
                        .buttonStyle(MainButtonStyle(isButtonEnabled: !recordViewModel.currentText.isEmpty))
                        .disabled(recordViewModel.currentText.isEmpty)
                    case .emotions:
                        emotionSelectView
                            .padding(-16)
                        Spacer()
                        Button("다음으로") {
                            recordViewModel.movePage(to: .next)
                        }
                        .buttonStyle(MainButtonStyle(isButtonEnabled: !recordViewModel.selectedDatailEmotion.1.isEmpty))
                        .disabled(recordViewModel.selectedDatailEmotion.1.isEmpty)
                    }
                }
                .padding()
            }
        }
        .popup(isShowing: $recordViewModel.isShowingOutPopUp,
               type: .doubleButton(leftTitle: "그만 쓸래", rightTitle: "다시 써볼게!"),
               title: "계속 일기를 작성할까요?",
               boldDesc: "잠깐! 여기서 그만두면 지금까지 작성한 글이 모두 사라져요. 정말 일기 작성을 그만 둘까요?",
               desc: "") {
            presentationMode.wrappedValue.dismiss()
        } cancelHandler: {
            recordViewModel.isShowingOutPopUp.toggle()
        }
        .navigationBarBackButtonHidden(true)
        .animation(.default)
        .fullScreenCover(isPresented: $recordViewModel.isShowingCompletionView, content: {
            RecordCompletionView(recordViewModel: recordViewModel, isShowingRecordView: $isShowingRecordView)
        })
    }
}

extension RecordStartView {
    @ViewBuilder
    private var emotionSelectView: some View {
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
                            .font(PretendardFont.h3Bold)
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
    }
}

#Preview {
    RecordStartView(isShowingRecordView: .constant(false))
}

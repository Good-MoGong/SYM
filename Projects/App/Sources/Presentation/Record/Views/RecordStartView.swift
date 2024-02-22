//
//  RecordView.swift
//  SYM
//
//  Created by 민근의 mac on 2/3/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI


struct RecordStartView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var recordViewModel: RecordViewModel = RecordViewModel(recordUseCase: RecordUseCase(recordRepository: RecordRepository()))
    @Binding var isShowingOrganizeView: Bool
    
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
                                    .font(PretendardFont.bodyMedium)
                                    .foregroundColor(.symGray5)
                            }
                            .buttonStyle(.plain)
                        }
                        HStack {
                            Spacer()
                            
                            Text("감정일기")
                                .font(PretendardFont.h4Medium)
                            
                            Spacer()
                        }
                    }
                    Spacer().frame(maxHeight: .symHeight * 0.03)
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
                            .font(PretendardFont.h3Bold)
                        
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.symGray3)
                        Spacer()
                    }
                    Spacer().frame(maxHeight: .symHeight * 0.01)
                    if recordViewModel.recordOrder == .emotions {
                        HStack {
                            Text("감정단어는 최대 5개까지 선택할 수 있어요")
                                .font(PretendardFont.smallMedium)
                            
                            Spacer()
                        }
                    }
                    Spacer().frame(maxHeight: .symHeight * 0.03)
                    switch recordViewModel.recordOrder {
                    case .event, .idea, .action:
                        Image("SimiSmile")
                            .resizable()
                            .frame(width: 200, height: 220)
                        TextEditor(text: $recordViewModel.currentText)
                            .customStyle(placeholder: TextEditorContent.writtingDiary.rawValue, userInput: $recordViewModel.currentText)
                            .frame(height: 200)
                        Spacer().frame(maxHeight: .symHeight * 0.03)
                            .frame(maxHeight: .infinity)
                        Button(recordViewModel.recordOrder == .action ? "기록하기" : "다음으로") {
                            recordViewModel.movePage(to: .next)
                        }
                        .buttonStyle(MainButtonStyle(isButtonEnabled: !recordViewModel.currentText.isEmpty))
                        .disabled(recordViewModel.currentText.isEmpty)
                    case .emotions:
                        Image("SimiCurious")
                            .resizable()
                            .frame(width: 200, height: 220)
                        emotionSelectView
                            .frame(maxHeight: .infinity)
                            .animation(nil)
                        Spacer().frame(maxHeight: .symHeight * 0.03)
                        Button("다음으로") {
                            recordViewModel.movePage(to: .next)
                        }
                        .buttonStyle(MainButtonStyle(isButtonEnabled: !recordViewModel.selectedDatailEmotion.isEmpty))
                        .disabled(recordViewModel.selectedDatailEmotion.isEmpty)
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
            dismiss()
        } cancelHandler: {
            recordViewModel.isShowingOutPopUp.toggle()
        }
        .toastView(toast: $recordViewModel.isShowingToastMessage)
        .navigationBarBackButtonHidden(true)
        .animation(.default)
        .fullScreenCover(isPresented: $recordViewModel.isShowingCompletionView, content: {
            RecordCompletionView(recordViewModel: recordViewModel, isShowingOrganizeView: $isShowingOrganizeView)
        })
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
                            withAnimation {
                                recordViewModel.selectEmotion(selected: emotion)
                            }
                            
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
                .font(PretendardFont.h5Medium)
                .foregroundColor(isSelected ? .white : .black)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 15)
                .padding(17)
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
    RecordStartView(isShowingOrganizeView: .constant(false))
}

//
//  RecordCompletionView.swift
//  SYM
//
//  Created by 민근의 mac on 2/3/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct RecordCompletionView: View {

    @ObservedObject var recordViewModel: RecordViewModel
    @State private var animatedMessage: String = ""
    @Binding var isShowingRecordView: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("RecordBackground")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    VStack(spacing: .symHeight * 0.05) {
                        ZStack {
                            HStack {
                                Button {
                                    isShowingRecordView = false
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .buttonStyle(.plain)
                                Spacer()
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
                        Text("기록이 완료되었어요!")
                            .font(PretendardFont.h3Bold)
                        Image("SimiSmile2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .symWidth * 0.6)
                    }
                    
                    VStack(alignment: .leading) {
                        if recordViewModel.gptAnswerText != "" {
                            ChatBubble(message: recordViewModel.gptAnswerText, animatedMessage: $animatedMessage)
                        } else {
                            ProgressView()
                        }
                    }
                    
                    Spacer()
                    HStack {
                        Button("홈") {
                            isShowingRecordView = false
                        }
                        // .buttonStyle에 적용
                        .buttonStyle(smallGrayButtonStyle())
                        // 버튼 사이 간격 20
                        .padding(.trailing, 20)
                        
                        Button("기록 보기") {
                            recordViewModel.recordSpecificFetch()
                        }
                        .buttonStyle(MainButtonStyle(isButtonEnabled: true))
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $recordViewModel.isShowingOrganizeView) {
                RecordOrganizeView(recordViewModel: recordViewModel, isShowingRecordView: $isShowingRecordView)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear(perform: {
            recordViewModel.makeGPTRequest()
            
        })
    }
}

#Preview {
    RecordCompletionView(recordViewModel: RecordViewModel(recordUseCase: RecordUseCase(recordRepository: RecordRepository())), isShowingRecordView: .constant(false))
}

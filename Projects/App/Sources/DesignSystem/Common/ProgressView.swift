//
//  ProgressView.swift
//  SYM
//
//  Created by 변상필 on 2/26/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct ProgressView: View { 
    
    @ObservedObject var recordViewModel: RecordViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Image("RecordLoading")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .offset(x: CGFloat(recordViewModel.progress) * (.symWidth * 0.65), y: 0)
                .animation(.linear(duration: 3.0), value: recordViewModel.progress) // 수정된 부분
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: .symWidth * 0.9, height: 20)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: CGFloat(recordViewModel.progress) * (.symWidth * 0.9), height: 20)
                    .foregroundColor(.main)
                    .animation(.linear(duration: 3.0), value: recordViewModel.progress) // 수정된 부분
            }
        
            HStack {
                Spacer()
                Text("시미 답장 기다리는중..")
                    .font(PretendardFont.h3Bold)
                    .foregroundStyle(Color.sub)
            }
            Spacer()
        }
        .padding()
    }
}



#Preview {
    ProgressView(recordViewModel: RecordViewModel(recordUseCase: RecordUseCase(recordRepository: RecordRepository())))
}

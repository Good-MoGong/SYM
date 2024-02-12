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
    @State private var isShowingRecordView = false
    var body: some View {
        NavigationStack {
            VStack {
                Button("기록하기") {
                    isShowingRecordView.toggle()
                }
            }
            .navigationDestination(isPresented: $isShowingRecordView) {
                RecordStartView(isShowingRecordView: $isShowingRecordView)
            }
        }
    }
}

#Preview {
    RecordDemo()
}


//
//  AlarmMainView.swift
//  SYM
//
//  Created by 박서연 on 2024/02/22.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

class AlarmMainViewModel: ObservableObject {
    @Published var currentTime: String = ""
    
    let currentFormatter = DateFormatter()
    
    init() {
        currentFormatter.dateFormat = "yyyy년 MM월 dd일"
        self.currentTime = currentFormatter.string(from: Date())
    }
}

struct AlarmMainView: View {
    @StateObject private var alarmViewModel = AlarmMainViewModel()
    
    var body: some View {
        VStack {
            Text("\(alarmViewModel.currentTime)")
            
            Text("이전 알림")
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AlarmMainView()
    }
}

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
        currentFormatter.dateFormat = "yyyy/MM/dd"
        self.currentTime = currentFormatter.string(from: Date())
    }
}

struct AlarmMainView: View {
    @StateObject private var alarmViewModel = AlarmMainViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("오늘")
            
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal, 20)
    }
}

#Preview {
    NavigationStack {
        AlarmMainView()
    }
}

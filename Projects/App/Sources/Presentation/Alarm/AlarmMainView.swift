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
    @State private var todayAlarm: [AlarmInfo] = []
    @State private var pastAlarm: [AlarmInfo] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("오늘")
            List(todayAlarm, id: \.self) { data in
                Text(data.subtitle)
            }
            .listStyle(.plain)
            
            Text("이전 알림")
            List(pastAlarm, id: \.self) { data in
                Text(data.subtitle)
            }
            .listStyle(.plain)
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.todayAlarm = AlarmInfo.sampleAlarm.filter { alarmInfo in
                var mutableAlarmInfo = alarmInfo
                return mutableAlarmInfo.alarmInitTime == alarmViewModel.currentTime
            }
            
            self.pastAlarm = AlarmInfo.sampleAlarm.filter { alarmInfo in
                var mutableAlarmInfo = alarmInfo
                return mutableAlarmInfo.alarmInitTime != alarmViewModel.currentTime
            }
        }
    }
}

#Preview {
    NavigationStack {
        AlarmMainView()
    }
}

//
//  CalendarMainView.swift
//  SYM
//
//  Created by 안지영 on 1/29/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct CalendarMainView: View {
    @State var currentDate: Date = Date()
    @State var selectDate: Date = Date()
    @State private var nickname: String = "모공모공"
    
    var body: some View {
        ScrollView {
            CalendarDetailView(nickname: $nickname, currentDate: $currentDate, selectDate: $selectDate)
                .padding(.vertical, 20)
            RecordView(beforeRecord: true, nickname: nickname)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    NavigationStack {
        CalendarMainView()
    }
}

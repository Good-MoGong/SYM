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
    
    var body: some View {
        ScrollView {
            CalendarDetailView(currentDate: $currentDate, selectDate: $selectDate)
                .padding(.vertical, 20)
        }
    }
}

#Preview {
    CalendarMainView()
}

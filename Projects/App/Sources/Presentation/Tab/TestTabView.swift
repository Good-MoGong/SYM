//
//  TestTabView.swift
//  SYM
//
//  Created by 박서연 on 2024/01/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

final class TabBarViewModel: ObservableObject {
    @Published var selected: MainTab = .home
}

struct TestTabView: View {
    @ObservedObject var tabBarViewModel: TabBarViewModel
    
    var body: some View {
        HStack {
            ForEach(MainTab.allCases) { item in
                Spacer()
                Button {
                    tabBarViewModel.selected = item
                } label: {
                    VStack(spacing: 8) {
                        Image(systemName: item.imageName)
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text(item.title)
                            .font(PretendardFont.smallMedium)
                    }.tint(tabBarViewModel.selected == item ? Color.gradient : Color.symGray3)
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.1)
        .background(
            Rectangle()
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .foregroundColor(Color.white)
        )
        .clipped()
        .shadow(
            color: .symGray2,
            radius: 7
        )
    }
}

#Preview {
    TestTabView(tabBarViewModel: TabBarViewModel())
}

extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

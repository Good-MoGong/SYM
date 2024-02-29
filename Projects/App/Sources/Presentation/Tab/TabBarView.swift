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

struct TabBarView: View {
    @ObservedObject var tabBarViewModel: TabBarViewModel
    
    var body: some View {
        HStack {
            ForEach(MainTab.allCases) { item in
                Spacer()
                
                Button {
                    tabBarViewModel.selected = item
                    print(item)
                } label: {
                    VStack(spacing: 4) {
                        Image("\(tabBarViewModel.selected == item ? "\(item.imageName)" : "\(item.imageName)Default")")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .tint(tabBarViewModel.selected == item ? Color.sub : Color.symGray3)
                        
                        Text(item.title)
                            .font(PretendardFont.smallMedium)
                            .tint(tabBarViewModel.selected == item ? Color.sub : Color.symGray3)
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(
            Rectangle()
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .foregroundColor(Color.white)
        )
        .clipped()
        .shadow(
            color: .symGray2,
            radius: 4,
            x: 0,
            y: -7
        )
    }
}

#Preview {
    TabBarView(tabBarViewModel: TabBarViewModel())
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

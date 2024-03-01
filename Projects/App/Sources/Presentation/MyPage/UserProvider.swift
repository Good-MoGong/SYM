//
//  UserProvider.swift
//  SYM
//
//  Created by 박서연 on 2024/03/01.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct UserProvider: View {
    let userEmail: String
    let providerType: String
    
    var body: some View {
        VStack {
            Text(userEmail)
                .foregroundColor(.symBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 20)
                .padding(.leading, 20)
                .background(Color.symGray1)
                .font(.medium(14))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(alignment: .trailing) {
                    Image(providerType == "Apple" ? "AppleLogo" : "KaKaoLogo")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(7)
                        .background(providerType == "Apple" ? Color.black : Color.kakao)
                        .clipShape(Circle())
                        .padding(.trailing, 15)
                }
            
        }.foregroundColor(.symBlack)
    }
}

#Preview {
    UserProvider(userEmail: "mogong2024@gmail.com", providerType: "KaKao")
}

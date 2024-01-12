//
//  Mypage.swift
//  SYM
//
//  Created by 변상필 on 1/12/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import SwiftUI

struct MypageView: View {
    var body: some View {
        NavigationStack {
            UserInfo()
                .padding(.vertical, 28)
            
            Rectangle()
                .foregroundStyle(Color.symGray3)
                .frame(height: 1)
                .padding(.bottom, 25)
            
            Feedback()
            
            CustomerSupport()
            
            Spacer()
        }
        .customNavigationBar {
            Text("마이페이지")
        } rightView: {
            NavigationLink {
                SettingView()
            } label: {
                Image(systemName: "gearshape")
            }
        }
    }
}
// stub 데이터 만들어서 테스트하기
private struct UserInfo: View {
    var body: some View {
        NavigationStack {
            HStack {
                VStack(alignment: .leading) {
                    NavigationLink {
                        MyAccountInfo()
                    } label: {
                        HStack {
                            Text("모공모공님")
                                .font(PretendardFont.h4Bold)
                            Image(systemName: "chevron.forward")
                                .font(PretendardFont.h4Medium)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 24)
                    
                    HStack {
                        Text("소중한")
                        Text("\(10)개의")
                            .foregroundStyle(Color.symPink)
                        Text("기록이 담겨있어요")
                    }
                    .font(PretendardFont.smallBold)
                    
                }
                Spacer()
                
                Image("TestImage")
                    .resizable()
                    .frame(width: 81, height: 70)
                    .scaledToFill()
            }
            .padding(.leading, 24)
            .padding(.trailing, 22)
        }
    }
}

private struct Feedback: View {
    var body: some View {
            VStack(alignment: .leading) {
                Text("SYM을 사용하며 느낀 점을 말해주세요!")
                    .font(PretendardFont.h4Bold)
                    .foregroundStyle(Color.symBlack)
                    .padding(.bottom, 22)
                    
                Button {
                    print("의견 보내기")
                } label: {
                    Text("의견 보내기")
                        .font(PretendardFont.bodyBold)
                }
                .buttonStyle(PinkButtonStyle())
                .frame(width: 126, height: 39)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            }
            .padding(.trailing, 66)
            .frame(maxWidth: .infinity, maxHeight: 137)
            .background(Color.symGray1)
            .padding(.bottom, 33)
    }
}

private struct CustomerSupport: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("고객지원")
                .font(PretendardFont.h4Bold)
                .padding(.bottom, 31)
            
            VStack {
                CustomerSupportButton(buttonTitle: "리뷰 남기기")
                CustomerSupportButton(buttonTitle: "공지사항")
                CustomerSupportButton(buttonTitle: "서비스 이용 약관")
                CustomerSupportButton(buttonTitle: "개인정보처리방침")
            }
            
            HStack {
                Text("버전 정보")
                    .font(PretendardFont.h5Bold)
                Spacer()
                
                Text("최신 버전")
                    .font(PretendardFont.bodyBold)
            }
        }
        .padding(.trailing, 16)
        .padding(.horizontal)
        .foregroundStyle(Color.symBlack)
    }
}

private struct CustomerSupportButton: View {
    let buttonTitle: String
    var body: some View {
        Button {
            print(buttonTitle)
        } label: {
            HStack {
                Text("\(buttonTitle)")
                    .font(PretendardFont.h5Bold)
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(PretendardFont.h5Medium)
            }
            .padding(.bottom, 18)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        MypageView()
    }
}

//
//  PopupContnet.swift
//  SYM
//
//  Created by 박서연 on 2024/03/22.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

struct PopupContent {
    let title: String
    let desc: String
    
    // 일반 팝업
    static let logout = PopupContent(title: "로그아웃 하시겠어요?", desc: "로그아웃 후에는 서비스 이용이 불가해요.")
    static let remove = PopupContent(title: "정말 탈퇴 하시겠어요?", desc: "사용하신 계정 정보는 회원 탈퇴 후\n모두 삭제되며, 복구가 불가합니다.")
    static let stopDiary = PopupContent(title: "잠깐! 일기 작성을 중단하시나요?", desc: "여기서 그만두면 지금까지 작성한\n글이 모두 사라집니다!")
    
    // 가이드 팝업
    static let thinking = PopupContent(title: "[생각] 쓰기 꿀팁!", desc: "긍정, 부정적인 생각 모두 있는 그대로 적으며\n~하다고 생각했다, 왜~일까?와 같은 표현을\n활용하면 더욱 명확히 표현할 수 있어요!")
    static let issue = PopupContent(title: "[사건] 쓰기 꿀팁!", desc: "언제, 어디서, 누가 관련되었는지 기록하며\n사건을 요약하는 제목을 붙여보세요!\n고민하지 말고 생각나는대로 적어봐요:)")
    static let behavior = PopupContent(title: "[행동] 쓰기 꿀팁!", desc: "어떻게 행동했는지, 그래서 결과는 어땠는지\n돌이켜보며 해당 행동이 나에게 어떤 영향을\n미쳤는지 기록해보세요!")
    static let stop = PopupContent(title: "잠깐! 일기 작성을 중단하시나요?", desc: "여기서 그만두면 지금까지 작성한\n글이 모두 사라집니다!")
}

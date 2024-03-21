//
//  TextEditorPlaceHolder.swift
//  SYM
//
//  Created by 박서연 on 2024/03/22.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation

enum TextEditorContent: String, CaseIterable {
    // 사건 - 생각 - 행동
    case writtingDiary = "예) 오늘은 친구랑 조금 다투는 일이 있었다. 평상시와 다르지 않게 즐겁게 수다를 떨었는데 갑자기 섭섭했던 일화가 나오면서 투닥거렸고, 결국에는 언성까지 높아졌다."
    case writtingThink = "예) 나는 좋은 마음에 행동한 것이었는데, 그 동안 친구는 불편하다고 느끼고 있었다고 말해서 너무 당황스러웠고 섭섭하고 화도 났다."
    case writtingAction = "예) 결국 친구한테 따지듯이 말을 하게 되었고 서로 기분이 상해서 싸우다가 홧김에 자리를 박차고 나와 집으로 돌아왔다. 지금와서 돌아보니 내 잘못이었나 싶지만, 어떻게 해야 잘 해결할 수 있을지 모르겠다."
}

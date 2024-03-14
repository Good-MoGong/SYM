# SYM
Speak Your Mind, 모공 프로젝트

<br>

## 프로젝트 소개
>SYM은 현대 생활의 복잡함에서 벗어나 여러분이 자신을 돌아보고 감정, 생각을 명확하게 기록할 수 있도록 도와주는 감정일기 앱입니다!
>감정일기를 통해 나의 감정을 정확히 인식하여 자존감을 향상시키고, 더 나아가 사회성을 높일 수 있습니다~!
>또 캐릭터를 통해 사용자에게 공감과 위로를 얻을 수 있습니다. SYM을 통해 기록하는 즐거움을 느껴보세요!

<br>

### 👀 주요기능
- **`로그인`** : 카카오,애플 로그인으로 간편하게 로그인 할 수 있습니다.
- **`메인`** : 캘린더를 통해 쉽게 기록 일정을 확인할 수 있습니다.
- **`기록하기`** : 사건,생각,감정,행동을 기록하고 캐릭터를 통해 공감과 위로를 얻을 수 있습니다.
- **`기록보기`** : 선택한 날짜의 내가 기록한 감정기록을 볼 수 있고 기록 수정을 할 수 있습니다.
- **`마이페이지`** : 내가 쓴 기록갯수를 볼 수있고 닉네임 변경, 로그아웃, 회원탈퇴를 할 수 있습니다.

<br>

### 📱구동화면
|**`로그인`**|**`캘린더`**|**`기록하기`**|**`기록보기`**|**`마이페이지`**|
|-------|-------|-------|-------|-------|
|<img src="https://github.com/Good-MoGong/SYM/assets/127810279/97c14999-478b-48ae-9eba-fc26d83f2ea0" width="143" height="300">|<img src="https://github.com/Good-MoGong/SYM/assets/127810279/8b53b435-746c-46a9-b090-de8195408cbd" width="143" height="300">|<img src="https://github.com/Good-MoGong/SYM/assets/127810279/676177e4-dfb3-4116-9a23-74a82b71cdd3" width="143" height="300">| <img src="https://github.com/Good-MoGong/SYM/assets/127810279/7383236d-c2bd-48e4-bd59-719975a8d250" width="143" height="300">|<img src = "https://github.com/Good-MoGong/SYM/assets/127810279/f3e7262f-1180-48f5-9c0d-e018a367b287" width="143" height="300" >|

<br>


### 🛠️ 개발 환경, 도구 및 활용한 기술

```
- 개발 언어 : Swift
- 개발 환경 : SwiftUI
    - 최소 iOS 16.4
    - iPhone SE ~ iPhone 15 Pro 호환
- 디자인 툴 : Figma
- 협업 도구 : Github, Team Notion
- 활용한 기술
    - Xcode, Tuist, SwiftLint
    - MVVM, POP, Clean Architecture
    - Combine, CoreData, URLSession
    - FireStore
```

<img src="https://img.shields.io/badge/Xcode-188EE8?style=for-the-badge&logo=xcode&logoColor=white"><img src="https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=swift&logoColor=white"><img src="https://img.shields.io/badge/SwiftUI-0070FD?style=for-the-badge&logo=swift&logoColor=black"><img src="https://img.shields.io/badge/Firebase-FFCC30?style=for-the-badge&logo=firebase&logoColor=black"><img src="https://img.shields.io/badge/GitHub-000000?style=for-the-badge&logo=github&logoColor=white"><img src="https://img.shields.io/badge/Notion-FFFFFF?style=for-the-badge&logo=Notion&logoColor=black"><img src="https://img.shields.io/badge/figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white">

<br>

### 🗃️ 컨벤션 및 깃플로우 전략
#### 폴더 컨벤션

```
📦SYM
    ├──🗂️Tuist
    ├──🗂️Project
    │   ├──🗂️KaKaoSPM
    │   ├──🗂️FirebaseSPM
    │   ├──🗂️App
    │   │   ├──🗂️Resources
    │   │   ├──🗂️Sources
    │   │   │   ├──🗂️Data
    │   │   │   │   ├── Repositories
    │   │   │   │   ├── Network
    │   │   │   │──🗂️DesignSystem
    │   │   │   │──🗂️Domain
    │   │   │   │   ├── Entities
    │   │   │   │   ├── UseCases
    │   │   │   │──🗂️Extensions
    │   │   │   │──🗂️Model
    │   │   │   │──🗂️Protocol
    │   │   │   │──🗂️Services   
    │   │   │   │   ├── ChatGPT 
    │   │   │   │   ├── CoreData    
    │   │   │   │   ├── Firebase       
    │   │   │   ├──🗂️Presentation
    │   │   │   │   ├── Authencation
    │   │   │   │   ├── Calendar
    │   │   │   │   ├── CustomView
    │   │   │   │   ├── Login
    │   │   │   │   ├── MyPage
    │   │   │   │   ├── Record
    │   │   │   │   ├── Tab
    │   │   │   ├── 🗂️Util
    └───────────────│
```
<br>

#### 깃플로우 전략
```mermaid
gitGraph
    commit id: "MAIN"
    branch dev
    checkout dev
    commit id: "Release01"
    branch issueName
    checkout issueName
    commit id: "${name} / ${#issue1}"
    commit id: "${name} / ${#issue2}"
    checkout dev
    merge issueName
    commit id: "Release02"
    commit id: "Release03"
    checkout main
    merge dev
    commit id: "Deploy"
```

<br>


## 팀원 소개
<div align="left">  

### 👩🏻‍💼 PM
| [박혜연]<br/> [@hye-y](https://github.com/hye-y)<br/> |
| :---: |
| <img src="https://avatars.githubusercontent.com/u/78430802?v=4" width="100" height="100"> |

### 👩🏻‍🎨 Designer
| [한지수]<br/> [@잔디밭](https://m.blog.naver.com/hhhjs-?tab=1)<br/> |
| :---: |
| <img src="https://blogpfthumb-phinf.pstatic.net/MjAyMjEwMjRfMjI4/MDAxNjY2NjIzNDc4MzU1.Mx0dRfEerHGDlZOkkCDHk140SFYvEVv4HKdqLnNarxsg.ZiG-W8ZcRyJcQnGCrVBa6SxW2TQRQXcam997i5cm5Z0g.PNG.hanjisu0523/profileImage.png" width="100" height="100"> |

### 🧑🏻‍💻 Developer
| [박서연]<br/> [@syss220211](https://github.com/syss220211)<br/> | [조민근]<br/> [@syss220211](https://github.com/syss220211)<br/>  | [안지영]<br/> [@yyomzzi](https://github.com/yyomzzi)<br/>  | [전민석]<br/> [@a-jb97](https://github.com/a-jb97)<br/> | [변상필]<br/> [@OzDevelop](https://github.com/OzDevelop)<br/>  |
| :---: | :---: | :---: | :---: | :---: |
| <img src="https://avatars.githubusercontent.com/u/110394722?v=4" width="100" height="100"> | <img src="https://avatars.githubusercontent.com/u/127810279?v=4" width="100" height="100"> | <img src="https://avatars.githubusercontent.com/u/133854561?v=4" width="100" height="100"> |  <img src="https://avatars.githubusercontent.com/u/66257281?v=4" width="100" height="100"> | <img src="https://avatars.githubusercontent.com/u/83643938?v=4" width="100" height="100"> |

</div>
 

<br>

## 📄 License
### “SYM" is available under the MIT license. See the [LICENSE](https://github.com/Good-MoGong/SYM/blob/dev/LICENSE) file for more info.
- Tuist
- Firebase - iOS

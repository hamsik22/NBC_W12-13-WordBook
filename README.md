# [iOS] SwiftRun

## 프로젝트 소개
 Swift 학습을 위한 종합 용어 사전 앱입니다. Swift 프로그래밍과 iOS 개발에 필요한 용어들을 쉽게 찾아보고 학습 진도도 체크할 수 있습니다.

## 프로젝트 구조
```swift
SwiftRun
├── Application
│   ├── AppDelegate.swift               # 앱 생명주기 및 초기 설정 관리
│   └── SceneDelegate.swift             # 앱 화면(Scene) 생명주기 관리
│
├── Network
│   └── NetworkManager.swift            # Firebase API 통신 관리, 싱글톤 패턴 사용
│
├── Resources
│   ├── Assets.xcassets                 # 앱 이미지, 컬러셋 등 리소스 관리
│   └── Info.plist                      # 앱 설정 및 권한 정보
│
└── Sources
   ├── Models
   │   ├── HomeModel.swift             # Category 구조체 정의
   │   ├── Utility.swift               # URL, CategoryKeys, UserDefaultsKeys 등 상수 관리
   │   └── Word.swift                  # Word, WordCard 구조체 정의 및 Codable 구현
   │
   ├── ViewModels
   │   ├── HomeViewVM.swift            # 홈 화면 카테고리 데이터 및 네비게이션 관리
   │   ├── SettingViewVM.swift         # 다크모드 설정 상태 관리
   │   └── WordCardStackViewModel.swift # 단어 카드 상태 및 암기 데이터 관리
   │
   └── Views
       ├── Home
       │   ├── Controller
       │   │   ├── HomeViewController.swift    # 홈 화면 메인 컨트롤러
       │   │   └── SettingViewController.swift # 설정 화면 컨트롤러
       │   ├── HomeView.swift                  # 홈 화면 메인 뷰 (프로필, 단어장 목록 포함)
       │   ├── ProfileView.swift               # 사용자 프로필 및 학습 진도 표시
       │   ├── SettingView.swift               # 테마 설정, 개인정보, 도움말 UI
       │   └── WordBookCollectionCell.swift    # 단어장 컬렉션 뷰 셀
       │
       ├── WordCard
       │   ├── MemorizedButton.swift           # 단어 암기 상태 토글 버튼
       │   ├── WordCardStackViewController.swift # 단어 카드 화면 컨트롤러
       │   └── WordCardView.swift               # 단어 카드 UI (단어, 의미, 암기 상태 표시)
       │
       └── WordList
           ├── ViewControllers
           │   ├── SidebarViewController.swift  # 카테고리 사이드바 컨트롤러
           │   └── WordListViewController.swift # 단어 목록 화면 컨트롤러
           └── WordListCell.swift               # 단어 목록 셀 (단어, 의미, 암기 상태 표시)
```

## 주요 기능
### 📚 용어 사전
- Swift 내장 함수 검색 및 설명
- iOS 개발 관련 클래스 및 구조체 정보 
- 개발 관련 영어 용어 설명
- 마케팅 용어 정리

### ✅ 학습 관리
- 학습 상태 체크 기능
- 전체 용어 대비 학습 진도율 확인
- 카테고리별 학습 현황 제공

### 🎨 사용자 경험
- 다크 모드 지원
- 직관적인 인터페이스
- 검색 기능

## 시연 영상


https://github.com/user-attachments/assets/b25fe072-2ab5-4f96-b926-d037e82da9c4


## 기술 스택
### 프레임워크 & 라이브러리
- 💻 Swift 5.0
- 📱 UIKit
- 🔥 Firebase Realtime Database
- 📊 UserDefaults (학습 상태 관리)
- 🎯 SnapKit (Auto Layout)
- ⚡️ RxSwift & RxCocoa (반응형 프로그래밍)

### 개발 아키텍처
- MVVM + RxSwift 

## API 문서
SwiftRun은 자체 개발한 [iOS Vocabulary API](https://github.com/hamsik22/NBC_W12-13_WordBook/blob/main/docs/api-reference.md)를 사용합니다. API에 대한 자세한 정보는 [API 문서](https://github.com/hamsik22/NBC_W12-13_WordBook/blob/main/docs/api-reference.md)를 참조하세요.

# 📚 해리포터 소설책 정보 뷰어 앱

해리포터 소설 시리즈의 각 권별 정보를 확인할 수 있는 iOS 앱입니다.
버튼을 통해 권(volume)을 선택할 수 있으며, 줄거리(Summary)를 펼치거나 접는 기능을 제공합니다.

# 📱 구현 기능

- 권 선택 버튼을 통한 소설 선택
- 선택한 권의 제목, 저자, 발매일, 페이지 수, 줄거리 표시
- “더보기 / 접기” 버튼을 통한 줄거리 확장 UI
- 앱 종료 후 재실행 시 이전 상태 유지

# 📌 프로젝트 개요
### 🎯 목적

- UIKit 기반 앱에서 MVVM 아키텍처를 직접 구현
- ViewController의 역할을 최소화하고 비즈니스 로직을 ViewModel로 분리
- 상태(state) 기반 UI 업데이트 구조 이해
- 실무에서 자주 사용하는 클로저 기반 데이터 바인딩 학습

### 🛠 개발 환경

- Xcode
- iOS 15+
- Swift
- UIKit
- SnapKit

### ⚙️ 기술 스택 & 의도
- UIKit: 기본 UI 구성 원리 이해
- MVVM: View / 로직 분리 연습
- Closure Binding: 간단한 데이터 전달 구조
- SnapKit: 가독성 높은 AutoLayout
- UserDefaults: UI 상태 유지

# 🧠 설계 의도
### 1. MVVM 구조 채택

- ViewController는 UI와 사용자 이벤트 처리만 담당
- 데이터 가공, 상태 관리, 비즈니스 로직은 ViewModel에서 처리
- `var updateInfo: ((BookViewInfo) -> Void)?`
- `ViewModel` → `ViewController` 방향의 데이터 전달을 클로저로 구현


### 2. 상태(State) 기반 설계
- `var selectedVolume: Int`
- `var isExpanded: Bool`
- 위의 파라미터 사용으로 단순히 “정보 전달”이 아니라 현재 앱이 어떤 상태인지 명확히 표현
- 상태 변경 → UI 업데이트 흐름을 일관되게 유지

### 3. 단일 진입점 업데이트
- `func updateBookInfo()`
- 해당 메서드로 여러 UI 요소를 각각 업데이트하지 않고 하나의 메서드에서 View에 전달할 정보를 생성
- 변경 포인트를 한 곳으로 집중시켜 유지보수 용이

# 🛠 트러블 슈팅
### ❌ 문제 1: ViewController가 너무 비대해짐

초기에는 모든 로직이 ViewController에 집중됨

기능 추가 시 코드 가독성과 유지보수성 저하

### ✅ 해결

- 데이터 로딩, 권 선택, 요약 펼침 로직을 ViewModel로 이동
- ViewController는 update 클로저만 처리

# ✨ 회고 및 배운 점

- MVVM은 “파일 나누기”가 아니라 역할 분리라는 것을 이해
- 상태(`state`)를 중심으로 생각하면 UI 로직이 단순해짐
- 작은 프로젝트라도 구조를 잡고 시작하는 것이 중요
- 클로저 기반 바인딩만으로도 충분히 MVVM을 구현할 수 있음

# 🚀 개선 및 확장 아이디어

- `Combine` 또는 `RxSwift` 도입
- 상태 `enum`(`State Pattern`) 적용
- UICollectionView로 권 선택 UI 개선
- Unit Test 추가 (ViewModel 중심)

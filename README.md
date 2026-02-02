# 📚 HarryPotter Book (UIKit)

UIKit 기반으로 구현한 **해리포터 시리즈 도서 조회 앱**입니다.  
MVC 구조에서 발생할 수 있는 ViewController 비대화를 개선하기 위해  
**MVVM 아키텍처 패턴**을 적용하여 View / ViewModel / Model의 역할을 명확히 분리했습니다.

---

## 🛠 기술 스택

- **Language**: Swift
- **UI Framework**: UIKit
- **Architecture**: MVVM
- **Layout**: SnapKit
- **Data Binding**: Closure 기반 바인딩
- **Data Parsing**: JSON (Bundle)
- **Third-party**: Then

---

## 📂 프로젝트 구조

```plaintext
📦 HarryPotterJH
 ┣ 📂 Model
 ┃ ┗ 📄 BookModels.swift
 ┣ 📂 View
 ┃ ┗ 📄 BookView.swift
 ┣ 📂 ViewModel
 ┃ ┗ 📄 BookViewModel.swift
 ┣ 📂 Service
 ┃ ┗ 📄 DataService.swift
 ┣ 📄 ViewController.swift
 ┣ 📄 data.json
```

## 🎯 MVVM 패턴 적용 이유

기존 **MVC 패턴**에서는 `ViewController`가 아래 역할을 **모두 담당**하게 됩니다.

- UI 구성
- 사용자 이벤트 처리
- 데이터 가공 및 상태 관리

이로 인해 `ViewController`가 **비대해지고**, **유지보수 및 테스트가 어려워지는 문제**가 발생합니다.  
이를 해결하기 위해 **MVVM 패턴**을 적용하여 **각 계층의 책임을 명확히 분리**했습니다.

---

## 🧩 MVVM 계층별 역할

### 1️⃣ Model (BookModels.swift)

```swift
struct Book: Decodable {
    let title: String
    let author: String
    let image: String
    let description: String
}
```
- JSON 데이터 구조와 매칭되는 **순수 데이터 모델**
- UI, 비즈니스 로직에 대한 **의존성 없음**
- `Decodable`을 통해 **데이터 파싱만 담당**

---

### 2️⃣ Service (DataService.swift)

```swift
func loadBooks(completion: @escaping (Result<[Book], Error>) -> Void)
```

- `data.json` 파일 **로드 및 파싱 담당**
- 데이터 로직을 ViewModel과 분리하여 **단일 책임 원칙(SRP)** 적용
- 향후 **네트워크 통신 구조로 확장 가능**

---

### 3️⃣ ViewModel (BookViewModel.swift)

```swift
final class BookViewModel {
    private(set) var books: [Book] = []
    var onDataChanged: (() -> Void)?
}
```
**주요 역할**
- Model 데이터를 View에 필요한 형태로 **가공**
- 현재 선택된 책 인덱스 및 **상태 관리**
- Closure를 통해 ViewController에 **변경 사항 전달**

---

### 4️⃣ View (BookView.swift)

- 책 이미지, 제목, 설명 등 **UI 표현만 담당**
- SnapKit을 활용한 **오토레이아웃 구성**
- 데이터는 직접 처리하지 않고 **외부에서 주입받음**


---

### 5️⃣ ViewController (ViewController.swift)

```swift
viewModel.onDataChanged = { [weak self] in
    self?.updateUI()
}
```
- View와 ViewModel을 연결하는 중재자 역할
- 사용자 이벤트를 ViewModel로 전달
- 비즈니스 로직을 직접 처리하지 않음
- weak self를 사용하여 메모리 누수 방지

---

- ## 🔄 데이터 흐름 (MVVM)

```text
User Action
↓
ViewController
↓
ViewModel (비즈니스 로직)
↓
Model / Service
↓
ViewModel 상태 변경
↓
View (UI 업데이트)
```

## ✨ MVVM 적용 효과

- ViewController 코드량 감소
- 각 계층의 역할이 명확해져 **가독성 향상**
- UI 수정 시 로직에 미치는 영향 최소화
- 테스트 및 유지보수가 쉬운 구조 확보


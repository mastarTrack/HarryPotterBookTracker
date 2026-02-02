# 📚 Harry Potter Book Tracker (iOS)

Swift로 개발한 **해리포터 책 정보 조회 iOS 애플리케이션**입니다.  
로컬에 저장된 JSON 파일을 읽어 책 정보를 파싱하고,  
사용자에게 책 목록과 요약 정보를 화면에 표시합니다.

---

## 🧙‍♂️ 프로젝트 소개

이 프로젝트는 **iOS 개발 입문 및 구조 설계 연습**을 목적으로 제작되었습니다.

- 네트워크 통신 없이 **로컬 JSON 데이터**를 활용
- **SnapKit**을 이용한 Auto Layout 구성
- View / Model / Service 역할 분리를 통한 구조적 설계

---

## 🛠 기술 스택

- **Language**: Swift
- **UI Framework**: UIKit
- **Layout**: SnapKit
- **Data Source**: Local JSON
- **Architecture**: MVC 기반 구조

---

## 📁 프로젝트 구조

```
project
├── Data
│   └── data.json
│
├── Model
│   └── Book.swift
│
├── Service
│   └── DataService.swift
│
├── Util
│   └── UtilCommon.swift
│
├── View
│   ├── MainView.swift
│   └── SummaryView.swift
│
└── ViewController
    └── MainViewController.swift
```

### 구조 설명

- **Data**
  - 앱에서 사용하는 로컬 JSON 데이터 파일

- **Model**
  - `Book`
    - 책 정보를 표현하는 모델 객체

- **Service**
  - `DataService`
    - JSON 파일 로드 및 디코딩 담당

- **Util**
  - `UtilCommon`
    - 공통으로 사용되는 유틸성 기능 모음

- **View**
  - `MainView`
    - 책 목록 및 기본 UI 구성
  - `SummaryView`
    - 책 요약 정보 표시 뷰

- **ViewController**
  - `MainViewController`
    - View와 Service를 연결하고 화면 흐름 제어

---

## 🔄 데이터 흐름

1. 앱 실행
2. DataService 에서 로컬 JSON 파일 로드
3. JSON 데이터를 `Book` 모델로 디코딩
4. MainViewController 를 통해 View에 데이터 전달
5. MainView / SummaryView 에서 화면 출력

---

## ✨ 주요 기능

- 로컬 JSON 파일 기반 책 정보 로딩
- 해리포터 시리즈 책 목록 표시
- 커스텀 뷰를 통한 책 요약 정보 표시
- SnapKit을 활용한 코드 기반 UI 구성

---

## 🎯 구현 포인트

- SnapKit을 이용한 **코드 기반 Auto Layout**
- View와 ViewController의 책임 분리
- 재사용 가능한 View 컴포넌트 설계

---

## 👤 Author

- **Hanjuheon**
- iOS Developer (Swift)

# 해리포터 소설책 정보 뷰어 어플

Swift 문법 과정을 끝까지 완수했으니 이제 우리는 앱 개발을 위한 기초체력이 생긴 것이죠! 

입문 강의에서 배운 내용을 복습하며 Autolayout과 View 간의 제약 관계를 익혀 UI가 포함된 해리포터 책 시리즈 앱을 완성해 봅시다.

> 이 과제에서는 해리포터 책의 정보를 볼 수 있는 해리포터 시리즈 책 앱을 개발합니다.
가변적인 데이터에 유연하게 대응하는 UI를 구성하는 것을 목표로 구현해봅시다.
> 
> 
>    - 해리포터 시리즈 책에 대한 데이터는 data.json파일로 제공되며 책 커버 이미지 또한 zip 파일로 제공됩니다. Xcode에 파일을 추가하여 사용하면 됩니다.
>    - 필수적으로 1권의 책에 대한 상세 화면을 만듭니다. 이후 도전 구현으로 해리포터 시리즈의 7권의 책에 대해서 모두 확인할 수 있도록 구현합니다.
>    - UILabel, UIButton, UIImageView, UIStackView, UIScrollView를 활용합니다.
>    - Autolayout과 Constraints에 익숙해져 봅시다.
>    - iOS 16.0과 호환 가능한 iPhone 모델(SE 2세대, 16 Pro Max 등)의 다양한 디바이스 사이즈에 대응하여 구현해봅시다.
>       - iOS 16.0 호환 모델 확인: [https://support.apple.com/ko-kr/guide/iphone/iphe3fa5df43/16.0/ios/16.0](https://support.apple.com/ko-kr/guide/iphone/iphe3fa5df43/18.0/ios/18.0)
>

-----------

# 1. 프로젝트 소개
## 1) 프로젝트 구조
```swift
├── Controller
│   ├── DataManager.swift // 데이터 관리 담당 - 저장 및 불러오기
│   └── ViewController.swift // BookTracker 시스템 관리 - 컴포넌트 배치 및 동작을 명령
├── Helper
│   ├── CustomComponent.swift // 사용자 정의 컴포넌트
│   └── Helper.swift // 편의를 위해 부가적으로 정의
├── Info.plist
├── Model
│   └── Book.swift // JSON 파싱을 위한 구조체
├── Protocol
│   ├── ButtonDelegate.swift // 버튼 Delegate 프로토콜 정의
│   └── CustomStackHelper.swift // 공통 함수 사용을 위한 프로토콜 정의
├── SceneDelegate.swift
└── View
    ├── ChapterStack.swift // 챕터 UIStackView
    ├── InfoStack.swift // 책 정보(제목, 저자, 페이지) UIStackView
    ├── SeriesButtonStack.swift // 시리즈 버튼 UIStackView
    └── SummaryStack.swift // 요약, 헌정사 UIStackView
```

지난 번 과제와 동일하게 MVC 패턴을 기준으로 잡고 객체화를 시도하였습니다.

- **Model**: JSON 데이터 파싱을 위한 객체
- **View**: 앱 UI 컴포넌트 관련 객체
- **Controller**: 앱 시스템 관련 동작 객체
- **Protocol**: 프로토콜 정의
- **Helper**: 위 분류에 해당하지 않는 부가 객체

## 2) 설계 시 고려했던 부분
### 1️⃣ MVC 패턴

Command Line Tool을 사용할 때와 달리 앱을 구현할 때는 어떤 패턴을 사용해야할지 기준이 잡히지 않았습니다.

MVC로 나누기에는 'ViewController에서 뷰를 올리고 동작도 관할하는데 뷰와 컨트롤러를 어떻게 나눠야하는 거지?' 라는 의문이 들어 어려웠습니다.

그래서 첫 구현 당시에는 MVVM 패턴을 사용했었으나, 아래 2가지 이유로 MVC 패턴으로 변경하게 되었습니다.

- 오토레이아웃 재생성 최소화
- 코드 안전성

**✏️ 오토레이아웃 재생성 최소화**

그래서 처음 구현 시에는 MVVM 패턴밖에 떠오르지 않아 아래와 같이 뷰와 관련된 모든 객체를 `ViewController`에서 함수 내부에 구현하였습니다.

```swift
class ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        set()
    }
    
    func set() {
        let infoStack = makeInfoStack()
        
        infoStack.snp.makeConstraints() { ... }
    }
    
    func makeInfoStack() -> UIStackView { ... }

}
```

ViewController 내부에 `infoStack` 상수를 별도 선언하지 않았던 이유는, 그렇지 않아도 ViewController에 많은 내용을 담게 될텐데 지속해서 사용하지 않을 스택뷰를 선언해줄 필요가 없다고 생각했습니다.

그러나 이 경우, 선택한 시리즈 버튼이 변경되어 텍스트 내용이 바뀔 경우 모든 스택뷰를 재생성하여 레이아웃을 다시 그려야한다는 치명적인 단점이 있었습니다.

ViewController 내부에 컴포넌트들을 상수로 선언하여 사용할 수도 있었지만, 그렇게되면 ViewController가 너무 방대해진다는 점이 신경쓰였습니다.

그 과정에서 다른 분들과의 코드 리뷰를 통해 스택뷰를 별도 객체로 생성하는 구조를 접하게 되었습니다.

앱의 확장성을 고려하게 된다면 뷰를 별도 객체로 나누어두면 훗날 재사용이 가능하다는 이점이 있을 것이라 판단하여 별도로 구현하는 방법을 선택하게 되었습니다.

**✏️ 코드 안전성**

데이터 관리를 위해서 ViewModel로는 `DataManager`라는 객체를 생성하였습니다.

`DataManager`는 JSON 데이터를 파싱하고, 해당 데이터를 소유하고 있었습니다.

그래서 ViewController가 특정 데이터를 요청하면, 데이터에서 해당 부분을 가공하여 전달해주는 역할을 담당하도록 했었습니다.

다만 과제 요구사항에 따라 데이터 불러오기에 오류가 발생할 경우, ViewController에서 Alert를 띄워야 했습니다.

책 번호를 선택하는 시리즈 버튼이 1개일 경우에는 별 문제가 없었지만, 여러 개의 버튼을 생성하도록 구현할 때 문제가 발생했습니다.

```swift
class DataManger {
    private var books: [Book] = []
    
    ...
    
    func fetchBook(num: Int) throws -> Book {
        // books 배열이 비었다면 가져오기
        if books.isEmpty { books = try loadBooks() }
        
        ...
    }
}
```

```swift
class ViewController {
    
    ...
    
        // 데이터(책) 가져오기
    func getBook(_ num: Int) -> Book? {
        var book: Book?

        do {
            book = try dataManager.fetchBook(num: num)
        } catch DataError.fileNotFound {
            showAlert("⛔️ 파일을 찾을 수 없습니다.")
        } catch DataError.parsingFailed(let error) {
            showAlert("⛔️ JSON 파싱 에러: \(error)")
        } catch DataError.invalidNumberOfBooks {
            showAlert("⛔️ 유효하지 않은 입력값입니다.")
        } catch {
            showAlert("⛔️ 알 수 없는 오류: \(error)")
        }
        return book
    }
    
    ...
}
```

기존에는 위처럼 `fetchBook`으로 데이터를 1개 불러오고, ViewController에서 해당 함수의 에러를 처리했습니다.

하지만 시리즈 버튼을 `[Book].count`만큼 생성하려니 해당 배열의 크기를 가져오는 `fetchBookNum()` 함수를 생성하게 되었고, 이 함수의 에러를 처리하는 별도의 함수를 하나 더 생성해야하는 상황이 되었습니다.

거의 동일한 함수를 생성하자니 비효율적인 것 같아 새로이 만든 `fetchBookNum()`가 오류를 던지고 기존의 `fetchBook(num:) -> Book` 함수는 오류를 던지지 않도록 수정했었습니다.

다만 이 경우, 반드시 `fetchBookNum`을 실행한 다음 `fetchBook(num:)`을 실행해야한다는 조건이 지켜져야했습니다. 그렇지 않으면 'out of index range' 오류가 발생하는 구조였습니다.

코드를 작성한 저라면 이 규칙을 지키겠지만, 만약 이게 팀 프로젝트였다면 과연 좋은 코드라고 할 수 있을까? 라는 의구심이 들었습니다.

그래서 해당 변경사항을 모두 폐기하고, `[Book]` 배열을 DataManger가 아닌 ViewController가 갖도록 변경하였습니다.

DataManager의 '데이터 가공' 역할을 없애고 '저장과 불러오기' 역할만을 부여했습니다.


**💡 결과**
최종적으로 ViewController는 각 스택뷰 객체를 컨트롤러에 올리고, DataManager로 부터 받아온 데이터를 각 뷰에 전달하여 내용을 변경하도록 하는 시스템의 관리 감독 역할을 담당하는 객체로 구현하였습니다.


# 2. 회고

과제의 구현 난이도 자체는 어렵지는 않았다고 생각하지만 설계 구조를 여러번 변경하며 시간 낭비를 했다고 생각합니다.

나름 구조를 먼저 구상하고 구현한다고 했었던 것인데, 머릿속으로만 생각하다보니 여러 어려움이 있었던 것 같습니다.

다음 프로젝트부터는 코드로 작성하기 전 충분한 구상 시간을 거치고 구조를 설계하여 구현을 진행하자는 목표를 갖게 되었습니다.

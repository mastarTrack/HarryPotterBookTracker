//
//  ViewController.swift
//  harrypotter
//
//  Created by 손영빈 on 1/22/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let dataService = DataService() // DataService 생성
    var books: [Book] = [] //받아온 데이터 저장용 배열
    
    let mainView = MainView()
    
    override func loadView() { // 기존의 View를 mainView로 변경하기 (레이아웃 설정 불필요)
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        기존의 View 위에 덮어씌우기 (레이아웃 설정 필요)
//        view.addSubview(mainView)
//        mainView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
        
        setDelegate()
        loadBooks()
    }
    
}

extension ViewController {
    
    private func setDelegate() {
        mainView.bookSummaryStackView.delegate = self // bookSummaryStackView의 delegate는 ViewController 자신이다.
    }
}

// data.json 파싱 이후 titleText에 적용, book에도 적용
extension ViewController {
    
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let books):
                self.books = books
                mainView.setSeriesButton(with: books, target: self, action: #selector(seriesButtonTapped(_:))) // 기존 : ViewController 내부에서 실행하기 때문에 target을 self로 선언, action을 바로 사용가능했지만 mainView로 분리하여 매개변수로 넘겨줘야 함.
                if let firstBook = books.first {
                    self.infoUpdate(with: firstBook, idx: 0) // 업데이트 정보가 많아져서 함수로 분리
                    selectedSeriesButton(0) // 기본 앱 실행 시 1권 표시 : 1번 버튼 선택
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
//                self.present(alert, animated: true)
                
            }
        }
    }
    
    // 정보 업데이트 함수 분리
    func infoUpdate(with book: Book, idx: Int) {
        mainView.titleText.text = book.title
        mainView.bookInfoView.configure(with: book, idx: idx) // bookInfoView.configure 함수에 idx 넘겨주기
        
        // isFolded_\(book.title) 상대로 저장하는 이유 : 다음 챕터에서 책에 따라 버튼 생성 시 개별적으로 상태 저장하기 위해
        let isSaved = UserDefaults.standard.object(forKey: "isFolded_\(book.title)") != nil // UserDefauls에 isFolded_isFolded_\(book.title) 상태로 저장된 값 유무 확인
        mainView.bookSummaryStackView.config(dedication: book.dedication, summary: book.summary, folded: isSaved)

        mainView.bookChapterStackView.config(with: book.chapters)
    }
}

// 버튼 관련 메소드 관리
extension ViewController {
    
    // 버튼을 눌렀을 때, 동작하는 메서드 정의
    @objc
    private func seriesButtonTapped(_ sender: SeriesButton) {
        let idx = sender.tag
        let book = books[idx]
        
        infoUpdate(with: book, idx: idx) // infoUpdate에 idx 넘겨주기
        mainView.scrollView.setContentOffset(.zero, animated: false) // 스크롤 위치 초기화
        selectedSeriesButton(idx)
        
    }
    
    // 버튼 눌렸을 때 상태 변화 메서드 정의
    private func selectedSeriesButton(_ selectedSeriesIdx: Int) {
        for (idx, btn) in mainView.seriesButtons.enumerated() {
            btn.backgroundColor = (idx == selectedSeriesIdx) ? .systemBlue : .systemGray5
            
            let titleColor: UIColor = (idx == selectedSeriesIdx) ? .white : .systemBlue
            btn.setTitleColor(titleColor, for: .normal)
        }
    }
}

// Delegate 사용
extension ViewController: BookSummaryStackViewDelegate {
    
    func onTapExtraButton(isFolded: Bool) {
        guard let title = mainView.titleText.text else { return }
        if isFolded {
            UserDefaults.standard.set(true, forKey: "isFolded_\(title)") // 접혀있는 상태일 경우, UserDefaults에 isFolded_\(title) 형태로 저장
        } else {
            UserDefaults.standard.removeObject(forKey: "isFolded_\(title)") // 더보기 상태일 경우, UserDefaults에 저장된 isFolded_\(title) 제거
        }
    }
}


@available(iOS 17.0, *)
#Preview{
    ViewController()
}

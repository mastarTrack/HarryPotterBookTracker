//
//  ViewController.swift
//  HarryPotterBookTracker
//
//  Created by Hanjuheon on 1/23/26.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    /// json 파싱 클래스
    private let dataService = DataService()
    /// 메인 뷰
    private let mainView = MainView()
    /// 해리포터 책 정보 배열
    private var bookData: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view = mainView
        loadBooks()
        if bookData.count != 0 {
            mainView.setViewData(book: bookData[0],bookNumber: 0)
            mainView.makeBooksButtons(books: bookData)
        }
    }
    
    /// 메인 뷰 UI 설정
    func ConfigureUI(){
        mainView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    /// 책 정보 로드 메소드
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                bookData = books
            case .failure(let error):
                if let dataError = error as? DataService.DataError {
                    switch dataError {
                    case .fileNotFound:
                        DispatchQueue.main.async {self.showAlert("파일을 찾을 수 없습니다.")}
                    case .parsingFailed:
                        DispatchQueue.main.async {self.showAlert("파싱 실패")}
                    }
                }
            }
        }
    }
  
    
    /// 경고 메시지 출력 메소드
    func showAlert(_ messageText: String) {
        let alert = UIAlertController(
            title: "경고",
            message: messageText,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }

}

#Preview{
   MainViewController()
}

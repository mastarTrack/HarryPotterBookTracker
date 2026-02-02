//
//  ViewController.swift
//  HarryPotterBookTracker
//
//  Created by Hanjuheon on 1/23/26.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Components
    /// 메인 뷰
    private let mainView = MainView()
    
    // MARK: - Properties
    /// json 파싱 클래스
    private let dataService = DataService()
    /// 해리포터 책 정보 배열
    private var bookData: [Book] = []
    /// 데이터저장소 선언
    private let userDefaults = UserDefaults.standard
    /// 현재 보여지고있는 책 넘버링 Int
    private var currentBookNumber = 0
    /// 현재 뷰 개요 상태 저장용 Bool
    private var summaryIsFull = false
    
    // MARK: - Init
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadBooks()
    }
}

// MARK: - METHOD: 데이터 로드 관련
extension MainViewController{
    /// 책 정보 로드 메소드
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                bookData = books
                if bookData.count != 0 {
                    summaryIsFull = userDefaults.bool(forKey: "onOff_\(currentBookNumber)")
                    mainView.configureBooksButtons(booksCount: bookData.count)
                    mainView.setViewData(book: bookData[0],
                                         bookNumber: 0)
                    mainView.changeSummay(text: bookData[0].changeSummaryText(summaryIsFull),
                                          onOff: summaryIsFull)
                    setButtonClosure()
                    setSummaryClousre()
                }
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
}

// MARK: - METHOD: 경고 메시지 창 관련
extension MainViewController{
    /// 경고 메시지 출력 메소드
    private func showAlert(_ messageText: String) {
        let alert = UIAlertController(
            title: "경고",
            message: messageText,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
}

// MARK: - METHOD: 클로저 관련
extension MainViewController{
    /// 메인 뷰 책 리스트 버튼 이벤트 클로저 세팅 메소드
    func setButtonClosure() {
        mainView.bookButtonClosure = { [weak self] bookNumber in
            guard let self else { return }
            self.summaryIsFull = self.userDefaults.bool(forKey: "onOff_\(bookNumber)")
            self.currentBookNumber = bookNumber
            self.mainView.setViewData(
                book: self.bookData[bookNumber],
                bookNumber: bookNumber)
            self.mainView.changeSummay(text: self.bookData[self.currentBookNumber].changeSummaryText(self.summaryIsFull),
                                       onOff: self.summaryIsFull)
        }
    }
    /// 개요 뷰 버튼 이벤트 클로저 세팅 메소드
    func setSummaryClousre() {
        mainView.setSummaryBottonAction{ [weak self] in
            guard let self else { return }
            self.summaryIsFull = self.summaryIsFull ? false : true
            self.mainView.changeSummay(
                text: self.bookData[self.currentBookNumber].changeSummaryText(self.summaryIsFull),
                onOff: self.summaryIsFull)
            self.userDefaults.set(self.summaryIsFull, forKey: "onOff_\(self.currentBookNumber)")
            self.userDefaults.synchronize()
        }
    }
}

#Preview{
   MainViewController()
}

//
//  ViewController.swift
//  HarryPotterJH
//
//  Created by 김주희 on 1/23/26.
//

import UIKit
import Then

// MARK: - ViewController: View와 ViewModel을 연결해주는 역할

final class ViewController: UIViewController {
    
    // 1. View와 ViewModel 인스턴스
    private let mainView = BookView()
    private let viewModel = BookViewModel()
    
    // 기존의 view 대신 mainView(BookView)를 사용한다고 선언
    override func loadView() {
        self.view = mainView
    }
    
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding() // 연결고리 설정
        viewModel.loadBooks() // 데이터 불러오기 시작
    }
    
    
    // MARK: -- Binding (연결하기)
    
    private func setupBinding() {
        // 1. View에서 (시리즈,요약)버튼이 눌렸을때 VM에게 알림
        mainView.onSeriesButtonTapped = { [weak self] index in
            self?.viewModel.selectSeries(at: index)
        }
        
        mainView.onSummaryButtonTapped = { [weak self] in
            self?.viewModel.toggleSummary()
        }
        
        // 2. VM에서 데이터가 변경되었을 때 View 업데이트
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateView()
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: message)
            }
        }
        
    }
    
    
    // MARK: -- update function
    
    
    // UI 갱신 함수
    private func updateView() {
        guard let book = viewModel.currentBook else { return }
        
        // BookView의 UI 요소에 업데이트 된 값 대입
        
        // 최상위 책 제목 값 대입
        mainView.titleLabel.text = book.title
        // 책 표지 이미지 대입
        mainView.bookImageView.image = viewModel.currentImage
        // 책 정보영역의 제목 대입
        mainView.titleLabel2.text = book.title
        
        // VM에 있는 포맷팅 함수 활용
        
        // 가이드에 맞춘 속성 텍스트 설정
        mainView.authorLabel.attributedText = mainView.createInfoText(title: "Author", value: book.author, titleSize: 16, valueSize: 18, valueColor: .darkGray)
        mainView.releasedLabel.attributedText = mainView.createInfoText(title: "Released", value: viewModel.releaseDateText, titleSize: 14, valueSize: 14, valueColor: .gray)
        mainView.pagesLabel.attributedText = mainView.createInfoText(title: "Pages", value: "\(book.pages)", titleSize: 14, valueSize: 14, valueColor: .gray)
        
        mainView.dedicationLabel.text = book.dedication
        
        // 요약 업데이트
        mainView.summaryLabel.text = viewModel.summaryText
        mainView.summaryButton.isHidden = viewModel.isSummaryButtonHidden
        mainView.summaryButton.setTitle(viewModel.summaryButtonTitle, for: .normal)
        
        // 버튼 색상 업데이트
        mainView.updateSeriesButtons(selectedIndex: viewModel.index)
        
        // 챕터 업데이트
        updateChapters(chapters: book.chapters)
    }
    
    
    // chapters 갱신
    private func updateChapters(chapters: [Chapter]) {
        // 기존 챕터 뷰 제거하고 타이틀 재 삽입
        mainView.chapterStackView.subviews.forEach{ $0.removeFromSuperview() }
        mainView.chapterStackView.addArrangedSubview(mainView.chapterTitleLabel)
        
        // 새 챕터 추가
        chapters.forEach { chapter in
            let label = UILabel().then {
                $0.text = chapter.title
                $0.font = .systemFont(ofSize: 14)
                $0.textColor = .darkGray
                $0.numberOfLines = 0
            }
            mainView.chapterStackView.addArrangedSubview(label)
        }
    }
    
    // 에러창 띄우기
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "에러 발생", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
}








@available(iOS 17.0, *)
#Preview {
    ViewController()
}

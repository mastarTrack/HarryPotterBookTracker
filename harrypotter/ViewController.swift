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
    
    let titleText = UILabel()
    let seriesButton = SeriesButton()
    
    let scrollView = UIScrollView() // 스크롤 뷰 생성
    let contentView = UIStackView() // 스크롤 뷰 내부 메인 뷰
    
    let bookInfoView = BookInfoStackView() // bookInfoView 생성
    let bookSummaryStackView = BookSummaryStackView()
    let bookChapterStackView = BookChapterStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        loadBooks()
    }
}

extension ViewController {
    private func configUI() {
        view.backgroundColor = .white
        
//        titleText.text = "ASDFASDFASDFASDFSADFSADFASDFSADFSADFSADFSADS"
        titleText.textColor = .black
        titleText.font = .systemFont(ofSize: 24, weight: .bold)
        titleText.numberOfLines = 0 // 줄 바꿈 제한 x
        titleText.textAlignment = .center // 텍스트 중앙 정렬
        
        seriesButton.setTitle("1", for: .normal)
        seriesButton.setTitleColor(.white , for: .normal)
        seriesButton.titleLabel?.font = .systemFont(ofSize: 16)
        seriesButton.backgroundColor = .systemBlue
//        seriesButton.layer.cornerRadius = 8
        
        scrollView.showsVerticalScrollIndicator = false // 스크롤 바 숨기기
        
        contentView.axis = .vertical
        contentView.spacing = 24 // contentView 내부 컴포넌트들의 거리 24
        contentView.alignment = .leading
        
        [titleText, seriesButton, scrollView].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        
//        view.addSubview(bookInfoView) // bookInfoView 추가
//        view.addSubview(bookSummaryStackView) //bookSummaryStackView 추가
        [bookInfoView, bookSummaryStackView, bookChapterStackView].forEach {
            contentView.addArrangedSubview($0)
        }
        
        titleText.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        seriesButton.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleText.snp.bottom).offset(16)
            $0.width.equalTo(seriesButton.snp.height) // height에 width 고정 -> 가로, 세로 비율 유지
        }
        
        //scrollView 속성 정의
        scrollView.snp.makeConstraints {
            $0.top.equalTo(seriesButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        //contentView 속성 정의 -> scrollView에 맞춤
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        
//        bookInfoView.snp.makeConstraints {
//            $0.top.equalTo(seriesButton.snp.bottom).offset(20)
//            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
//        
//        bookSummaryStackView.snp.makeConstraints {
//            $0.top.equalTo(bookInfoView.snp.bottom).offset(24)
//            $0.leading.trailing.equalToSuperview().inset(20)
//        }
        
    }
}

// UIButton 상속받는 커스텀 SeriesButton 생성 : ( 레이아웃 결정 이후 cornerRadius 적용되기 때문 )
class SeriesButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
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
                     if let firstBook = books.first {
                         self.titleText.text = firstBook.title
                         self.bookInfoView.configure(with: firstBook)
                         self.bookSummaryStackView.configure(dedication: firstBook.dedication, summary: firstBook.summary)
                         self.bookChapterStackView.config(with: firstBook.chapters)
                     }
                 case .failure(let error):
                     print("에러 : \(error)")
                 }
         }
     }
}

@available(iOS 17.0, *)
#Preview{
    ViewController()
}

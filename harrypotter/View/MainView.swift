//
//  MainView.swift
//  harrypotter
//
//  Created by 손영빈 on 1/27/26.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    let titleText = UILabel()
    
    let seriesStackView = UIStackView()
    var seriesButtons: [SeriesButton] = []
    
    let scrollView = UIScrollView() // 스크롤 뷰 생성
    let contentView = UIStackView() // 스크롤 뷰 내부 메인 뷰
    
    let bookInfoStackView = BookInfoStackView() // bookInfoView 생성
    let bookSummaryStackView = BookSummaryStackView()
    let bookChapterStackView = BookChapterStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MainView {
    
    private func setAttributes() {
        
        self.backgroundColor = .white
        
        titleText.textColor = .black
        titleText.font = .systemFont(ofSize: 24, weight: .bold)
        titleText.numberOfLines = 0 // 줄 바꿈 제한 x
        titleText.textAlignment = .center // 텍스트 중앙 정렬
        
        seriesStackView.axis = .horizontal
        seriesStackView.spacing = 6
        seriesStackView.distribution = .fillEqually
        seriesStackView.alignment = .center
        
        scrollView.showsVerticalScrollIndicator = false // 스크롤 바 숨기기
        
        contentView.axis = .vertical
        contentView.spacing = 24 // contentView 내부 컴포넌트들의 거리 24
        contentView.alignment = .leading
    }
    
    private func setLayout() {
        [titleText, seriesStackView, scrollView].forEach { self.addSubview($0) }
        scrollView.addSubview(contentView)
        
        [bookInfoStackView, bookSummaryStackView, bookChapterStackView].forEach {
            contentView.addArrangedSubview($0)
        }
        
        titleText.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
        }
        
        seriesStackView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleText.snp.bottom).offset(16)
        }
        
        //scrollView 속성 정의
        scrollView.snp.makeConstraints {
            $0.top.equalTo(seriesStackView.snp.bottom).offset(20) // seriesStackView 기준으로 변경
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.bottom.equalToSuperview()
        }
        
        //contentView 속성 정의 -> scrollView에 맞춤
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
}

extension MainView {
    func config(with book: Book, idx: Int, isFolded: Bool) {
        titleText.text = book.title
        bookInfoStackView.config(with: book, idx: idx) // bookInfoView.config 함수에 idx 넘겨주기
        bookSummaryStackView.config(dedication: book.dedication, summary: book.summary, folded: isFolded)
        bookChapterStackView.config(with: book.chapters)
    }
}

extension MainView {
    // 기존 : 버튼 1개 생성 -> 배열로 받아와서 개수만큼 버튼 생성
    func setSeriesButton(with books: [Book], target: Any, action: Selector) { // 시리즈 버튼 생성 함수 분리 : private 안됨
        // 기본 버튼 생성, 속성 정의
        for idx in books.indices {
            let button = SeriesButton()
            button.setTitle("\(idx + 1)", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16)
            button.backgroundColor = .systemGray5
            button.tag = idx
            button.addTarget(target, action: action, for: .touchUpInside)
            
            button.snp.makeConstraints {
                $0.width.equalTo(button.snp.height)
            }
            
            self.seriesStackView.addArrangedSubview(button)
            self.seriesButtons.append(button)
        }
    }
    
    // 버튼 눌렸을 때 상태 변화 메서드 정의
    func updateButtonColor(_ selectedSeriesIdx: Int) {
        for (idx, btn) in self.seriesButtons.enumerated() {
            btn.backgroundColor = (idx == selectedSeriesIdx) ? .systemBlue : .systemGray5
            
            let titleColor: UIColor = (idx == selectedSeriesIdx) ? .white : .systemBlue
            btn.setTitleColor(titleColor, for: .normal)
        }
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

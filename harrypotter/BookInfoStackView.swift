//
//  BookInfoStackView.swift
//  harrypotter
//
//  Created by 손영빈 on 1/22/26.
//

import UIKit
import SnapKit

class BookInfoStackView: UIStackView {
    
    let titleImageView = UIImageView()
    let contentStackView = UIStackView()
    let titleLabel = UILabel()
    
    let authorStackView = UIStackView()
    let authorLabel = UILabel()
    let authorValueLabel = UILabel()
    
    let releaseDateStackView = UIStackView()
    let releaseDateLabel = UILabel()
    let releaseDateValueLabel = UILabel()
    
    let pageStackView = UIStackView()
    let pageLabel = UILabel()
    let pageValueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BookInfoStackView {
    
    // 속성 정의
    private func setAttribute() {
        self.axis = .horizontal
        self.spacing = 20
        self.alignment = .top
        
//        titleImageView.image = UIImage(named: "harrypotter1")
//        titleImageView.backgroundColor = .systemBlue
        titleImageView.contentMode = .scaleAspectFill
        titleImageView.clipsToBounds = true // 원본 이미지와 맞지 않을 경우 바깥으로 빠져나감 -> 잘라내도록
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 12
        contentStackView.alignment = .leading // 좌측을 기준으로 필요한만큼 공간 할당
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0 // 줄 수 제약 x
        
        // contentStackView 내부의 3개의 StackView의 조건은 같음 -> 묶어서 forEach 사용
        [authorStackView, releaseDateStackView, pageStackView].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        authorLabel.text = "Author"
        authorLabel.textColor = .black
        authorLabel.font = .systemFont(ofSize: 16, weight: .bold)
        authorValueLabel.font = .systemFont(ofSize: 18)
        authorValueLabel.textColor = .darkGray
        
        releaseDateLabel.text = "Release"
        releaseDateLabel.textColor = .black
        releaseDateLabel.font = .systemFont(ofSize: 14, weight: .bold)
        releaseDateValueLabel.font = .systemFont(ofSize: 14)
        releaseDateValueLabel.textColor = .gray
        
        pageLabel.text = "Page"
        pageLabel.textColor = .black
        pageLabel.font = .systemFont(ofSize: 14, weight: .bold)
        pageValueLabel.font = .systemFont(ofSize: 14)
        pageValueLabel.textColor = .gray
    }
    
    // 레이아웃 정의
    private func setLayout() {
        
        // 각 Label -> StackView에 넣기
        [authorLabel, authorValueLabel].forEach { authorStackView.addArrangedSubview($0) }
        [releaseDateLabel, releaseDateValueLabel].forEach { releaseDateStackView.addArrangedSubview($0) }
        [pageLabel, pageValueLabel].forEach { pageStackView.addArrangedSubview($0) }
        
        // 각 StackView -> contentStackView에 넣기
        [titleLabel, authorStackView, releaseDateStackView, pageStackView].forEach { contentStackView.addArrangedSubview($0) }
        
        // titleImage와 contentStackView 합치기
        [titleImageView, contentStackView].forEach { addArrangedSubview($0) }
        
        titleImageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(titleImageView.snp.width).multipliedBy(1.5) //가로 세로 비율 1:1.5
        }
    }
}

// 데이터 불러오기
extension BookInfoStackView {
    func configure(with book: Book, idx: Int) {
        titleLabel.text = book.title
        authorValueLabel.text = book.author
        releaseDateValueLabel.text = book.releaseDateFormatted // releaseDate를 형식 변경한 releaseDateFormatted로 변경
        pageValueLabel.text = "\(book.pages)"
        titleImageView.image = UIImage(named: "harrypotter\(idx + 1)") // 이미지 로딩 추가
    }
}

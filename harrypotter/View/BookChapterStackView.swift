//
//  BookChapterStackView.swift
//  harrypotter
//
//  Created by 손영빈 on 1/22/26.
//

import UIKit
import SnapKit

class BookChapterStackView: UIStackView {
    
    private let titleLabel = UILabel()
    private let chapterListStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookChapterStackView {

    func setAttribute() {
        self.axis = .vertical
        self.spacing = 8
        self.alignment = .leading
        
        titleLabel.text = "Chapters"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        chapterListStackView.axis = .vertical
        chapterListStackView.spacing = 8 // 각 챕터 사이 간격 8
        chapterListStackView.alignment = .leading
    }
        
    func setLayout() {
        [titleLabel, chapterListStackView].forEach { addArrangedSubview($0) }
    }
}

extension BookChapterStackView {
    func config(with chapters: [Chapter]) {
        chapterListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // 뷰를 삭제하는 로직 필요 : 스택뷰는 아래에 계속 쌓임.(addArrangedSubView를 사용하기에 덮어쓰지 않음)
        
        // 새로운 뷰를 생성 -> 적용 ( 덮어쓰기 x )
        chapters.forEach { chapter in
            let label = UILabel()
            label.text = chapter.title
            label.textColor = .darkGray
            label.font = .systemFont(ofSize: 14)
            chapterListStackView.addArrangedSubview(label)
            
        }
    }
}

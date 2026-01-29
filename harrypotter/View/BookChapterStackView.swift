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
    func config(with chapters: [Chapter]) { // 수정 : 뷰를 삭제, 생성하는 것에는 많은 비용이 발생한다.
        
        // 현재 뷰의 개수, 새로 받아올 뷰의 개수
        let currentViewCount = chapterListStackView.arrangedSubviews.count
        let newViewCount = chapters.count
        
        for i in 0..<newViewCount {
            if i < currentViewCount {
                if let label = chapterListStackView.arrangedSubviews[i] as? UILabel {
                    label.text = chapters[i].title
                    label.isHidden = false
                }
            } else {
                let label = UILabel()
                label.text = chapters[i].title
                label.textColor = .darkGray
                label.font = .systemFont(ofSize: 14)
                chapterListStackView.addArrangedSubview(label)
            }
        }
        
        if newViewCount < currentViewCount {
            for i in newViewCount..<currentViewCount {
                chapterListStackView.arrangedSubviews[i].isHidden = true
            }
        }
    }
}

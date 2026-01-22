//
//  BookSummaryStackView.swift
//  harrypotter
//
//  Created by 손영빈 on 1/22/26.
//

import UIKit
import SnapKit

class BookSummaryStackView: UIStackView {
    
    let dedicationStackView = UIStackView()
    let dedicationLabel = UILabel()
    let dedicationValueLabel = UILabel()
    
    let summaryStackView = UIStackView()
    let summaryLabel = UILabel()
    let summaryValueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

private extension BookSummaryStackView {
    
    private func setAttributes() {
        
        // 메인 스택뷰 영역간 간격 24
        self.axis = .vertical
        self.spacing = 24
        self.alignment = .leading
        
        // 타이틀과 내용 사이 간격 8
        [dedicationStackView, summaryStackView].forEach {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .leading
        }
        
        [dedicationLabel, summaryLabel].forEach {
            $0.font = .systemFont(ofSize: 18, weight: .bold)
            $0.textColor = .black
        }
        
        [dedicationValueLabel, summaryValueLabel].forEach {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .darkGray
            $0.numberOfLines = 0
        }
        
        dedicationLabel.text = "Dedication"
        summaryLabel.text = "Summary"
    }
    
    private func setLayout() {
        
        // Label -> StackView
        [dedicationLabel, dedicationValueLabel].forEach { dedicationStackView.addArrangedSubview($0) }
        [summaryLabel, summaryValueLabel].forEach { summaryStackView.addArrangedSubview($0) }
        
        // StackView 합치기
        [dedicationStackView, summaryStackView].forEach { self.addArrangedSubview($0) }
    }
}

extension BookSummaryStackView {
    func configure(dedication: String, summary: String) {
        dedicationValueLabel.text  = dedication
        summaryValueLabel.text = summary
    }
}

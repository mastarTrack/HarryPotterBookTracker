//
//  BookSummaryStackView.swift
//  harrypotter
//
//  Created by 손영빈 on 1/22/26.
//

import UIKit
import SnapKit

// Delegate 생성, AnyObject 사용 : Class에서 사용할 경우로 제한 (weak 사용 가능)
protocol BookSummaryStackViewDelegate: AnyObject {
    func bookSummaryStackViewDidTapExtraButton(isFolded: Bool)
}

class BookSummaryStackView: UIStackView {
    
    // 변수 생성
    weak var delegate: BookSummaryStackViewDelegate?
    
    let dedicationStackView = UIStackView()
    let dedicationLabel = UILabel()
    let dedicationValueLabel = UILabel()
    
    let summaryStackView = UIStackView()
    let summaryLabel = UILabel()
    let summaryValueLabel = UILabel()
    
    let extraButton = UIButton()
    
    private var isFolded = false // 상태 저장용
    private var summaryText = "" // 텍스트 저장
    
    
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
        self.alignment = .fill // leading에서 fill로 변경
        
        // 타이틀과 내용 사이 간격 8
        [dedicationStackView, summaryStackView].forEach {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill // leading에서 fill로 변경
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
        
        extraButton.setTitleColor(.systemBlue, for: .normal)
        extraButton.titleLabel?.font = .systemFont(ofSize: 14)
        extraButton.addTarget(self, action: #selector(extraButtonTapped), for: .touchDown) // 함수 연결
        extraButton.contentHorizontalAlignment = .trailing // 버튼 우측 배치
    }
    
    private func setLayout() {
        
        // Label -> StackView
        [dedicationLabel, dedicationValueLabel].forEach { dedicationStackView.addArrangedSubview($0) }
        [summaryLabel, summaryValueLabel, extraButton].forEach { summaryStackView.addArrangedSubview($0) }
        
        // StackView 합치기
        [dedicationStackView, summaryStackView].forEach { self.addArrangedSubview($0) }
    }
}

extension BookSummaryStackView {
    
    // folded 상태 추가
    func config(dedication: String, summary: String, folded: Bool) {
        dedicationValueLabel.text  = dedication
        //        summaryValueLabel.text = summary
        self.summaryText = summary // displaySummary에서 사용할 summaryText에 summary 담기
        self.isFolded = folded // UserDefaults에서 읽은 데이터의 유무
        
        // summary의 글자수 450 >= 버튼 숨기기
        if summary.count >= 450 {
            extraButton.isHidden = false
            displaySummary()
        } else {
            extraButton.isHidden = true
            summaryValueLabel.text = summary
        }
    }
    
    // isFolded에 저장된 값이 있을 경우 접혀있는 상태 : 450자 + ..., 더보기 / 값이 없을 경우 더보기 상태 : 글자 전체 출력 + 접기
    private func displaySummary() {
        if isFolded {
            let truncatedText = String(summaryText.prefix(450)) // prefix로 450번째 글자까지 잘라서 truncatedText에 저장
            summaryValueLabel.text = truncatedText + "..."
            extraButton.setTitle( "더보기", for: .normal)
            
        } else {
            summaryValueLabel.text = summaryText
            extraButton.setTitle("접기", for: .normal)
        }
    }
    
    // 버튼 눌렀을 때, 동작하기 위한 함수 생성
    @objc
    func extraButtonTapped() {
        isFolded.toggle()
        displaySummary()
        delegate?.bookSummaryStackViewDidTapExtraButton(isFolded: isFolded)
    }
    
}


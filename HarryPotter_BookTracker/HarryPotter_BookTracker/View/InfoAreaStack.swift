//
//  InfoAreaStack.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/30/26.
//
import UIKit

// 정보 영역 스택 설정부
extension ViewController {
    //MARK: 기본 component 생성 메소드
    // 정보 타이틀 레이블 생성
    func makeInfoTitleLabel(_ info: Description) -> UILabel {
        let text = info.rawValue
        let setting = info.getTitleLabelSetting()
        
        let label = UILabel(text: text, font: setting.font, color: setting.textColor)
        
        return label
    }
    
    // 수직 레이블 스택 생성
    func setVerticalLabelStack(_ views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }
    
    //MARK: Summary & Dedication 영역 설정
    // 레이블 스택 생성
    func setSummaryLabelStack(_ info: Description) -> UIStackView {
        let title = makeInfoTitleLabel(info)
        
        let stackView = switch info {
        case .dedication:
            setVerticalLabelStack([title, dedicationLabel])
        case .summary:
            setVerticalLabelStack([title, summaryLabel])
        default:
            UIStackView()
        }
        
        return stackView
    }
    
    // Summary 스택 설정
    func setSummaryStack() -> UIStackView {
        let labels = setSummaryLabelStack(.summary)
        
        let stackView = setVerticalLabelStack([labels, moreButton])
        stackView.alignment = .trailing
        
        if summaryLabel.text?.count ?? 0 < 450 {
            moreButton.isHidden  = true
        }
        
        return stackView
    }
}

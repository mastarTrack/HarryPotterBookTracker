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
    
    //MARK: 정보 영역(책 이미지, 제목, 저자, 출간일, 페이지) 설정
    // 레이블 스택 생성
    func setInfoLabelStack() -> UIStackView {
        let authorTitle = makeInfoTitleLabel(.author)
        let authorStack = UIStackView(arrangedSubviews: [authorTitle, authorLabel])
        
        let releasedTitle = makeInfoTitleLabel(.release_date)
        let releasedStack = UIStackView(arrangedSubviews: [releasedTitle, releasedDateLabel])
        
        let pagesTitle = makeInfoTitleLabel(.pages)
        let pagesStack = UIStackView(arrangedSubviews: [pagesTitle, pagesLabel])
        
        [authorStack, releasedStack, pagesStack].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        return setVerticalLabelStack([infoBookTitleLabel, authorStack, releasedStack, pagesStack])
    }
        
    // 정보 영역 스택 생성
    func setInfoStack() -> UIStackView {
        let labels = setInfoLabelStack()
        let stackView = UIStackView(arrangedSubviews: [bookImageView, labels])
        
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .top
        
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

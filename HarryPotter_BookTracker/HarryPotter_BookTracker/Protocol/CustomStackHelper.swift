//
//  CustomStackProtocol.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/30/26.
//

import UIKit

protocol CustomStackHelper { }

extension CustomStackHelper {
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
    
    // 레이블 config 설정
    func setLabelConfig(_ label: UILabel, with info: Description) {
        let setting = info.getContentLabelSetting()
        label.font = setting.font
        label.textColor = setting.textColor
    }
}

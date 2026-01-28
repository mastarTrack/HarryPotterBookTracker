//
//  SeriesButton.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/27/26.
//
import UIKit

//MARK: Custom Components
// UILabel 생성자 정의
extension UILabel {
    convenience init(
        text: String,
        font: UIFont,
        color: UIColor
    ) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = color
    }
}

// 시리즈 버튼 원형 만들기
class SeriesButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

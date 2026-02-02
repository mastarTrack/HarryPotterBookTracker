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

// 더보기 버튼
class MoreButton: UIButton {
    weak var delegate: MoreButtonDelegate?
    
    func saveStatus(_ isMore: Bool) {
        delegate?.moreButtonSaveStatus(isMore)
    }
}

// 시리즈 버튼
class SeriesButton: UIButton {
    weak var delegate: SeriesButtonDelegate?
    
    func update(idx: Int) {
        delegate?.seriesButtonContentsUpdate(to: idx)
    }
}

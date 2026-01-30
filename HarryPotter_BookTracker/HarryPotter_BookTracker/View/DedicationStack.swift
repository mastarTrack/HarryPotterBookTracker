//
//  DedicationStack.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/30/26.
//
import UIKit

class DedicationStack: UIStackView, CustomStackHelper {
    private var label = UILabel()
    
    func set(info: Description) {
        let title = makeInfoTitleLabel(info)
        setLabelConfig(label, with: info)
        
        addArrangedSubview(title)
        addArrangedSubview(label)
        
        axis = .vertical
        spacing = 8
        alignment = .leading
    }
}

// MARK: 컨텐츠 설정
extension DedicationStack {
    func setContents(book: Book?, info: Description) {
        switch info {
        case .dedication:
            label.text = book?.dedication
        case .summary:
            label.text = book?.summary
        default:
            label.text = ""
        }
    }
}

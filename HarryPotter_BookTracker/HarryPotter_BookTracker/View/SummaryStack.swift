//
//  SummaryStack.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/30/26.
//
import UIKit

class SummaryStack: UIStackView, CustomStackHelper {
    let label = UILabel()
    let moreButton = MoreButton()

    func set(info: Description) {
        let title = makeInfoTitleLabel(info)
        setLabelConfig(label, with: info)
        label.numberOfLines = 0
        
        switch info {
        case .dedication:
            addArrangedSubview(title)
            addArrangedSubview(label)
            
            axis = .vertical
            alignment = .leading
            spacing = 8
            
        case .summary:
            setButtonConfig()
            
            let stackView = setVerticalLabelStack([title, label])
            addArrangedSubview(stackView)
            addArrangedSubview(moreButton)
            
            axis = .vertical
            alignment = .trailing
            spacing = 8
            
            if label.text?.count ?? 0 < 450 {
                moreButton.isHidden = true
            }
            
        default:
            break
        }
    }
}

//MARK: 컨텐츠 설정
extension SummaryStack {
    func setContents(book: Book?, info: Description, isMore: Bool? = nil) {
        switch info {
        case .dedication:
            label.text = book?.dedication
        case .summary: //
            if let isMore {
                label.text = getSummaryText(book, isMore: isMore)
                moreButton.isSelected = isMore
            }
        default:
            break
        }
    }
    
    func getSummaryText(_ book: Book?, isMore: Bool) -> String {
        let text = book?.summary ?? ""
        
        if isMore { // 더보기 버튼이 선택되어있을 경우
            return text
        } else { // 더보기 버튼이 선택되어있고, 450자 이상일 경우
            let idx = text.index(text.startIndex, offsetBy: 450)
            return text[..<idx] + "..."
        }
    }
}


//MARK: 버튼 Config 설정
extension SummaryStack {
    private func setButtonConfig() {
        moreButton.configurationUpdateHandler = { button in
            
            var configuration = UIButton.Configuration.plain()
            
            switch button.state {
            case .normal: // 선택하지 않았을 경우
                configuration.title = "더보기"
            case .selected: // 선택했을 경우
                configuration.title = "접기"
                configuration.baseBackgroundColor = .clear
            default: break
            }
            
            configuration.attributedTitle?.font = .systemFont(ofSize: 14)
            configuration.attributedTitle?.foregroundColor = .systemBlue
            
            button.configuration = configuration
        }
    }
}

//
//  SummaryStack.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/30/26.
//
import UIKit

class SummaryStack: UIStackView, CustomStackHelper {
    private let label = UILabel()
    let moreButton = MoreButton()

    func setDedicationStack() {
        let title = makeInfoTitleLabel(.dedication)
        setLabelConfig(label, with: .dedication)
        label.numberOfLines = 0
        
        addArrangedSubview(title)
        addArrangedSubview(label)
        
        axis = .vertical
        alignment = .leading
        spacing = 8
    }
    
    func setSummaryStack() {
        let title = makeInfoTitleLabel(.summary)
        setLabelConfig(label, with: .summary)
        label.numberOfLines = 0
        
        setButtonConfig()
        setButtonAction()
        
        let stackView = setVerticalLabelStack([title, label])
        addArrangedSubview(stackView)
        addArrangedSubview(moreButton)
        
        axis = .vertical
        alignment = .trailing
        spacing = 8
        
        if label.text?.count ?? 0 < 450 {
            moreButton.isHidden = true
        }
    }
}

//MARK: 컨텐츠 설정
extension SummaryStack {
    func setContents(of book: Book?, info: Description, isMore: Bool? = nil) {
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
    
    // 레이블 텍스트 설정
    private func getSummaryText(_ book: Book?, isMore: Bool) -> String {
        let text = book?.summary ?? ""
        
        if isMore { // 더보기 버튼이 선택되어있을 경우 (버튼 타이틀이 "접기"일 경우)
            return text
        } else { // 더보기 버튼이 선택되어있지 않을 경우 (버튼 타이틀이 "더보기"일 경우)
            return text.count < 450 ? text : text.prefix(450) + "..."
        }
    }
}

//MARK: 업데이트 동작 설정
extension SummaryStack {
    // 더보기 버튼 표시 유무
    func updateMoreButtonIsHidden() {
        moreButton.isHidden = label.text?.count ?? 0 < 450 ? true : false
    }
    
    // sumaryLabel 내용 업데이트
    func updateSummaryText(_ book: Book?) {
        label.text = getSummaryText(book, isMore: moreButton.isSelected)
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

//MARK: 버튼 액션 설정
extension SummaryStack {
    private func setButtonAction() {
        let buttonPushed = UIAction { [weak self] _ in
            guard let self else { return }
            
            moreButton.isSelected.toggle()
            moreButton.delegate?.saveStatus(moreButton.isSelected)
            moreButton.delegate?.updateSummaryStack()
        }
        
        moreButton.addAction(buttonPushed, for: .touchUpInside)
    }
}

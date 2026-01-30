//
//  TitleArea.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/30/26.
//
import UIKit

// 제목 영역
class SeriesButtonStack: UIStackView {
    private var seriesButtons = [UIButton]()
    
    func set() {
        setButtons()
        seriesButtons.forEach { addArrangedSubview($0) }
        alignment = .center
        spacing = 8
        distribution = .fillEqually
    }
    
    // 시리즈 버튼 배열 설정
    private func setButtons() {
        seriesButtons.enumerated().forEach { idx, button in
            setButtonConfig(button, idx: idx)
            button.tag = idx
        }
        seriesButtons.first?.isSelected = true
    }
}

//MARK: 컨텐츠 설정
extension SeriesButtonStack {
    func setContents(num: Int) {
        for _ in 0..<num {
            seriesButtons.append(UIButton())
        }
    }
}

//MARK: Config 설정
extension SeriesButtonStack {
    private func setButtonConfig(_ button: UIButton, idx: Int) {
        button.configurationUpdateHandler = { button in
            var configuration = UIButton.Configuration.filled()
            
            switch button.state {
            case .normal: // 선택하지 않았을 경우
                configuration.baseForegroundColor = .systemBlue
                configuration.baseBackgroundColor = .systemGray5
            case .selected: // 선택했을 경우
                configuration.baseBackgroundColor = .systemBlue
                configuration.attributedTitle?.foregroundColor = .white
            default: break
            }
            
            configuration.title = "\(idx + 1)"
            configuration.attributedTitle?.font = .systemFont(ofSize: 16)
            configuration.cornerStyle = .capsule // 원형 모양 설정
            
            button.configuration = configuration
        }
    }
}

extension ViewController {
    // 책 제목 레이블 설정
    func setTitleLabel(_ book: Book?) {
        titleLabel.text = book?.title ?? ""
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }

    // 시리즈 버튼 액션 설정
    func setSeriesButtonAction(_ button: UIButton) {
        // 버튼 액션 정의
        let buttonSelected = UIAction { [weak self] _ in
            self?.seriesButtons.forEach { $0.isSelected = false } // 모든 버튼 isSelected 초기화
            self?.selected = (Int(button.titleLabel?.text ?? "") ?? 1) - 1 // selected 변경
            
            button.isSelected = true
            self?.setContents() // 레이블 내용 변경
//            self?.updateChapterStack()
            self?.moreButton.isHidden =
            self?.summaryLabel.text?.count ?? 0 < 450 ? true : false // 더보기 버튼 표시 여부 설정
        }
        
        // 버튼에 액션 추가
        button.addAction(buttonSelected, for: .touchUpInside)
    }
}

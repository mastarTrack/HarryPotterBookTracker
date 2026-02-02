//
//  TitleArea.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/30/26.
//
import UIKit

// 제목 영역
class SeriesButtonStack: UIStackView {
    private(set) var seriesButtons = [SeriesButton]()

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
            setButtonAction(button)
        }
        seriesButtons.first?.isSelected = true
    }
}

//MARK: 버튼 수 설정
extension SeriesButtonStack {
    func setButtonNum(num: Int) {
        for _ in 0..<num {
            seriesButtons.append(SeriesButton())
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

//MARK: 버튼 액션 설정
extension SeriesButtonStack {
    private func setButtonAction(_ button: SeriesButton) {
        // 버튼 액션 정의
        let buttonSelected = UIAction { [unowned self] _ in
            let buttons = self.seriesButtons
            
            buttons.forEach { $0.isSelected = false } // 모든 버튼 isSelected 초기화
            button.isSelected = true // 선택된 버튼 상태 변경
            
            button.delegate?.seriesButtonContentsUpdate(to: button.tag) // 레이블 내용 변경
        }
        
        // 버튼에 액션 추가
        button.addAction(buttonSelected, for: .touchUpInside)
    }
}

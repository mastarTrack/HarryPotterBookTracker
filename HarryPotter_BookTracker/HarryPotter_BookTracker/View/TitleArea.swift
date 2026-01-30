//
//  TitleArea.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/30/26.
//
import UIKit

//MARK: 제목 영역
extension ViewController {
    // 책 제목 레이블 설정
    func setTitleLabel(_ book: Book?) {
        titleLabel.text = book?.title ?? ""
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
    
    // 시리즈 버튼 스택 생성
    func setSeriesButtonStack() -> UIStackView {
        setSeriesButtons()
        
        let stackView = UIStackView(arrangedSubviews: seriesButtons)
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        return stackView
    }
    
    // 시리즈 버튼 배열 설정
    func setSeriesButtons() {
        guard let num = books?.count else { return } // 생성할 버튼 갯수
        
        // 버튼 배열 할당
        seriesButtons = (1...num).reduce(into: []) { arr, n in
            // 버튼 생성
            let button = UIButton()
            
            // 버튼 configuration 설정
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
                
                configuration.title = "\(n)"
                configuration.attributedTitle?.font = .systemFont(ofSize: 16)
                configuration.cornerStyle = .capsule // 원형 모양 설정
                
                button.configuration = configuration
            }
        
            // 첫 번째 버튼 기본값 설정 - 앱 실행 시 1번 버튼이 기본값으로 선택되어 있도록 하기 위함
            n == 1 ? button.isSelected = true : ()
            
            // 버튼 액션 설정
            setSeriesButtonAction(button)
            
            // 버튼 배열에 추가
            arr.append(button)
        }
    }
    
    // 시리즈 버튼 액션 설정
    func setSeriesButtonAction(_ button: UIButton) {
        // 버튼 액션 정의
        let buttonSelected = UIAction { [weak self] _ in
            self?.seriesButtons.forEach { $0.isSelected = false } // 모든 버튼 isSelected 초기화
            self?.selected = (Int(button.titleLabel?.text ?? "") ?? 1) - 1 // selected 변경
            
            button.isSelected = true
            self?.setContents() // 레이블 내용 변경
            self?.moreButton.isHidden =
            self?.summaryLabel.text?.count ?? 0 < 450 ? true : false // 더보기 버튼 표시 여부 설정
        }
        
        // 버튼에 액션 추가
        button.addAction(buttonSelected, for: .touchUpInside)
    }
}

//
//  ViewController.swift
//  harrypotter
//
//  Created by 손영빈 on 1/22/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let titleText = UILabel()
    let seriesButton = SeriesButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }


}

extension ViewController {
    private func configUI() {
        view.backgroundColor = .white
        
        titleText.text = "ASDFASDFASDFASDFSADFSADFASDFSADFSADFSADFSADS"
        titleText.textColor = .black
        titleText.font = .systemFont(ofSize: 24, weight: .bold)
        titleText.numberOfLines = 0 // 줄 바꿈 제한 x
        titleText.textAlignment = .center // 텍스트 중앙 정렬
        
        seriesButton.setTitle("1", for: .normal)
        seriesButton.setTitleColor(.white , for: .normal)
        seriesButton.titleLabel?.font = .systemFont(ofSize: 16)
        seriesButton.backgroundColor = .systemBlue
//        seriesButton.layer.cornerRadius = 8
        
        [titleText, seriesButton].forEach { view.addSubview($0) }
        
        titleText.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        seriesButton.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleText.snp.bottom).offset(16)
            $0.width.equalTo(seriesButton.snp.height) // height에 width 고정 -> 가로, 세로 비율 유지
        }
        
    }
}

// UIButton 상속받는 커스텀 SeriesButton 생성 : ( 레이아웃 결정 이후 cornerRadius 적용되기 때문 )
class SeriesButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

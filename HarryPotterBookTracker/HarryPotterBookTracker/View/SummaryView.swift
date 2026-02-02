//
//  ViewSummaryLabel.swift
//  HarryPotterBookTracker
//
//  Created by Hanjuheon on 1/28/26.
//

import UIKit
import Foundation
import SnapKit

/// 개요 뷰 클래스
class SummaryView : UIView {

    /// 레이블
    private let label = UILabel()
    /// 더보기/접기 버튼
    private let button = UIButton()
    
    var onOffClosure: (() -> Void) = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI 설정 메소드
    private func configureUI()
    {
        //label.text = "ssssssss"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.addAction(UIAction {[weak self] _ in self?.onOffClosure()}, for: .touchDown)
        button.isHidden = true
        
        addSubview(label)
        addSubview(button)

        label.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        button.snp.makeConstraints{
            $0.top.equalTo(label.snp.bottom).offset(10)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    
    /// 레이블 더보기/접기 메소드
    func switchSummaryText(text: String, onOff: Bool){
        if text.count > 450{
            label.text = text
            button.setTitle( onOff ? "접기" : "더 보기" , for: .normal)
            button.isHidden = false
        } else {
            label.text = text
            button.isHidden = true
        }
    }
}

#Preview{
    SummaryView()
}

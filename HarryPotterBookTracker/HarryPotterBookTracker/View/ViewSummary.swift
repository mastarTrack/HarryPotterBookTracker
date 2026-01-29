//
//  ViewSummaryLabel.swift
//  HarryPotterBookTracker
//
//  Created by Hanjuheon on 1/28/26.
//

import UIKit
import Foundation
import SnapKit

class ViewSummary : UIView {

    /// 레이블
    private let label = UILabel()
    /// 더보기/접기 버튼
    private let button = UIButton()
    /// 레이블 표기 텍스트
    private var text = ""
    /// 더보기/접기 설정 값
    private var onOffFullText = false

    private let userDef = UserDefaults.standard
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        onOffFullText = userDef.bool(forKey: "onOff")
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 레이블 텍스트 설정 메소드
    func setLabelText(_ text:String)
    {
        self.text = text
        if text.count > 450 {
            button.isHidden = false
        } else {
            button.isHidden = true
        }
        switchFullText()
    }
    
    /// UI 설정 메소드
    private func configureUI()
    {
        //label.text = "ssssssss"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        button.setTitle( onOffFullText ? "접기" : "더 보기" , for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.addTarget(self, action: #selector(switchDownBotton), for: .touchDown)
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
    @objc
    func switchDownBotton(){
        onOffFullText = onOffFullText ? false : true
        switchFullText()
    }
    
    /// 레이블 더보기/접기 메소드
    func switchFullText(){
        if text.count > 450{
            label.text = !onOffFullText ? String(text.prefix(450)) + "..." : text
            button.setTitle( onOffFullText ? "접기" : "더 보기" , for: .normal)
        }
        userDef.set(onOffFullText, forKey: "onOff")
        userDef.synchronize()
    }
}

#Preview{
    ViewSummary()
}

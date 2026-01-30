//
//  SummaryViewController.swift
//  HarryPotterBookTracker
//
//  Created by Hanjuheon on 1/30/26.
//

import UIKit

class SummaryViewController : UIViewController {
    
    /// 책 넘버 Int
    private var bookNumber = 0
    /// 레이블 표기 텍스트
    private var text = ""
    /// 더보기/접기 설정 값
    private var onOffFullText = false
    /// 데이터저장소 선언
    private let userDef = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    /// 레이블 텍스트 설정 메소드
    func setLabelText(_ text:String, _ number: Int)
    {
        bookNumber = number
        onOffFullText = userDef.bool(forKey: "onOff_\(bookNumber)")
        self.text = text

        switchFullText()
    }
    
    /// 레이블 더보기/접기 메소드
    func switchFullText(){
//        if text.count > 450{
//            label.text = !onOffFullText ? String(text.prefix(450)) + "..." : text
//            button.setTitle( onOffFullText ? "접기" : "더 보기" , for: .normal)
//        } else {
//            label.text = text
//        }
//        userDef.set(onOffFullText, forKey: "onOff_\(bookNumber)")
//        userDef.synchronize()
    }
}

//
//  UILabel.swift
//  YSBookTracker
//
//  Created by Yeseul Jang on 2/2/26.
//
import Foundation
import UIKit

extension UILabel {
    func apply(_ config: LabelConfiguration) {
        self.font = config.font
        self.textColor = config.color
        self.numberOfLines = config.lines
    }
    
    convenience init(text: String, config: LabelConfiguration) {
        self.init()
        self.text = text
        apply(config)
    }
}

//
//  Untitled.swift
//  YSBookTracker
//
//  Created by Yeseul Jang on 1/30/26.
//
import UIKit

struct LabelConfiguration {
    let font: UIFont
    let color: UIColor
    let lines: Int
}

extension LabelConfiguration {
    static let HeaderTitle = LabelConfiguration(
        font: .systemFont(ofSize: 24, weight: .bold),
        color: .black,
        lines: 0
    )
    
    static let boldAnd20 = LabelConfiguration(
        font: .systemFont(ofSize: 20, weight: .bold),
        color: .black,
        lines: 0
    )
    
    static let boldAnd16 = LabelConfiguration(
        font: .systemFont(ofSize: 16, weight: .bold),
        color: .black,
        lines: 1
    )
    
    static let boldAnd14 = LabelConfiguration(
        font: .systemFont(ofSize: 14, weight: .bold),
        color: .black,
        lines: 1
    )
    
    static let boldAnd18 = LabelConfiguration(
        font: .systemFont(ofSize: 18, weight: .bold),
        color: .black,
        lines: 0
    )
    
    static let darkGrayAnd18 = LabelConfiguration(
        font: .systemFont(ofSize: 18),
        color: .darkGray,
        lines: 0
    )
    
    static let grayAnd14 = LabelConfiguration(
        font: .systemFont(ofSize: 14),
        color: .gray,
        lines: 0
    )
    
    static let darkGrayAnd14 = LabelConfiguration(
        font: .systemFont(ofSize: 14),
        color: .darkGray,
        lines: 0
    )
}

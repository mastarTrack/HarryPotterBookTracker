//
//  Helper.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/26/26.
//

import Foundation
import UIKit

enum Description: String {
    case author = "Author"
    case pages = "Pages"
    case release_date = "Released"
    case dedication = "Dedication"
    case summary = "Summary"
    case chapter = "Chapter"
    // wiki, chapters
    
    func getTitleLabelSetting() -> LabelSetting {
        switch self {
        case .author:
            return LabelSetting(font: .boldSystemFont(ofSize: 16), textColor: .black)
        case .pages, .release_date:
            return LabelSetting(font: .boldSystemFont(ofSize: 14), textColor: .black)
        case .dedication, .summary, .chapter:
            return LabelSetting(font: .boldSystemFont(ofSize: 18), textColor: .black)
        }
    }
    
    func getContentLabelSetting() -> LabelSetting {
        switch self {
        case .author:
            return LabelSetting(font: .systemFont(ofSize: 18), textColor: .darkGray)
        case .pages, .release_date:
            return LabelSetting(font: .systemFont(ofSize: 14), textColor: .gray)
        case .dedication, .summary, .chapter:
            return LabelSetting(font: .systemFont(ofSize: 14), textColor: .darkGray)
        }
    }
}

enum DataError: Error {
    case fileNotFound
    case parsingFailed (Error)
    case emptyData
}

struct LabelSetting {
    var font: UIFont
    var textColor: UIColor
}

enum Summary {
    case origin
    case brief
}

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
    // wiki, chapters
    
    func getTitleLabelSetting() -> LabelSetting {
        switch self {
        case .author:
            return LabelSetting(font: .boldSystemFont(ofSize: 16), textColor: .black)
        case .pages, .release_date:
            return LabelSetting(font: .boldSystemFont(ofSize: 14), textColor: .black)
        case .dedication, .summary:
            return LabelSetting(font: .boldSystemFont(ofSize: 18), textColor: .black)
        }
    }
}

enum DataError: Error {
    case fileNotFound
    case parsingFailed (Error)
    case invalidNumberOfBooks
}

struct LabelSetting {
    var font: UIFont
    var textColor: UIColor
}

enum Summary {
    case origin
    case brief
}

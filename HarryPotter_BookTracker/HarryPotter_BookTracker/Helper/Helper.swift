//
//  Helper.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/26/26.
//

import Foundation

enum Description: String {
    case title
    case author = "Author"
    case pages = "Pages"
    case release_date = "Released"
    //, dedication, summary, wiki, chapters
}

enum DataError: Error {
    case fileNotFound
    case parsingFailed (Error)
    case invalidNumberOfBooks
}

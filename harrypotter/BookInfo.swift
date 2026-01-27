//
//  BookInfo.swift
//  harrypotter
//
//  Created by 손영빈 on 1/22/26.
//

import Foundation

struct BookResponse: Codable {
    let data: [BookData]
}

struct BookData: Codable {
    let attributes: Book
}

struct Book: Codable {
    let title: String
    let author: String
    let pages: Int
    let releaseDate: String
    let summary: String
    let dedication: String
    let chapters: [Chapter]
    
    // data.json 형식 맞추기 : releaseDate는 data.json의 release_date
    enum CodingKeys: String, CodingKey {
        case title, author, pages, summary, dedication, chapters
        case releaseDate = "release_date"
    }
    
    // releaseData로 넘어온 형식 변경
    var releaseDateFormatted: String {
        
        // String -> Date로 변경
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Date로 변경된 정보를 통해 순서 변경, MMMM, en_US로 locale 선언 : 07 -> July로 변경
        let dateToStringFormatter = DateFormatter()
        dateToStringFormatter.dateFormat = "MMMM d, yyyy"
        dateToStringFormatter.locale = Locale(identifier: "en_US")
        
        let date = dateFormatter.date(from: releaseDate)! // 적용
        return dateToStringFormatter.string(from: date) // 다시 String으로 반환
        
    }
    
}

struct Chapter: Codable {
    let title: String
}

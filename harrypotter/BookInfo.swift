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
}

struct Chapter: Codable {
    let title: String
}

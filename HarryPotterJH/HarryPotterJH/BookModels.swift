//
//  BookModels.swift
//  HarryPotterJH
//
//  Created by 김주희 on 1/23/26.
//

import Foundation

// 최상위 응답
struct BookResponse: Decodable { // JSON 전체는 data라는 배열 하나를 가진다
    let data: [BookData]
}

// data 배열 안의 요소
struct BookData: Decodable {
    let attributes: Book // data 배열 안에는 attributes라는 책 정보가 있다
}

// 실제 우리가 쓰는 책 모델
struct Book: Decodable {
    let title: String
    let author: String
    let pages: Int
    let releaseDate: String
    let dedication: String
    let summary: String
    let wiki: String
    let chapters: [Chapter]

    enum CodingKeys: String, CodingKey {
        case title
        case author
        case pages
        case releaseDate = "release_date"
        case dedication
        case summary
        case wiki
        case chapters
    }
}

// 챕터 모델
struct Chapter: Decodable {
    let title: String
}

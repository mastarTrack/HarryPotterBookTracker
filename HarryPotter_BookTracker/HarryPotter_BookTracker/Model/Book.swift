//
//  Book.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/26/26.
//

import Foundation

struct BookResponse: Codable {
    let data: [Attributes]
}

struct Attributes: Codable {
    let attributes: Book
}

struct Book: Codable {
    let title: String
    let author: String
    let pages: Int
    let releaseDate: Date
    let dedication: String
    let summary: String
    let wiki: String
    let chapters: [Chapters]

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

struct Chapters: Codable {
    let title: String
}

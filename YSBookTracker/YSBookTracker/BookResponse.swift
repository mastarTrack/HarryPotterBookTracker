//
//  BookResponse.swift
//  YSBookTracker
//
//  Created by Yeseul Jang on 1/23/26.
//
import Foundation

struct BookResponse: Codable {
    let data: [BookItem]
}

struct BookItem: Codable {
    let attributes: Book
}

struct Book: Codable {
    let title: String
    let author: String
    let pages: Int
    let releaseDate: String
    let dedication: String
    let summary: String
    let wiki: String
    let chapters: [Chapter]

    enum CodingKeys: String, CodingKey {
        case title, author, pages, dedication, summary, wiki, chapters
        case releaseDate = "release_date"
    }
}

struct Chapter: Codable {
    let title: String
}


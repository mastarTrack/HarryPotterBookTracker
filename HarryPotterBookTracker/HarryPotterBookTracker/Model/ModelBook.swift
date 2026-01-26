//
//  ModelBook.swift
//  HarryPotterBookTracker
//
//  Created by Hanjuheon on 1/23/26.
//

struct Book : Codable {
    var title: String
    var author: String
    var pages: Int
    var release_date: String
    var dedication: String
    var summary: String
    var wiki: String
    var chapters: [Chapter]
}

struct Chapter: Codable {
    let title: String
}

struct BookData: Codable {
    var attributes: Book
}

struct BookResponse: Codable {
    var data: [BookData]
}

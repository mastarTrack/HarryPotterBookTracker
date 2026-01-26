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
    let release_date: String
    let dedication: String
    let summary: String
    let wiki: String
    let chapters: [Chapters]
}

struct Chapters: Codable {
    let title: String
}

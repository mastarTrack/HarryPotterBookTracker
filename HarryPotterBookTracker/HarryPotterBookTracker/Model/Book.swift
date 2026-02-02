//
//  ModelBook.swift
//  HarryPotterBookTracker
//
//  Created by Hanjuheon on 1/23/26.
//

/// 책 정보 모델
struct Book : Codable {
    /// 책 타이틀
    var title: String
    /// 책 저자
    var author: String
    /// 책 페이지
    var pages: Int
    /// 책 발행연도
    var release_date: String
    /// 책 헌사
    var dedication: String
    /// 책 개요
    var summary: String
    /// 위키 사이트 주소
    var wiki: String
    /// 책 목차
    var chapters: [Chapter]
    
    func changeSummaryText(_ isFull: Bool) -> String {
        return isFull ? summary : String(summary.prefix(450)) + "..."
    }
}

/// 목차 모델
struct Chapter: Codable {
    /// 목차 제목
    let title: String
}

struct BookData: Codable {
    var attributes: Book
}

struct BookResponse: Codable {
    var data: [BookData]
}

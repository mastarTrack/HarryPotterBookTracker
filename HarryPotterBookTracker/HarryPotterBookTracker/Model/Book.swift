//
//  ModelBook.swift
//  HarryPotterBookTracker
//
//  Created by Hanjuheon on 1/23/26.
//

/// 책 정보 모델
struct Book : Codable {
    /// 책 타이틀
    let title: String
    /// 책 저자
    let author: String
    /// 책 페이지
    let pages: Int
    /// 책 발행연도
    let release_date: String
    /// 책 헌사
    let dedication: String
    /// 책 개요
    let summary: String
    /// 위키 사이트 주소
    let wiki: String
    /// 책 목차
    let chapters: [Chapter]
    
    func changeSummaryText(_ isFull: Bool) -> String {
        if summary.count > 450 {
            return isFull ? summary : String(summary.prefix(450)) + "..."
        } else {
            return summary
        }
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

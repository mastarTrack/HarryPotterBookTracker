//
//  DataManager.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/26/26.
//
import Foundation

class DataManager {
    private var books: [Book] = []
    let isMoreKey = "isMore"
    
    func loadBooks() throws -> [Book] {
        // data.json 파일 주소 가져오기
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            throw DataError.fileNotFound
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 날짜 형식 설정
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter) // JSONDecoder의 날짜 디코딩 형식 설정
        
        do {
            let data = try Data(contentsOf: URL(filePath: path)) // data.json 파일 데이터 가져오기
            let bookResponse = try decoder.decode(BookResponse.self, from: data) // BookResponse 타입으로 Json 디코딩
            let books = bookResponse.data.map { $0.attributes } // Book 타입 배열로 가져오기
            return books // 결과로 사용
        } catch {
            throw DataError.parsingFailed(error)
        }
    }
    
    func fetchBook(num: Int) throws -> Book {
        // books 배열이 비었다면 가져오기
        if books.isEmpty { books = try loadBooks() }
        
        let i = num - 1
        
        if books.indices.contains(i) { // 인덱스가 유효할 경우
            return books[i]
        } else { // 유효하지 않을 경우
            throw DataError.invalidNumberOfBooks
        }
    }
    
    func setMoreStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: isMoreKey)
    }
}

extension DataManager: MoreButtonDelegate {
    func saveStatus(_ isMore: Bool) {
        UserDefaults.standard.set(isMore, forKey: isMoreKey)
    }
}

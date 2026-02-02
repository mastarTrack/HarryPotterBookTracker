//
//  DataManager.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/26/26.
//
import Foundation

class DataManager {
    private let isMoreBaseKey = "isMore_"
    
    // JSON 데이터 파싱
    private func loadBooks() throws -> [Book] {
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
    
    // 데이터(책 배열) 전달
    func fetchBooks() throws -> [Book] {
        let books = try loadBooks()
        if books.isEmpty { throw DataError.emptyData }
        
        return books
    }
}

//MARK: UserDefault 데이터 관련
extension DataManager {
    func fetchMoreStatus(idx: Int) -> Bool {
        return UserDefaults.standard.bool(forKey: isMoreBaseKey + "\(idx)")
    }
    
    func saveMoreStatus(_ isMore: Bool, idx: Int) {
        UserDefaults.standard.set(isMore, forKey: isMoreBaseKey + "\(idx)")
    }
}

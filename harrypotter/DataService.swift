//
//  DataService.swift
//  harrypotter
//
//  Created by 손영빈 on 1/22/26.
//

import Foundation

class DataService {
    
    enum DataError: Error {
        case fileNotFound
        case parsingFailed
    }
    
    func loadBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            completion(.failure(DataError.fileNotFound))
            return
        }
        
        do { // 파싱 시 releaseDate를 String -> Date로 반환
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            
            let decoder = JSONDecoder() // 디코더 생성
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // 형식 생성
            decoder.dateDecodingStrategy = .formatted(dateFormatter) // decoder에 형식을 주입
            
            let bookResponse = try decoder.decode(BookResponse.self, from: data) // 형식에 맞는 데이터 발견할 시 Date로 변환
            let books = bookResponse.data.map { $0.attributes }
            completion(.success(books))
        } catch {
            print("🚨 JSON 파싱 에러 : \(error)")
            completion(.failure(DataError.parsingFailed))
        }
    }
}

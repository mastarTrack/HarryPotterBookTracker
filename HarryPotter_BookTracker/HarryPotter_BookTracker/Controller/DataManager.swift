//
//  DataManager.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/26/26.
//
import Foundation

class DataManager {
    enum DataError: Error {
        case fileNotFound
        case parsingFailed
    }
    
    func loadBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        // data.json 파일 주소 가져오기
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            completion(.failure(DataError.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(filePath: path)) // data.json 파일 데이터 가져오기
            let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data) // BookResponse 타입으로 Json 디코딩
            let books = bookResponse.data.map { $0.attributes } // Book 타입 배열로 가져오기
            completion(.success(books)) // 결과로 사용
        } catch {
            print("⛔️ JSON 파싱 에러: \(error)")
            completion(.failure(DataError.parsingFailed))
        }
    }
    
    func fetchData() -> [Book] {
        var data: [Book] = []
        loadBooks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let books):
                data = books
            case .failure(let error):
                print("⛔️ 알 수 없는 에러: \(error)")
            }
        }
        return data
    }
}

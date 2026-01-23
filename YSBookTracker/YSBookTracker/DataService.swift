//
//  DataService.swift
//  YSBookTracker
//
//  Created by Yeseul Jang on 1/23/26.
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
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
            let books = bookResponse.data.map { $0.attributes }
            completion(.success(books))
        } catch {
            print("🚨 JSON 파싱 에러 : \(error)")
            completion(.failure(DataError.parsingFailed))
        }
    }
}
/* 사용부
 private let dataService = DataService()
 
 func loadBooks() {
     dataService.loadBooks { [weak self] result in
         guard let self = self else { return }
         
         switch result {
         case .success(let books):
             
             
         case .failure(let error):
         }
     }
 }
 */

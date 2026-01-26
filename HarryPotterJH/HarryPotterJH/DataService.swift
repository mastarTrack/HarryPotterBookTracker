//
//  DataService.swift
//  HarryPotterJH
//
//  Created by 김주희 on 1/23/26.
//
import Foundation

class DataService { // json을 [Book] 배열로 바꾸는 역할 담당
    
    enum DataError: Error {
        case fileNotFound // data.json이 앱에 존재x
        case parsingFailed // JSON -> Swift 변환 실패
    }
    
    func loadBooks(completion: @escaping (Result<[Book], Error>) -> Void) { // 성공하면 [Book], 실패하면 Error를 돌려줌
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {// (1번 안전장치) data.json 파일이 있는지 확인
            completion(.failure(DataError.fileNotFound))
            return
        }
        
        do { // (2번 안전장치) 파일 읽고 JSON 파싱
            let data = try Data(contentsOf: URL(fileURLWithPath: path)) // 파일 내용을 메모리로 읽어옴
            let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data) // JSON을 Swift구조체(bookResponse)로 변환
            let books = bookResponse.data.map { $0.attributes } // bookResponse.data는 배열이고 우리가 쓰고싶은건 attributes임
            completion(.success(books)) // 성공
        } catch { // 실패
            print("🚨 JSON 파싱 에러 : \(error)")
            completion(.failure(DataError.parsingFailed))
        }
    }
}


 

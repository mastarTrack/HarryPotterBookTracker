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
    
    static var shared = DataManager()
    private var books: [Book] = []
    
    func loadBooks() throws -> [Book] {
        // data.json 파일 주소 가져오기
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            throw DataError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: URL(filePath: path)) // data.json 파일 데이터 가져오기
            let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data) // BookResponse 타입으로 Json 디코딩
            let books = bookResponse.data.map { $0.attributes } // Book 타입 배열로 가져오기
            return books // 결과로 사용
        } catch {
            print("⛔️ JSON 파싱 에러: \(error)")
            throw DataError.parsingFailed
        }
    }
    
    func fetchData() {        
        do {
           books = try loadBooks()
        } catch DataError.fileNotFound {
            print("⛔️ 파일을 찾을 수 없습니다.")
        } catch {
            print("⛔️ 알 수 없는 오류: \(error)")
        }
    }
    
    func fetchInfo(num: Int, info: Description) -> String {
        if books.isEmpty { fetchData() }
        
        let i = num - 1
        
        switch info {
        case .title: return books[i].title
        case .author: return books[i].author
        case .pages: return String(books[i].pages)
        case .release_date: return formatDate(books[i].release_date)
        }
    }
    
    func formatDate(_ released: String) -> String {
        // date 타입 얻기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: released)

        // dateFormat 설정
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMMM dd, yyyy"

        // June 26, 1997 형태의 문자열 반환
        return newFormatter.string(from: date!)
    }
    
}

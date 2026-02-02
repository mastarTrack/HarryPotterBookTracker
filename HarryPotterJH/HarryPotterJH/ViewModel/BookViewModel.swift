//
//  BookViewModel.swift
//  HarryPotterJH
//
//  Created by 김주희 on 1/30/26.
//
import Foundation
import UIKit

// MARK: -- (데이터 계산, 날짜 변환, 클릭 로직 등)

class BookViewModel {
    
    // 프로퍼티
    private let dataService = DataService() // 데이터서비스 인스턴스 생성
    
    var books: [Book] = []
    var index = 0
    var isExpanded = false
    
    // 데이터가 변경되었음을 ViewController에게 알리기 위한 클로저
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    
    // MARK: - Logic Methods
    
    // 책 데이터 불러오기
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                self.books = books
                self.onDataUpdated?() // VC에게 데이터가 왔으니 화면 갱신하라는 알림
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    // 현재 보여줄 책 데이터 반환
    var currentBook: Book? {
        guard books.indices.contains(index) else { return nil } // index가 books 안에 진짜 존재할 때만 실행
        return books[index]
    }
    
    
    // MARK: -- button Function
    
    // 시리즈 버튼 클릭시 인덱스 변경 로직
    func selectSeries(at number: Int) {
        self.index = number - 1
        // 인덱스가 변경되면 요약 버튼 상태도 새로 불러와야함
        self.isExpanded = UserDefaults.standard.bool(forKey: "isExpanded_\(index)")
        self.onDataUpdated?()// 데이터가 변경됨을 vc에게 알림
    }

    // 요약 버튼 토글 로직
    func toggleSummary() {
        isExpanded.toggle()
        UserDefaults.standard.set(isExpanded, forKey: "isExpanded_\(index)")
        onDataUpdated?() // 데이터가 변경됨을 vc에 알림
    }
    
    // date 포맷팅 함수
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) { // 문자열을 date형식으로 변환
            formatter.dateStyle = .long // 출력용 날짜 스타일
            return formatter.string(from: date) // date를 문자열로 다시 변환
        }
        return dateString // 실패하면 원본 반환
    }
}

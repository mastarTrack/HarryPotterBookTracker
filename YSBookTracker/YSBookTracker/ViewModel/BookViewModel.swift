//
//  BookViewModel.swift
//  YSBookTracker
//
//  Created by Yeseul Jang on 1/29/26.
//
import UIKit
// 뷰에 들어갈 정보를 가공헤서 전달
final class BookViewModel {
    // 뷰에 전달해 줄 것들
    var updateInfo: ((BookViewInfo) -> Void)?
    var error: ((Error) -> Void)?
    
    private let dataService: BookServiceProtocol
    
    private var books: [Book] = []
    private var selectedVolume = 1
    private var isExpanded = false
    
    init(dataService: BookServiceProtocol) {
        self.dataService = dataService
    }
    
   func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    self.books = books
                    self.updateBookInfo()
                    self.restoreExpandedState()

                case .failure(let error):
                    self.error?(error)
                }
            }
        }
    }
    
    func showSummary() {
        isExpanded.toggle()
        saveExpandedState()
        updateBookInfo()
    }
    
    private func saveExpandedState() {
        UserDefaults.standard.set(isExpanded, forKey: DefaultsKey.isExpanded)
    }

    private func restoreExpandedState() {
        isExpanded = UserDefaults.standard.bool(forKey: DefaultsKey.isExpanded)
    }
    
    func selectBook(volume: Int) {
        guard books.indices.contains(volume - 1) else { return }
        selectedVolume = volume
        isExpanded = false
        updateBookInfo()
    }
    
    private func updateBookInfo() {
        guard books.indices.contains(selectedVolume - 1) else { return }
        let book = books[selectedVolume - 1]
        
        let needsFold = book.summary.count > 450
        let summaryText: String
        let showMoreTitle: String
        
        if isExpanded || !needsFold {
            summaryText = book.summary
            showMoreTitle = "접기"
        } else {
            summaryText = String(book.summary.prefix(450)) + "..."
            showMoreTitle = "더보기"
        }
        
        let info = BookViewInfo(
            title: book.title,
            authorName: "J. K. Rowling",
            releasedDate: book.releaseDate.changeToUSADate() ?? "날짜 오류",
            pages: String(book.pages),
            dedication: book.dedication,
            summary: summaryText,
            showMoreTitle: showMoreTitle,
            isShowMoreHidden: !needsFold,
            coverImageName: "harrypotter\(selectedVolume)",
            chapterTitles: book.chapters.map { $0.title }
        )
        
        updateInfo?(info)
    }
}

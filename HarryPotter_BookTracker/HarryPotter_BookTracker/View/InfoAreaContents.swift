//
//  InfoAreaContents.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/30/26.
//

import UIKit
import SnapKit

//MARK: 정보 영역 내용 설정
extension ViewController {
    // 책 이미지 설정
    func setBookImage(_ selected: Int) {
        bookImageView.image = UIImage(named: "harrypotter" + "\(selected + 1)")
        bookImageView.contentMode = .scaleAspectFit
        
        bookImageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(bookImageView.snp.width).multipliedBy(1.5)
        }
    }
    
    // 정보 레이블 설정
    func setContentLabel(_ book: Book?) {
        infoBookTitleLabel.text = book?.title ?? ""
        infoBookTitleLabel.font = .boldSystemFont(ofSize: 20)
        infoBookTitleLabel.textColor = .black
        infoBookTitleLabel.numberOfLines = 0
        
        authorLabel.text = book?.author ?? ""
        authorLabel.font = .systemFont(ofSize: 18)
        authorLabel.textColor = .darkGray
        
        pagesLabel.text = "\(book?.pages ?? 0)"
        pagesLabel.font = .systemFont(ofSize: 14)
        pagesLabel.textColor = .gray

        releasedDateLabel.text = formatDate(book?.release_date)
        releasedDateLabel.font = .systemFont(ofSize: 14)
        releasedDateLabel.textColor = .gray
        
        dedicationLabel.text = book?.dedication ?? ""
        dedicationLabel.font = .systemFont(ofSize: 14)
        dedicationLabel.textColor = .darkGray
        dedicationLabel.numberOfLines = 0
        
        summaryLabel.text = getSummaryText()
        summaryLabel.font = .systemFont(ofSize: 14)
        summaryLabel.textColor = .darkGray
        summaryLabel.numberOfLines = 0
    }
    
    // summary 내용 설정
    func getSummaryText() -> String {
        let book = books?[selected]
        let text = book?.summary ?? ""
        
        if isMore { // 더보기 버튼이 선택되어있을 경우
            return text
        } else if text.count < 450 { // 더보기 버튼이 선택되어있고, 450자 미만일 경우
            return text
        } else { // 더보기 버튼이 선택되어있고, 450자 이상일 경우
            let idx = text.index(text.startIndex, offsetBy: 450)
            return text[..<idx] + "..."
        }
    }
    
    // 날짜 포맷 설정
    func formatDate(_ released: Date?) -> String {
        guard let date = released else { return "" }
        
        // dateFormat 설정
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMMM dd, yyyy"
        
        // June 26, 1997 형태의 문자열 반환
        return newFormatter.string(from: date)
    }
}

//
//  InfoAreaContents.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/30/26.
//
import UIKit
import SnapKit

class InfoStack: UIStackView, CustomStackHelper {
    private var bookImageView = UIImageView()
    private var titleLabel = UILabel()
    private var authorLabel = UILabel()
    private var releasedDateLabel = UILabel()
    private var pagesLabel = UILabel()
    
    func set() {
        setContentLabelConfigs()
        setImageViewConfig()
        
        let labelStack = setLabelStack()
        addArrangedSubview(bookImageView)
        addArrangedSubview(labelStack)
        
        axis = .horizontal
        spacing = 16
        alignment = .top
    }
}

//MARK: 컨텐츠 설정
extension InfoStack {
    func setContents(book: Book?, idx: Int) {
        bookImageView.image = UIImage(named: "harrypotter" + "\(idx + 1)")
        titleLabel.text = book?.title
        authorLabel.text = book?.author
        releasedDateLabel.text = formatDate(book?.release_date)
        pagesLabel.text = "\(book?.pages ?? 0)"
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        
        // dateFormat 설정
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMMM dd, yyyy"
        
        // June 26, 1997 형태의 문자열 반환
        return newFormatter.string(from: date)
    }
}

//MARK: Config 설정
extension InfoStack {
    // 레이블 config 설정
    private func setContentLabelConfigs() {
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        
        setLabelConfig(authorLabel, with: .author)
        setLabelConfig(releasedDateLabel, with: .release_date)
        setLabelConfig(pagesLabel, with: .pages)
    }
    
    // 이미지뷰 config 설정
    private func setImageViewConfig() {
        bookImageView.contentMode = .scaleAspectFit
        
       bookImageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(bookImageView.snp.width).multipliedBy(1.5)
        }
    }
}

//MARK: 스택 생성
extension InfoStack {
    // 수직 레이블 스택 생성
    private func setHorizontalLabelStack(_ views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }
    
    // 전체 레이블 스택 생성
    private func setLabelStack() -> UIStackView {
        let authorTitle = makeInfoTitleLabel(.author)
        let author = setHorizontalLabelStack([authorTitle, authorLabel])
        
        let releasedDateTitle = makeInfoTitleLabel(.release_date)
        let releasedDate = setHorizontalLabelStack([releasedDateTitle, releasedDateLabel])
        
        let pagesTitle = makeInfoTitleLabel(.pages)
        let pages = setHorizontalLabelStack([pagesTitle, pagesLabel])
        
        return setVerticalLabelStack([titleLabel, author, releasedDate, pages])
    }
}


extension ViewController {


    
    // 정보 레이블 설정
    func setContentLabel(_ book: Book?) {

        
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

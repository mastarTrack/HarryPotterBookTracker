//
//  InfoAreaContents.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/30/26.
//
import UIKit
import SnapKit

class InfoStack: UIStackView, CustomStackHelper {
    private let bookImageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let releasedDateLabel = UILabel()
    private let pagesLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        set()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func set() {
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
    func setContents(of book: Book?, idx: Int) {
        bookImageView.image = UIImage(named: "harrypotter" + "\(idx + 1)")
        titleLabel.text = book?.title
        authorLabel.text = book?.author
        releasedDateLabel.text = formatDate(book?.releaseDate)
        pagesLabel.text = "\(book?.pages ?? 0)"
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date else { return "" }
        
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

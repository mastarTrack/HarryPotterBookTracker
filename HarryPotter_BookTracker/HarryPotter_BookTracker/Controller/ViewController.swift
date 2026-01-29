//
//  ViewController.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/23/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let dataManager = DataManager()
    private var selected = 1
    private var book: Book?
    
    private var titleLabel = UILabel() // 최상단 제목 레이블
    private var seriesButton = SeriesButton()
    
    private var bookImageView = UIImageView()
    private var infoBookTitleLabel = UILabel()
    private var authorLabel = UILabel()
    private var releasedDateLabel = UILabel()
    private var pagesLabel = UILabel()
    
    private var dedicationLabel = UILabel()
    private var summaryLabel = UILabel()
    
    private var moreButton = UIButton()
    private var isMore = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        book = getBook(selected)
        
        setTitleLabel(book)
        setContentLabel(book)
        setBookImage(num: selected)
        setMoreButton()
        
        setUI()
        
        setMoreButtonAction()
    }
    
    func setUI() {
        view.backgroundColor = .white
        
        let seriesButton = setSeriesButton()
        let infoScroll = setInfoScroll(of: book)
        
        [titleLabel, seriesButton, infoScroll].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        seriesButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        infoScroll.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(seriesButton.snp.bottom).offset(16)
        }
    }
    
    //TODO: contentView 없이는 못할까?
    func setInfoScroll(of book: Book?) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        let infoStack = setInfoStack(of: book)
        contentView.addSubview(infoStack)
        
        infoStack.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        let dedicationStack = setSummaryLabelStack(of: book, info: .dedication)
        contentView.addSubview(dedicationStack)
        
        dedicationStack.snp.makeConstraints {
            $0.top.equalTo(infoStack.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        let summaryStack = setSummaryStack(of: book)
        contentView.addSubview(summaryStack)
        
        summaryStack.snp.makeConstraints {
            $0.top.equalTo(dedicationStack.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        let chapterStack = makeChapterStack(of: book)
        contentView.addSubview(chapterStack)
        
        chapterStack.snp.makeConstraints {
            $0.top.equalTo(summaryStack.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        return scrollView
    }

}

//MARK: 제목 영역
extension ViewController {
    // 책 제목 레이블 설정
    func setTitleLabel(_ book: Book?) {
        titleLabel.text = book?.title ?? ""
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
    
    // 시리즈 버튼 생성
    func setSeriesButton() -> SeriesButton {
        let button = SeriesButton()
        button.setTitle("1", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .systemBlue
        
        return button
    }
}

//MARK: 정보 영역
extension ViewController {
    // 책 이미지 설정
    func setBookImage(num: Int) {
        bookImageView.image = UIImage(named: "harrypotter" + "\(num)")
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
        
        summaryLabel.text = isMore ? getSummaryText(.origin) : getSummaryText(.brief)
        summaryLabel.font = .systemFont(ofSize: 14)
        summaryLabel.textColor = .darkGray
        summaryLabel.numberOfLines = 0
    }
    
    // summary 내용 설정 함수
    func getSummaryText(_ type: Summary) -> String {
        let text = book?.summary ?? ""
        
        switch type {
        case .origin:
            return text
        case .brief:
            let idx = text.index(text.startIndex, offsetBy: 450)
            return text[..<idx] + "..."
        }
    }
    
    // 정보 타이틀 레이블 생성
    func makeInfoTitleLabel(_ info: Description) -> UILabel {
        let text = info.rawValue
        let setting = info.getTitleLabelSetting()
        
        let label = UILabel(text: text, font: setting.font, color: setting.textColor)
        
        return label
    }
    
    // 정보 레이블 스택 생성
    func setInfoLabelStack() -> UIStackView {
        let authorTitle = makeInfoTitleLabel(.author)
        let authorStack = UIStackView(arrangedSubviews: [authorTitle, authorLabel])
        
        let releasedTitle = makeInfoTitleLabel(.release_date)
        let releasedStack = UIStackView(arrangedSubviews: [releasedTitle, releasedDateLabel])
        
        let pagesTitle = makeInfoTitleLabel(.pages)
        let pagesStack = UIStackView(arrangedSubviews: [pagesTitle, pagesLabel])
        
        [authorStack, releasedStack, pagesStack].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        let stackView = UIStackView(arrangedSubviews: [infoBookTitleLabel, authorStack, releasedStack, pagesStack])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        
        return stackView
    }
        
    // 정보 영역 스택 생성
    func setInfoStack(of book: Book?) -> UIStackView {
        let labels = setInfoLabelStack()
        
        let stackView = UIStackView(arrangedSubviews: [bookImageView, labels])
        
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .top
        
        return stackView
    }
}

//MARK: Alert
extension ViewController {
    // Alert 생성
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "오류 발생", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(confirm)

        DispatchQueue.main.async {
            guard self.presentedViewController == nil else { return }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // 데이터(책) 가져오기
    func getBook(_ num: Int) -> Book? {
        var book: Book?
        
        do {
            book = try dataManager.fetchBook(num: num)
        } catch DataError.fileNotFound {
            showAlert("⛔️ 파일을 찾을 수 없습니다.")
        } catch DataError.parsingFailed(let error) {
            showAlert("⛔️ JSON 파싱 에러: \(error)")
        } catch DataError.invalidNumberOfBooks {
            showAlert("⛔️ 유효하지 않은 입력값입니다.")
        } catch {
            showAlert("⛔️ 알 수 없는 오류: \(error)")
        }
        return book
    }
    
    func formatDate(_ released: Date?) -> String {
        guard let date = released else { return "" }
        
        // dateFormat 설정
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMMM dd, yyyy"
        
        // June 26, 1997 형태의 문자열 반환
        return newFormatter.string(from: date)
    }
}

//MARK: Dedication & Summary 영역
extension ViewController {
    func setSummaryLabelStack(of book: Book?, info: Description) -> UIStackView {
        let title = makeInfoTitleLabel(info)
        
        let stackView = switch info {
        case .dedication:
            UIStackView(arrangedSubviews: [title, dedicationLabel])
        case .summary:
            UIStackView(arrangedSubviews: [title, summaryLabel])
        default:
            UIStackView()
        }
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        
        return stackView
    }
    
    func setMoreButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "더보기"
        configuration.attributedTitle?.font = .systemFont(ofSize: 14)
        configuration.attributedTitle?.foregroundColor = .systemBlue
        
        moreButton.configuration = configuration
    }
    
    func setSummaryStack(of book: Book?) -> UIStackView {
        let labels = setSummaryLabelStack(of: book, info: .summary)
        
        let stackView = UIStackView(arrangedSubviews: [labels, moreButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .trailing
        
        if summaryLabel.text?.count ?? 0 < 450 {
            moreButton.isHidden  = true
            isMore = false
        }
        
        return stackView
    }
    
    func setMoreButtonAction() {
        let more = UIAction { [weak self] _ in
            self?.isMore.toggle()
            guard let isMore = self?.isMore else { return }
            
            self?.moreButton.configuration?.title = isMore ? "접기" : "더보기"
            
            self?.summaryLabel.text =
            isMore ? self?.getSummaryText(.origin)
            : self?.getSummaryText(.brief)
        }
        
        moreButton.addAction(more, for: .touchUpInside)
    }
}

//MARK: 목차 영역
extension ViewController {
    func makeChapterStack(of book: Book?) -> UIStackView {
        let title = UILabel(
            text: "Chapter",
            font: .boldSystemFont(ofSize: 18),
            color: .black
        )
        
        let chapters = book?.chapters ?? []
        var chapterLabels: [UILabel] = [title]
        
        for chapter in chapters {
            let text = chapter.title
            let label = UILabel(
                text: text,
                font: .systemFont(ofSize: 14),
                color: .darkGray
            )
            chapterLabels.append(label)
        }
        
        let stackView = UIStackView(arrangedSubviews: chapterLabels)
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        
        return stackView
    }
}

@available(iOS 17.0, *)
#Preview{
    ViewController()
}

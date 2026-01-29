//
//  ViewController.swift
//  HarryPotterJH
//
//  Created by 김주희 on 1/23/26.
//

import UIKit
import SnapKit
import Then

// MARK: - ViewController

final class ViewController: UIViewController {
    
    var books: [Book] = []
    var count = 0 // count = 0 먼저 초기화
    private let dataService = DataService() // 데이터 담당자 생성
    
    
    // MARK: -- UI Components
    
    // 맨 위 제목
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 24, weight: .bold) // 시스템 볼드체, 사이즈 24
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    // 시리즈 버튼
    let seriesButton = UIButton().then {
        $0.setTitle("1", for:   .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold) // Font 사이즈 16
        $0.layer.cornerRadius = 20 // cornerRadius 이용해 원형으로 표시 크기 = size/ 2
        $0.titleLabel?.textAlignment = .center
        $0.backgroundColor = .systemBlue
        $0.addTarget(self, action: #selector(seriesButtonTapped), for: .touchDown) // 왜 자꾸 에러?
    }
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false // 수직 스크롤바 숨기기
    }
    
    let contentView = UIView()
    
    // 책 메인 정보 스택뷰 (이미지 + 텍스트)
    let bookInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .top
    }
    
    // 책 이미지 뷰
    let bookImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
    }
    
    // 책 정보 텍스트 스택뷰
    let bookInfoTextStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }
    
    // 소제목
    let titleLabel2 = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 0
    }
    
    // 저자,날짜,페이지 레이블
    let authorLabel = UILabel()
    let releasedLabel = UILabel()
    let pagesLabel = UILabel()
    
    // dedication
    let dedicationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    let dedicationTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "Dedication"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    let dedicationLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    // summary
    let summaryStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    let summaryTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "Summary"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    let summaryLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
    }
    
    let summaryButton = UIButton().then {
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(summaryButtonTapped), for: .touchDown)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    
    // chapter
    let chapterStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    let chapterLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "Chapters"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    var isExpanded = false
    
    private let expandedKey = "isSummaryExpanded"
    
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBooks()
        
        view.backgroundColor = .white
        
        setupSubView()
        setupConstraints()
        
    }
    
    // MARK: - JSON Data Loading
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let books):
                self.books = books
                self.updateUI()
            case .failure(let error):
                print("error: \(error)")
                
                DispatchQueue.main.async {
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: -- function
    private func setupSubView() {
        [titleLabel, seriesButton, scrollView].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [bookInfoStackView, dedicationStackView, summaryStackView, chapterStackView, summaryButton].forEach {
            contentView.addSubview($0)
        }
        
        [bookImageView, bookInfoTextStackView].forEach {
            bookInfoStackView.addArrangedSubview($0)
        }
        
        [titleLabel2, authorLabel, releasedLabel, pagesLabel].forEach {
            bookInfoTextStackView.addArrangedSubview($0)
        }
        
        [dedicationTitleLabel, dedicationLabel].forEach {
            dedicationStackView.addArrangedSubview($0)
        }
        
        [summaryTitleLabel, summaryLabel].forEach {
            summaryStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        seriesButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(seriesButton.snp.bottom).offset(20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        bookInfoStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
        }
        
        bookImageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(bookImageView.snp.width).multipliedBy(1.5)
        }
        
        dedicationStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(bookInfoStackView.snp.bottom).offset(24)
        }
        
        summaryStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(dedicationStackView.snp.bottom).offset(24)
        }
        
        summaryButton.snp.makeConstraints {
            $0.top.equalTo(summaryStackView.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        chapterStackView.snp.makeConstraints {
            $0.top.equalTo(summaryButton.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40) // contentView의 바닥과 연결시켜야함
        }
    }
    
    // 에러창 띄우는 함수
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "에러 발생", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    // 내용 텍스트 생성 함수
    private func createInfoText(title: String, value: String, titleSize: CGFloat, valueSize: CGFloat, valueColor: UIColor) -> NSAttributedString {
        let attrString = NSMutableAttributedString(
            string: title,
            attributes: [.font: UIFont.systemFont(ofSize: titleSize, weight: .bold), .foregroundColor: UIColor.black])
        
        // 타이틀과 내용 사이에 간격8 추가
        attrString.append(NSAttributedString(
            string: "  \(value)",
            attributes: [.font: UIFont.systemFont(ofSize: valueSize), .foregroundColor: valueColor]
        ))
        return attrString
    }
    
    // UI 갱신 함수
    func updateUI() {
        guard books.indices.contains(count) else { return } // count가 books 안에 진짜 존재할 때만 실행
        let book = books[count]
        
        // 저장된 상태 불러오기 (디폴트값: false)
        isExpanded = UserDefaults.standard.bool(forKey: "expandedKey_\(count)")
        
        seriesButton.setTitle("\(count + 1)", for: .normal)
        titleLabel.text = book.title
        bookImageView.image = UIImage(named: "harrypotter\(count + 1)")
        titleLabel2.text = book.title
        
        // 가이드에 맞춘 속성 텍스트 설정 (간격8 포함)
        authorLabel.attributedText = createInfoText(title: "Author", value: book.author, titleSize: 16, valueSize: 18, valueColor: .darkGray)
        releasedLabel.attributedText = createInfoText(title: "Released", value: formatDate(book.releaseDate), titleSize: 14, valueSize: 14, valueColor: .gray)
        pagesLabel.attributedText = createInfoText(title: "Pages", value: "\(book.pages)", titleSize: 14, valueSize: 14, valueColor: .gray)
        
        dedicationLabel.text = book.dedication
        
        chapterStackView.addArrangedSubview(chapterLabel)
        chapterStackView.subviews.forEach{ $0.removeFromSuperview() }
        chapterStackView.addArrangedSubview(chapterLabel)
        
        // 챕터의 배열을 돌면서 레이블을 추가하기
        book.chapters.forEach { chapter in
            let label = UILabel().then {
                $0.text = "\(chapter.title)"
                $0.font = .systemFont(ofSize: 14)
                $0.textColor = .darkGray
                $0.numberOfLines = 0
            }
            chapterStackView.addArrangedSubview(label)
        }
        
        summaryLabel.text = book.summary
        
        // 버튼의 초기 텍스트 수정
        if book.summary.count > 450 {
            // 줄 수 제한
            summaryButton.isHidden = false
            if isExpanded {
                summaryLabel.text = book.summary
                summaryButton.setTitle("접기", for: .normal)
            } else {
                summaryButton.setTitle("더 보기", for: .normal)
                // 450자에서 자르고 "..." 붙이기
                let index = book.summary.index(book.summary.startIndex, offsetBy: 450)
                summaryLabel.text = String(book.summary[..<index]) + "..."
            }
        } else {
            summaryButton.isHidden = true // 450자가 넘으면 버튼 숨길필요없이 내용 전체 대입
            summaryLabel.text = book.summary
        }
        
    }
    
    // date 포멧 변경 함수
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
        return dateString
    }
    
    
    // 시리즈 버튼 탭했을때 count +1
    @objc
    private func seriesButtonTapped() {
        if count == books.count - 1 {
            count = 0
        } else {
            count += 1
        }
        updateUI()
    }
    
    // 요약 버튼 탭했을때 상태 변경
    @objc
    private func summaryButtonTapped() {
        isExpanded.toggle() // 상태 반전
        
        // UserDefault에 현재상태 저장하기
        UserDefaults.standard.set(isExpanded, forKey: "expandedKey_\(count)")
        
        let book = books[count]
        if isExpanded {
            summaryLabel.text = book.summary
            summaryButton.setTitle("접기", for: .normal)
        }
        else {
            // 다시 450자로 자르기
            let index = book.summary.index(book.summary.startIndex, offsetBy: 450)
            summaryLabel.text = String(book.summary[..<index]) + "..."
            summaryButton.setTitle("더 보기", for: .normal)
        }
    }
}
//     일단 들어왔을때 판정함수 실행 -> 버튼을 적절한 모양으로 만들기
//     버튼 눌럿을때의 로직 작성

















@available(iOS 17.0, *)
#Preview {
    ViewController()
}


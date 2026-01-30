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
    var index = 0
    private let dataService = DataService() // 데이터 담당자 생성
    var isExpanded = false
    
    
    // MARK: -- UI Components
    
    // 최상단 책 제목 레이블
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 24, weight: .bold) // 시스템 볼드체, 사이즈 24
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    // 시리즈 순서 버튼 스택뷰
    let seriesButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .center
    }
    
    // 시리즈 순서 버튼 생성 함수 활용
    lazy var seriesButton1 = makeSeriesButton(1)
    lazy var seriesButton2 = makeSeriesButton(2)
    lazy var seriesButton3 = makeSeriesButton(3)
    lazy var seriesButton4 = makeSeriesButton(4)
    lazy var seriesButton5 = makeSeriesButton(5)
    lazy var seriesButton6 = makeSeriesButton(6)
    lazy var seriesButton7 = makeSeriesButton(7)
    
    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false // 수직 스크롤바 숨기기
    }
    
    // 스크롤뷰 내부에 담을 컨텐츠뷰
    let contentView = UIView()
    
    // 책 메인 정보 스택뷰 (이미지 + 텍스트)
    let bookInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.alignment = .top
    }
    
    // 책 이미지 뷰
    let bookImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    // 책 정보 텍스트 스택뷰
    let bookInfoTextStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    // 책 정보 영역 제목 레이블
    let titleLabel2 = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 0
    }
    
    // 저자, 출간일, 페이지 레이블
    let authorLabel = UILabel()
    let releasedLabel = UILabel()
    let pagesLabel = UILabel()
    
    // Dedication 스택뷰
    let dedicationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    // Dedication 타이틀 레이블
    let dedicationTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "Dedication"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    // Dedication 내용 레이블
    let dedicationLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    // Summary 스택뷰
    let summaryStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    // Summary 타이틀 레이블
    let summaryTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "Summary"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    // Summary 내용 레이블
    let summaryLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    // Summary 요약 버튼
    let summaryButton = UIButton().then {
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(summaryButtonTapped), for: .touchDown)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    
    // Chapter 스택뷰
    let chapterStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    // Chapter 타이틀 레이블
    let chapterTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "Chapters"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        seriesButton1.backgroundColor = .systemGray5
        seriesButton1.setTitleColor(.systemBlue, for: .normal)
        loadBooks()
        setupSubView()
        setupConstraints()
    }
    
    
    // MARK: - JSON Books Data Loading
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let books):
                self.books = books
                self.updateUI()
            case .failure(let error):
                print("error: \(error)")
                
                // 에러 알림창(UI)는 메인스레드에 맞춰 실행
                DispatchQueue.main.async {
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    
    // MARK: -- add_Subview
    
    private func setupSubView() {
        [titleLabel, seriesButtonStackView, scrollView].forEach {
            view.addSubview($0)
        }
        
        [seriesButton1, seriesButton2, seriesButton3, seriesButton4, seriesButton5, seriesButton6, seriesButton7].forEach {
            seriesButtonStackView.addArrangedSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [bookInfoStackView, dedicationStackView, summaryStackView, summaryButton, chapterStackView].forEach {
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
    
    
    // MARK: -- add_Constraints (SnapKit)
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        seriesButtonStackView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        [seriesButton1, seriesButton2, seriesButton3, seriesButton4, seriesButton5, seriesButton6, seriesButton7].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(40)
            }
        }
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(seriesButtonStackView.snp.bottom).offset(20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        bookInfoStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
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
    
    
    // MARK: -- function
    
    // 에러창(팝업) 띄우는 함수
    private func showErrorAlert(message: String) {
        // 알림창 생성
        let alert = UIAlertController(title: "에러 발생", message: message, preferredStyle: .alert)
        // 확인 버튼 생성
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        // 화면에 띄우기
        self.present(alert, animated: true)
    }
    
    // 시리즈 순서 버튼 생성 함수
    private func makeSeriesButton(_ title: Int) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(String(title), for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .systemBlue
            $0.addTarget(self, action: #selector(seriesButtonTapped), for: .touchDown)
        }
        return button
    }
    
    // date 포멧 변경 함수
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) { // 문자열을 date형식으로 변환
            formatter.dateStyle = .long // 출력용 날짜 스타일
            return formatter.string(from: date) // date를 문자열로 다시 변환
        }
        return dateString // 실패하면 원본 반환
    }
    
    // 책 정보뷰 텍스트 생성 함수 (한 줄에 스타일 다른 글자 두 덩이 붙이기)
    private func createInfoText(
        title: String,
        value: String,
        titleSize: CGFloat,
        valueSize: CGFloat,
        valueColor: UIColor
    ) -> NSAttributedString {
        
        // 1. 타이틀 속성 지정
        let inforesult = NSMutableAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(ofSize: titleSize, weight: .bold),
                .foregroundColor: UIColor.black])
        
        
        // 2. 간격 설정
        let spacing = NSAttributedString (string: " ", attributes: [.kern: 8]
        )
        inforesult.append(spacing)
        
        // 3. 내용 속성 지정
        inforesult.append(
            NSAttributedString(
                string: value,
                attributes: [
                    .font: UIFont.systemFont(ofSize: valueSize),
                    .foregroundColor: valueColor
                ]
            )
        )
        return inforesult
    }
    
    // UI 갱신 함수
    func updateUI() {
        guard books.indices.contains(index) else { return } // index가 books 안에 진짜 존재할 때만 실행
        let book = books[index]
        
        // 저장된 상태 불러오기 (디폴트값: false)
        isExpanded = UserDefaults.standard.bool(forKey: "expandedKey_\(index)")
        
        // 최상위 책 제목 값 대입
        titleLabel.text = book.title
        
        // 책 표지 이미지 대입
        bookImageView.image = UIImage(named: "harrypotter\(index + 1)")
        
        // 책 정보영역의 제목 대입
        titleLabel2.text = book.title
        
        // 가이드에 맞춘 속성 텍스트 설정 (간격8 포함)
        authorLabel.attributedText = createInfoText(title: "Author", value: book.author, titleSize: 16, valueSize: 18, valueColor: .darkGray)
        releasedLabel.attributedText = createInfoText(title: "Released", value: formatDate(book.releaseDate), titleSize: 14, valueSize: 14, valueColor: .gray)
        pagesLabel.attributedText = createInfoText(title: "Pages", value: "\(book.pages)", titleSize: 14, valueSize: 14, valueColor: .gray)
        
        dedicationLabel.text = book.dedication
        
        summaryLabel.text = book.summary
        
        // 챕터 스택 뷰의 모든 서브뷰 초기화
        chapterStackView.subviews.forEach{ $0.removeFromSuperview() }
        
        // 챕터 스택뷰에 타이틀 레이블 재 삽입
        chapterStackView.addArrangedSubview(chapterTitleLabel)
        
        // 챕터의 배열을 돌면서 레이블을 추가하기
        book.chapters.forEach { chapter in
            let label = UILabel().then {
                $0.text = "\(chapter.title)"
                $0.font = .systemFont(ofSize: 14)
                $0.textColor = .darkGray
                $0.numberOfLines = 0
            }
            // 챕터 스탭뷰에 차례로 add
            chapterStackView.addArrangedSubview(label)
        }
        
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
                let indexing = book.summary.index(book.summary.startIndex, offsetBy: 450)
                summaryLabel.text = String(book.summary[..<indexing]) + "..."
            }
        } else {
            summaryButton.isHidden = true // 450자가 넘으면 버튼 숨기고 내용 전체 대입
            summaryLabel.text = book.summary
        }
        
    }
    
    
    // MARK: -- button Function
    
    // 시리즈 버튼 탭했을때 count
    @objc
    private func seriesButtonTapped(_ sender: UIButton) {
        if let title = sender.currentTitle {
            [seriesButton1, seriesButton2, seriesButton3, seriesButton4, seriesButton5, seriesButton6, seriesButton7
            ].forEach {
                $0.backgroundColor = .systemBlue
                $0.setTitleColor(.white, for: .normal)}
            
            // tap한 버튼의 title - 1값이 index
            index = (Int(title) ?? 0 ) - 1
            // 선택된 버튼의 배경색, 글자색 변경
            sender.backgroundColor = .systemGray5
            sender.setTitleColor(.systemBlue, for: .normal)
            updateUI()
        }
    }
    
    // 요약 버튼 탭했을때 상태 변경
    @objc
    private func summaryButtonTapped() {
        isExpanded.toggle() // 상태 반전
        
        // UserDefault에 현재상태 저장하기
        UserDefaults.standard.set(isExpanded, forKey: "expandedKey_\(index)")
        
        let book = books[index]
        // 펴져있을땐 요약 원본 대입, 버튼은 접기로
        if isExpanded {
            summaryLabel.text = book.summary
            summaryButton.setTitle("접기", for: .normal)
        }
        else {
            // 접혀있을땐 다시 450자로 자르기
            let index = book.summary.index(book.summary.startIndex, offsetBy: 450)
            summaryLabel.text = String(book.summary[..<index]) + "..."
            summaryButton.setTitle("더 보기", for: .normal)
        }
    }
}







@available(iOS 17.0, *)
#Preview {
    ViewController()
}

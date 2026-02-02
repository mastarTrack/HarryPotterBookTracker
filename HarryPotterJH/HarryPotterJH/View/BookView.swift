//
//  BookView.swift
//  HarryPotterJH
//
//  Created by 김주희 on 1/30/26.
//
import UIKit
import SnapKit
import Then

// MARK: -- View: 화면 그리기 (UILabel, SnapKit 등)

class BookView: UIView {
    
    // 버튼 클릭 이벤트를 ViewController로 전달하기 위한 클로저
    var onSeriesButtonTapped: ((Int) -> Void)?
    var onSummaryButtonTapped: (()-> Void)?
    
    
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
    
    // 시리즈 순서 버튼 배열로 관리
    var seriesButtons: [UIButton] = []
    
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
    lazy var summaryButton = UIButton().then {
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(summaryTapped), for: .touchUpInside)
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
    
    
    // MARK: -- Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame) // 부모 UIView의 기본 세팅을 먼저 함
        self.backgroundColor = .white
        createSeriesButtons() // 시리즈 버튼 생성
        setupSubView()
        setupConstraints()
    }
    
    // 코드베이스로만 작업하겠다는 뜻
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 시리즈 버튼 만드는 함수
    private func createSeriesButtons() {
        for i in 1...7 {
            let button = UIButton().then {
                $0.setTitle("\(i)", for: .normal)
                $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
                $0.layer.cornerRadius = 10
                $0.backgroundColor = .systemBlue
                $0.setTitleColor(.white, for: .normal)
                $0.tag = i // 태그로 시리즈 번호 구분
                $0.addTarget(self, action: #selector(seriesButtonTapped), for: .touchUpInside)
            }
            seriesButtons.append(button) // 시리즈 버튼 배열에 append
        }
    }
    
    // MARK: -- touch action
    
    @objc private func seriesButtonTapped(_ sender: UIButton) {
        onSeriesButtonTapped?(sender.tag)
    }
    
    @objc private func summaryTapped() {
        onSummaryButtonTapped?()
    }
    
    
    // MARK: -- UI updates (뷰컨트롤러가 호출할 메서드들)
    
    func updateSeriesButtons(selectedIndex: Int) {
        seriesButtons.forEach { button in
            // 선택된 버튼
            if button.tag == selectedIndex + 1 {
                button.backgroundColor = .systemGray5
                button.setTitleColor(.systemBlue, for: .normal)
            } else {
                // 선택된 버튼을 제외한 나머지 버튼들
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    // 책 정보뷰 텍스트 생성 함수 (한 줄에 스타일 다른 글자 두 덩이 붙이기)
    func createInfoText(
        title: String,
        value: String,
        titleSize: CGFloat,
        valueSize: CGFloat,
        valueColor: UIColor
    ) -> NSAttributedString {
        
        // 1. 타이틀 속성 지정(Mutable)
        let inforesult = NSMutableAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(ofSize: titleSize, weight: .bold),
                .foregroundColor: UIColor.black])
        
        // 2. 간격 8 추가
        inforesult.append(NSAttributedString (string: " ", attributes: [.kern: 8]))
        
        // 3. 내용 속성 추가
        inforesult.append(NSAttributedString (string: value, attributes: [
            .font: UIFont.systemFont(ofSize: valueSize),
            .foregroundColor: valueColor]))
        return inforesult
    }
    
    // MARK: -- add_Subview
    
    private func setupSubView() {
        [titleLabel, seriesButtonStackView, scrollView].forEach { addSubview($0) }
        
        seriesButtons.forEach { seriesButtonStackView.addArrangedSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [bookInfoStackView, dedicationStackView, summaryStackView, summaryButton, chapterStackView].forEach {
            contentView.addSubview($0)
        }
        
        [bookImageView, bookInfoTextStackView].forEach { bookInfoStackView.addArrangedSubview($0) }
        [titleLabel2, authorLabel, releasedLabel, pagesLabel].forEach { bookInfoTextStackView.addArrangedSubview($0) }
        [dedicationTitleLabel, dedicationLabel].forEach { dedicationStackView.addArrangedSubview($0) }
        [summaryTitleLabel, summaryLabel].forEach { summaryStackView.addArrangedSubview($0) }
    }
    
    // MARK: -- add_Constraints (SnapKit)
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        seriesButtonStackView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        seriesButtons.forEach {
            $0.snp.makeConstraints { $0.width.height.equalTo(20) }
        }
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.top.equalTo(seriesButtonStackView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        bookInfoStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
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
}


//
//  ViewController.swift
//  YSBookTracker
//
//  Created by Yeseul Jang on 1/22/26.
//

import UIKit
import SnapKit

// 뷰를 그리는 역할만 맡도록
class ViewController: UIViewController {
    
    private let dataService: BookServiceProtocol // 뷰모델
    private var books: [Book] = [] // 뷰모델
    private var buttons: [UIButton] = []
    private let buttonStackView = UIStackView()
    private let mainTitleLabel = UILabel() //모델
    let mainStackView = UIStackView()
    let scrollStackView = UIStackView()
    var isExpanded = false // 뷰 모델
    var selectedVolume = 1 // 뷰 모델
    let coverImageView = UIImageView() // 모델
    
    let showMoreButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    let authorNameLabel = { // 모델
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.text = "J. K. Rowling"
        label.textAlignment = .left
        return label
    }()
    
    let releasedDateLabel = { // 모델
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let pagesNumberLabel = { // 모델
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let bookTitleLabel: UILabel = { // 모델
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let dedicationInfoLabel = { // 모델
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    let summaryInfoLabel = { // 모델
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    let chapterStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    //필수 초기화 메서드, 테스트 할 시 mock 객체 만들어 주입
    init(dataService: BookServiceProtocol = DataService()) {
            self.dataService = dataService
            // 코드로 생성시 필요한 init
            super.init(nibName: nil, bundle: nil)
        }
    
    // dataService: BookServiceProtocol 상수가 초기화 시점에 없음
    // 부모 클래스 UIViewController에서 상속 받은 의무 구현 init이 호출
    // 이 ViewController는 스토리보드로 생성하면 안 되고 코드로만 생성할 것임을 명시적으로 보여줌
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        loadBooks()
        
        configureHeader()
        configureMain()
        ConfigureDetail()
    }
    
    private func loadBooks() { //뷰모델
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    self.books = books
                    self.updateBookDetail(Volume: 1)
                    self.updateSummary(Volume: self.selectedVolume)
                    self.restoreExpandedState()
                    
                case .failure(let error):
                    print(error)
                    self.showErrorAlert(error)
                }
            }
        }
    }
        
    func updateSummary(Volume: Int) { // 뷰모델
        if isExpanded || books[Volume - 1].summary.count <= 450 {
            summaryInfoLabel.text = books[Volume - 1].summary
            showMoreButton.setTitle("접기", for: .normal)
        } else {
            let cutSummary = String(books[Volume - 1].summary.prefix(450))
            summaryInfoLabel.text = cutSummary + "..."
            showMoreButton.setTitle("더보기", for: .normal)
        }
        showMoreButton.isHidden = books[Volume - 1].summary.count <= 450
    }
    
    @objc func didTapShowMore() { // 뷰모델
        isExpanded.toggle()
        saveExpandedState()
        updateSummary(Volume: selectedVolume)
    }
    
    func saveExpandedState() { // 뷰모델
        UserDefaults.standard.set(isExpanded, forKey: DefaultsKey.isExpanded)
    }

    private func restoreExpandedState() { // 뷰모델
        isExpanded = UserDefaults.standard.bool(forKey: DefaultsKey.isExpanded)
    }
    
    private func makeButton(name: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule

        var attri = AttributedString(name)
        attri.font = .systemFont(ofSize: 16)
        config.attributedTitle = attri

        let button = UIButton(configuration: config)
        button.clipsToBounds = true

        button.snp.makeConstraints {
            $0.height.equalTo(button.snp.width)
        }
        
        return button
    }
    
    private func createButtons() {
        buttons = (1...7).map { i in
            let button = makeButton(name: "\(i)")
            button.tag = i
            button.addTarget(self, action: #selector(didTapVolumeButton(_:)), for:.touchUpInside)
            return button
        }
    }
    
    @objc func didTapVolumeButton(_ sender: UIButton) {
        let volume = sender.tag
        selectedVolume = volume
        isExpanded = false
        
        updateInfo(volume: volume)
    }
    
    func updateInfo(volume: Int)  {
        guard books.indices.contains(volume - 1) else { return }
        
        resetChapters()
        updateBookDetail(Volume: volume)
        updateSummary(Volume: volume)
    }
    
    func resetChapters() { // 뷰컨???
        chapterStackView.arrangedSubviews.forEach {
            chapterStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let chapterTitleLabel = UILabel()
        chapterTitleLabel.text = "Chapters"
        chapterTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        chapterStackView.addArrangedSubview(chapterTitleLabel)
    }
    
    
    private func configureHeader() {
        view.addSubview(bookTitleLabel)
        
        bookTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.distribution = .equalSpacing
        
        createButtons()
        
        buttons.forEach { button in
            buttonStackView.addArrangedSubview(button)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bookTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func makeChapterLabels(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }
    
    private func updateBookDetail(Volume: Int) {
        bookTitleLabel.text = books[Volume - 1].title
        mainTitleLabel.text = books[Volume - 1].title
        coverImageView.image = UIImage(named: "harrypotter\(Volume)")
        releasedDateLabel.text = books[Volume - 1].releaseDate.changeToUSADate()
        pagesNumberLabel.text = String(books[Volume - 1].pages)
        dedicationInfoLabel.text = books[Volume - 1].dedication
        
        for ch in books[Volume - 1].chapters {
            chapterStackView.addArrangedSubview(makeChapterLabels(text: ch.title))
        }
    }
    
    private func configureMain() {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        let contentView = UIView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(scrollStackView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        scrollStackView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview().inset(24)
        }
        
        scrollStackView.axis = .vertical
        scrollStackView.spacing = 24
        scrollStackView.distribution = .fill
        
        mainStackView.axis = .horizontal
        mainStackView.spacing = 10
        mainStackView.alignment = .firstBaseline
        
        scrollStackView.addArrangedSubview(mainStackView)
        
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.clipsToBounds = true
        
        coverImageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(coverImageView.snp.width).multipliedBy(1.5)
        }
        
        let mainDetailStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .leading
            stackView.spacing = 8
            return stackView
        }()
        
        mainStackView.addArrangedSubview(coverImageView)
        mainStackView.addArrangedSubview(mainDetailStackView)
        
        mainTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        mainTitleLabel.numberOfLines = 0
        
        mainDetailStackView.addArrangedSubview(mainTitleLabel)
        
        let authorLabel = {
            let label = UILabel()
            label.text = "Author"
            label.font = .systemFont(ofSize: 16, weight: .bold)
            label.textAlignment = .left
            return label
        }()
        
        let authorStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 8
            return stackView
        }()
        
        authorStackView.addArrangedSubview(authorLabel)
        authorStackView.addArrangedSubview(authorNameLabel)
        mainDetailStackView.addArrangedSubview(authorStackView)
        
        let releasedLabel = {
            let label = UILabel()
            label.text = "Released"
            label.font = .systemFont(ofSize: 14, weight: .bold)
            return label
        }()
        
        let releasedStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 8
            return stackView
        }()
        
        releasedStackView.addArrangedSubview(releasedLabel)
        releasedStackView.addArrangedSubview(releasedDateLabel)
        mainDetailStackView.addArrangedSubview(releasedStackView)
        
        let pagesLabel = {
            let label = UILabel()
            label.text = "Pages"
            label.font = .systemFont(ofSize: 14, weight: .bold)
            return label
        }()
        
        let pagesStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 8
            return stackView
        }()
        
        pagesStackView.addArrangedSubview(pagesLabel)
        pagesStackView.addArrangedSubview(pagesNumberLabel)
        mainDetailStackView.addArrangedSubview(pagesStackView)
    }
    
    func ConfigureDetail() {
        let dedicationStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 8
            return stackView
        }()
        
        let dedicationTitleLabel: UILabel = {
            let label = UILabel()
            label.text = "Dedication"
            label.font = .systemFont(ofSize: 18, weight: .bold)
            return label
        }()
        
        scrollStackView.addArrangedSubview(dedicationStackView)
        dedicationStackView.addArrangedSubview(dedicationTitleLabel)
        dedicationStackView.addArrangedSubview(dedicationInfoLabel)
        
        let summaryStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 8
            return stackView
        }()
        
        let summaryTitleLabel: UILabel = {
            let label = UILabel()
            label.text = "Summary"
            label.font = .systemFont(ofSize: 18, weight: .bold)
            return label
        }()
        
        scrollStackView.addArrangedSubview(summaryStackView)
        summaryStackView.addArrangedSubview(summaryTitleLabel)
        summaryStackView.addArrangedSubview(summaryInfoLabel)
        
        let buttonUIView = UIView()
        
        buttonUIView.addSubview(showMoreButton)
        summaryStackView.addArrangedSubview(buttonUIView)
        
        showMoreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
        
        showMoreButton.addTarget(self, action: #selector(didTapShowMore), for: .touchUpInside)
        
        let chapterTitleLabel: UILabel = {
            let label = UILabel()
            label.text = "Chapters"
            label.font = .systemFont(ofSize: 18, weight: .bold)
            return label
        }()
        
        scrollStackView.addArrangedSubview(chapterStackView)
        chapterStackView.addArrangedSubview(chapterTitleLabel)
    }
    
    private func showErrorAlert(_ error: Error) {
        let message: String

        switch error {
        case DataService.DataError.fileNotFound:
            message = "데이터 파일을 찾을 수 없습니다."

        case DataService.DataError.parsingFailed:
            message = "데이터 형식이 올바르지 않습니다."

        default:
            message = "알 수 없는 오류가 발생했습니다."
        }

        let alert = UIAlertController(
            title: "오류",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

enum DefaultsKey {
    static let isExpanded = "summary.isExpanded"
}



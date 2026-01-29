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
    let viewModel = BookViewModel(dataService: DataService())
    private var buttons: [UIButton] = []
    private let buttonStackView = UIStackView()
    private let mainTitleLabel = UILabel() //모델
    let mainStackView = UIStackView()
    let scrollStackView = UIStackView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        pushInfo()
        
        configureHeader()
        configureMain()
        ConfigureDetail()
        
        viewModel.loadBooks()
    }
    
    func pushInfo() {
        viewModel.updateInfo = { [weak self] info in
            self?.updateBookDetail(info: info)
        }
        
        viewModel.error = { [weak self] error in
            self?.showErrorAlert(error)
        }
        
    }
    
    private func updateBookDetail(info: BookViewInfo) {
        bookTitleLabel.text = info.title
        mainTitleLabel.text = info.title
        
        coverImageView.image = UIImage(named: info.coverImageName)
        
        authorNameLabel.text = info.authorName
        releasedDateLabel.text = info.releasedDate
        pagesNumberLabel.text = info.pages
        dedicationInfoLabel.text = info.dedication
        
        summaryInfoLabel.text = info.summary
        showMoreButton.setTitle(info.showMoreTitle, for: .normal)
        showMoreButton.isHidden = info.isShowMoreHidden

        resetChapters()
        info.chapterTitles.forEach { title in
            chapterStackView.addArrangedSubview(makeChapterLabels(text: title))
        }
    }
    
    func resetChapters() {
        chapterStackView.arrangedSubviews.forEach {
            chapterStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let chapterTitleLabel = UILabel()
        chapterTitleLabel.text = "Chapters"
        chapterTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        chapterStackView.addArrangedSubview(chapterTitleLabel)
    }
    
    private func makeChapterLabels(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }
    
    private func createButtons() {
        buttons = (1...7).map { i in
            let button = makeButton(name: "\(i)")
            button.tag = i
            button.addTarget(self, action: #selector(didTapVolumeButton(_:)), for:.touchUpInside)
            return button
        }
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
    
    @objc private func didTapVolumeButton(_ sender: UIButton) {
        viewModel.selectBook(volume: sender.tag)
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
    
    @objc private func didTapShowMore() {
        viewModel.showSummary()
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



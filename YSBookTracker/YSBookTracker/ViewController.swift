//
//  ViewController.swift
//  YSBookTracker
//
//  Created by Yeseul Jang on 1/22/26.
//

import UIKit
import SnapKit
// 뷰를 그리는 역할만 맡도록
final class ViewController: UIViewController {
    private let viewModel = BookViewModel(dataService: DataService())
    
    private var buttons: [UIButton] = []
    private let showMoreButton = UIButton()
    
    private let chapterStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let scrollStackView = UIStackView()
    private let coverImageView = UIImageView()
    
    private let mainTitleLabel = UILabel()
    private let bookTitleLabel = UILabel()
    private let authorNameLabel = UILabel()
    private let releasedDateLabel = UILabel()
    private let pagesNumberLabel = UILabel()
    private let dedicationInfoLabel = UILabel()
    private let summaryInfoLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        pushInfo() // 데이터 받아서 갱신할 방법 설정
        
        configureHeader() // 화면 구성
        configureMain()
        configureDetail()
        
        viewModel.loadBooks() // 데이터 받아오기
    }
    
    private func configureHeader() {
        configureHeaderTitleLabel()
        configureButtonStackView()
    }
    
    private func configureMain() {
        configureMainBookPart()
        configureScrollView()
    }
    
    private func configureDetail() {
        configureDedicationView()
        configureSummaryView()
        configureChapterView()
    }
    
    private func pushInfo() {
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
    
    private func resetChapters() {
        chapterStackView.arrangedSubviews.forEach {
            chapterStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let chapterTitleLabel = UILabel()
        chapterTitleLabel.text = "Chapters"
        chapterTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        chapterStackView.addArrangedSubview(chapterTitleLabel)
    }
    
    @objc private func didTapVolumeButton(_ sender: UIButton) {
        viewModel.selectBook(volume: sender.tag)
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

// 스택/라벨 생성 메서드
extension ViewController {
    private func makeStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = 8
        return stackView
    }
    
    private func setStackView(_ stackView: UIStackView, axis: NSLayoutConstraint.Axis) {
        stackView.axis = axis
        stackView.spacing = 8
    }
    
    private func makeChapterLabels(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }
}

// 헤더 부분 뷰 레이아웃
extension ViewController {
    private func configureHeaderTitleLabel() {
        view.addSubview(bookTitleLabel)
        bookTitleLabel.apply(.HeaderTitle)
        bookTitleLabel.textAlignment = .center
        
        bookTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
    }
    
    private func configureButtonStackView() {
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
}

// 메인 부분 뷰 레이아웃
extension ViewController {
    private func configureMainBookPart() {
        let authorLabel = UILabel(text: "Author", config: .boldAnd16)
        let releasedLabel = UILabel(text: "Released", config: .boldAnd14)
        let pagesLabel = UILabel(text: "Pages" , config: .boldAnd14)
        
        setMainLabels()
        
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.clipsToBounds = true
        
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.spacing = 10
        mainStackView.alignment = .firstBaseline
        mainStackView.distribution = .fill
        
        let mainDetailStackView = makeStackView(axis: .vertical)
        mainDetailStackView.alignment = .leading
        mainDetailStackView.distribution = .fill
        
        let pagesStackView = makeStackView(axis: .horizontal)
        let authorStackView = makeStackView(axis: .horizontal)
        let releasedStackView = makeStackView(axis: .horizontal)

        coverImageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(coverImageView.snp.width).multipliedBy(1.5)
        }
        
        authorStackView.addArrangedSubview(authorLabel)
        authorStackView.addArrangedSubview(authorNameLabel)
        
        releasedStackView.addArrangedSubview(releasedLabel)
        releasedStackView.addArrangedSubview(releasedDateLabel)
        
        pagesStackView.addArrangedSubview(pagesLabel)
        pagesStackView.addArrangedSubview(pagesNumberLabel)
        
        scrollStackView.addArrangedSubview(mainStackView)
        mainStackView.addArrangedSubview(coverImageView)
        mainStackView.addArrangedSubview(mainDetailStackView)
        
        mainDetailStackView.addArrangedSubview(mainTitleLabel)
        mainDetailStackView.addArrangedSubview(authorStackView)
        mainDetailStackView.addArrangedSubview(releasedStackView)
        mainDetailStackView.addArrangedSubview(pagesStackView)
    }
    
    private func setMainLabels() {
        mainTitleLabel.apply(.boldAnd20)
        authorNameLabel.apply(.darkGrayAnd18)
        releasedDateLabel.apply(.grayAnd14)
        pagesNumberLabel.apply(.grayAnd14)
    }
    
    private func configureScrollView() {
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
    }
}


// 디테일 부분 뷰 레이아웃
extension ViewController {
    private func configureDedicationView() {
        let dedicationStackView = makeStackView(axis: .vertical)
        
        let dedicationTitleLabel = UILabel(text: "Dedication", config: .boldAnd18)
        dedicationInfoLabel.apply(.darkGrayAnd14)
        
        scrollStackView.addArrangedSubview(dedicationStackView)
        dedicationStackView.addArrangedSubview(dedicationTitleLabel)
        dedicationStackView.addArrangedSubview(dedicationInfoLabel)
    }
    
    private func configureSummaryView() {
        let summaryStackView = makeStackView(axis: .vertical)
        let summaryTitleLabel = UILabel(text: "Summary", config: .boldAnd18)
        summaryInfoLabel.apply(.darkGrayAnd18)
        
        scrollStackView.addArrangedSubview(summaryStackView)
        summaryStackView.addArrangedSubview(summaryTitleLabel)
        summaryStackView.addArrangedSubview(summaryInfoLabel)
        
        let buttonUIView = UIView()
        setShowMoreButton()
        buttonUIView.addSubview(showMoreButton)
        summaryStackView.addArrangedSubview(buttonUIView)
        
        showMoreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    private func setShowMoreButton() {
        showMoreButton.setTitleColor(.systemBlue, for: .normal)
        showMoreButton.titleLabel?.font = .systemFont(ofSize: 14)
        showMoreButton.addTarget(self, action: #selector(didTapShowMore), for: .touchUpInside)
    }
    
    private func configureChapterView() {
        let chapterTitleLabel = UILabel(text: "Chapters", config: .boldAnd18)
        
        setStackView(chapterStackView, axis: .vertical)
        scrollStackView.addArrangedSubview(chapterStackView)
        chapterStackView.addArrangedSubview(chapterTitleLabel)
    }
}

enum DefaultsKey {
    static func isExpandedKey(volume: Int) -> String {
        return "summary.isExpanded.volume.\(volume)"
    }
}

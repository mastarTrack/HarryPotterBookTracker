//
//  ViewController.swift
//  YSBookTracker
//
//  Created by Yeseul Jang on 1/22/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let dataService = DataService()
    private var books: [Book] = []
    private var buttons: [UIButton] = []
    private let buttonStackView = UIStackView()
    private let mainTitleLabel = UILabel()
    let mainStackView = UIStackView()
    
    let authorNameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.text = "J. K. Rowling"
        label.textAlignment = .left
        return label
    }()
    
    let releasedDateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let pagesNumberLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let dedicationInfoLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    let summaryInfoLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        loadBooks()
        
        configureHeader()
        configureMain()
        ConfigureDetail()
    }
    
    private func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    self.books = books
                    self.updateBookDetail(Volume: 1)
                    
                case .failure(let error):
                    print(error)
                    self.showErrorAlert(error)
                }
            }
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
    
    private func createButtons() {
        buttons = (1...7).map { i in
            let b = makeButton(name: "\(i)")
            b.tag = i
            
            return b
        }
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
    
    private func updateBookDetail(Volume: Int) {
        bookTitleLabel.text = books[Volume - 1].title
        mainTitleLabel.text = books[Volume - 1].title
        releasedDateLabel.text = books[Volume - 1].releaseDate.changeToUSADate()
        pagesNumberLabel.text = String(books[Volume - 1].pages)
        summaryInfoLabel.text = books[Volume - 1].summary
        dedicationInfoLabel.text = books[Volume - 1].dedication
    }
    
    private func configureMain() {
        mainStackView.axis = .horizontal
        mainStackView.spacing = 10
        mainStackView.alignment = .firstBaseline
        
        view.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(buttonStackView.snp.bottom).offset(10)
        }
        
        let coverImageView = UIImageView()
        coverImageView.image = UIImage(named: "harrypotter1")
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
        
        view.addSubview(dedicationStackView)
        dedicationStackView.addArrangedSubview(dedicationTitleLabel)
        dedicationStackView.addArrangedSubview(dedicationInfoLabel)
        
        dedicationStackView.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
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
        
        view.addSubview(summaryStackView)
        summaryStackView.addArrangedSubview(summaryTitleLabel)
        summaryStackView.addArrangedSubview(summaryInfoLabel)
        
        summaryStackView.snp.makeConstraints {
            $0.top.equalTo(dedicationStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
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


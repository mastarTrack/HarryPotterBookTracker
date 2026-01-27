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
    private let mainTitleLabel = UILabel()
    private let buttonStackView = UIStackView()
    
    let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadBooks()
        configureHeader()
        configureMain()
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

        var attr = AttributedString(name)
        attr.font = .systemFont(ofSize: 16)
        config.attributedTitle = attr

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
        buttonStackView.alignment = .center
        buttonStackView.distribution = .equalSpacing
        
        createButtons()
        buttons.forEach { button in
            buttonStackView.addArrangedSubview(button)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bookTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.greaterThanOrEqualToSuperview().inset(20)
        }
    }
    
    private func updateBookDetail(Volume: Int) {
        bookTitleLabel.text = books[Volume - 1].title
    }
    
    private func configureMain() {
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.spacing = 10
        mainStackView.distribution = .fillProportionally
        
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
            $0.height.equalTo(coverImageView.snp.width).multipliedBy(1.5)
        }
        
        mainStackView.addArrangedSubview(coverImageView)
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


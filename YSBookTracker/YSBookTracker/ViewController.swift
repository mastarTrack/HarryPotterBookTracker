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
    let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "bookTitle"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    private var buttons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadBooks()
        configureHeader()
    }
    
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let books):
                self.books = books
                
            case .failure(let error):
                print(error)
            }
        }
    }
    func makeButton(name: String) -> UIButton {
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
    
    func configureHeader() {
        view.addSubview(bookTitleLabel)
        
        bookTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        let buttonStackView = UIStackView()
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
}


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
    
    // MARK: - JSON
    var books: [Book] = []
    
    private let dataService = DataService() // 데이터 담당자 생성
    
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let books):
                self.books = books
                
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBooks()
        
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(seriesButton)
        
        updateUI()
        setupTitleUI()
        setupSeriesButtonUI()
        
    }
    
    var count = 0
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 24, weight: .bold) // 시스템 볼드체, 사이즈 24
        $0.numberOfLines = 0 // 텍스트 가운데 정렬
        $0.textAlignment = .center
    }
    
    let seriesButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold) // Font 사이즈 16
        $0.layer.cornerRadius = 20 // cornerRadius 이용해 원형으로 표시 크기 = size/ 2
        $0.titleLabel?.textAlignment = .center
        $0.backgroundColor = .systemBlue
        $0.addTarget(ViewController.self, action: #selector(seriesButtonTapped), for: .touchDown)
    }
    
    let bookInfoStackView = UIStackView().then {
        
    }
    
    
    func updateUI() {
        titleLabel.text = books[count].title
        seriesButton.setTitle("\(count + 1)", for: .normal)
    }
    
    private func setupTitleUI() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    private func setupSeriesButtonUI() {
        seriesButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
    }
    
    
    @objc
    private func seriesButtonTapped() {
        if count == books.count - 1 {
            count = 0
        } else {
            count += 1
        }
        seriesButton.setTitle("\(count + 1)", for: .normal)
        updateUI()
    }
    
    
}
















@available(iOS 17.0, *)
#Preview {
    ViewController()
}


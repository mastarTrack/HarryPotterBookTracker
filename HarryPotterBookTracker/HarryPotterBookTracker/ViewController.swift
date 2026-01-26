//
//  ViewController.swift
//  HarryPotterBookTracker
//
//  Created by Hanjuheon on 1/23/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private let dataService = DataService()
    let labelHeader = UILabel()
    var bookData: [Book] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        loadBooks()
        if bookData.isEmpty {
            return
        }
        configureUI()
    }
    
    
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let books):
                bookData = books
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureUI(){
        
        labelHeader.text = bookData[0].title
        labelHeader.textColor = .black
        labelHeader.textAlignment = .center
        labelHeader.font = UIFont.boldSystemFont(ofSize: 24)
        labelHeader.numberOfLines = 0
        
        
        let buttonBookCount = UIButton()
        
        buttonBookCount.backgroundColor = .systemBlue
        buttonBookCount.setTitle("1", for: .normal)
        buttonBookCount.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        buttonBookCount.setTitleColor(.white, for: .normal)
        buttonBookCount.layer.cornerRadius = 15
        
        view.addSubview(labelHeader)
        view.addSubview(buttonBookCount)
        
        labelHeader.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            
        }
        buttonBookCount.snp.makeConstraints{
            $0.top.equalTo(labelHeader.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }
    }
}

#Preview{
    ViewController()
}

//
//  ViewController.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/23/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let dataManager = DataManager()
    
    private let titleLabel = UILabel()
    private let seriesButton = UIButton()
    
    private let infoImage = UIImageView()
    private let infoTitle = UILabel()
    private let authorTitle = UILabel()
    private let releasedTitle = UILabel()
    private let pagesTitle = UILabel()
    private let infoAuthor = UILabel()
    private let infoReleased = UILabel()
    private let infoPages = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        view.backgroundColor = .white
        
        setLabel()
        setSeriesButton()
        setInfoView()
        
        let infoStack = setInfoStack()
        
        [titleLabel, seriesButton, infoImage, infoStack].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        seriesButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.height.width.equalTo(44) // HIG 권장 최소 버튼 크기
        }
        
        infoImage.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(infoImage.snp.width).multipliedBy(1.5)
            $0.top.equalTo(seriesButton.snp.bottom).offset(16)
        }
        
        infoStack.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalTo(infoImage.snp.trailing).offset(16)
            $0.top.equalTo(infoImage)
        }
    
    }
    
    func setLabel() {
        titleLabel.text = dataManager.fetchInfo(num: 1, info: .title)
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
    }
    
    func setSeriesButton() {
        seriesButton.setTitle("1", for: .normal)
        seriesButton.titleLabel?.font = .systemFont(ofSize: 16)
        seriesButton.titleLabel?.textColor = .white
        seriesButton.backgroundColor = .systemBlue
        
        seriesButton.layer.cornerRadius = 22
        seriesButton.clipsToBounds = true
    }
    
    func setInfoView() {
        infoImage.image = UIImage(resource: .harrypotter1)
        infoImage.contentMode = .scaleAspectFit
        
        infoTitle.text = titleLabel.text
        infoTitle.font = .boldSystemFont(ofSize: 20)
        infoTitle.textColor = .black
        infoTitle.numberOfLines = 0
        
        authorTitle.text = "Author"
        authorTitle.font = .boldSystemFont(ofSize: 16)
        authorTitle.textColor = .black
        
        infoAuthor.text = dataManager.fetchInfo(num: 1, info: .author)
        infoAuthor.font = .systemFont(ofSize: 18)
        infoAuthor.textColor = .darkGray
        
        releasedTitle.text = "Released"
        releasedTitle.font = .boldSystemFont(ofSize: 14)
        releasedTitle.textColor = .black
        
        infoReleased.text = dataManager.fetchInfo(num: 1, info: .release_date) // 형태 변경 필요 June 26, 1997
        infoReleased.font = .systemFont(ofSize: 14)
        infoReleased.textColor = .darkGray
        
        pagesTitle.text = "Pages"
        pagesTitle.font = .boldSystemFont(ofSize: 14)
        pagesTitle.textColor = .black
        
        infoPages.text = dataManager.fetchInfo(num: 1, info: .pages)
        infoPages.font = .systemFont(ofSize: 14)
        infoPages.textColor = .darkGray
    }
    
    func setInfoStack() -> UIStackView {
        let authorStack = UIStackView(arrangedSubviews: [authorTitle, infoAuthor])
        let releasedStack = UIStackView(arrangedSubviews: [releasedTitle, infoReleased])
        let pagesStack = UIStackView(arrangedSubviews: [pagesTitle, infoPages])
        
        [authorStack, releasedStack, pagesStack].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        let stackView = UIStackView(arrangedSubviews: [infoTitle, authorStack, releasedStack, pagesStack])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        
        return stackView
    }

}

@available(iOS 17.0, *)
#Preview{
    ViewController()
}

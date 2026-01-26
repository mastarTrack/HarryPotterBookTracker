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
    
    var titleLabel = UILabel()
    var seriesButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        view.backgroundColor = .white
        
        setLabel()
        setSeriesButton()
        
        [titleLabel, seriesButton].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        seriesButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
//            $0.leading.trailing.greaterThanOrEqualToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.height.width.equalTo(50)
        }
    }
    
    func setLabel() {
        let data = dataManager.fetchData()
        
        titleLabel.text = "\(data[0].title)"
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0


    }
    
    func setSeriesButton() {
        seriesButton.setTitle("1", for: .normal)
        seriesButton.titleLabel?.font = .systemFont(ofSize: 16)
        seriesButton.titleLabel?.textColor = .white
        seriesButton.backgroundColor = .systemBlue
        seriesButton.layer.cornerRadius = 25
        seriesButton.clipsToBounds = true
    }
    

}

@available(iOS 17.0, *)
#Preview{
    ViewController()
}

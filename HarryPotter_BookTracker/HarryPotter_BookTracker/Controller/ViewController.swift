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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        view.backgroundColor = .white
        
        let titleLabel = setTitleLabel()
        let seriesButton = setSeriesButton()
        let infoScroll = setInfoScroll()
        
        [titleLabel, seriesButton, infoScroll].forEach {
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
        }
        
        infoScroll.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(seriesButton.snp.bottom).offset(16)
        }
    }
    
    func setInfoScroll() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.width.height.equalToSuperview()
        }
        
        let infoStack = setInfoStack()
        contentView.addSubview(infoStack)
        
        infoStack.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        return scrollView
    }

}

//MARK: 제목 영역
extension ViewController {
    // 책 제목 레이블 생성
    func setTitleLabel() -> UILabel {
        let text = dataManager.fetchInfo(num: 1, info: .title)
        let label = UILabel(
            text: text,
            font:.boldSystemFont(ofSize: 24),
            color: .black
        )
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }
    
    // 시리즈 버튼 생성
    func setSeriesButton() -> SeriesButton {
        let button = SeriesButton()
        button.setTitle("1", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .systemBlue
        
        return button
    }
}

//MARK: 정보 영역
extension ViewController {
    // 책 이미지 생성
    func setBookImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .harrypotter1)
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.5)
        }
        
        return imageView
    }
    
    // 정보 레이블 가로 스택 생성
    func setHorizontalInfoLabelStack(_ info: Description) -> UIStackView {
        let title = info.rawValue
        let titleLabel = UILabel(
            text: title,
            font: .boldSystemFont(ofSize: 16),
            color: .black
        )

        let infoDetail = dataManager.fetchInfo(num: 1, info: info)
        let infoLabel = UILabel(
            text: infoDetail,
            font: .systemFont(ofSize: 18),
            color: .darkGray
        )
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, infoLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }
    
    // 정보 레이블 스택 생성
    func setInfoLabelStack() -> UIStackView {
        // 제목 레이블 생성
        let text = dataManager.fetchInfo(num: 1, info: .title)
        let titleLabel = UILabel(
            text: text,
            font: .boldSystemFont(ofSize: 20),
            color: .black
        )
        titleLabel.numberOfLines  = 0
        
        // 저자, 발간일, 페이지 정보 레이블 스택 생성
        let authorStack = setHorizontalInfoLabelStack(.author)
        let releasedStack = setHorizontalInfoLabelStack(.release_date)
        let pagesStack = setHorizontalInfoLabelStack(.pages)
        
        // 레이블 전체 스택 생성
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorStack, releasedStack, pagesStack])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        
        return stackView
    }
    
    // 정보 영역 스택 생성
    func setInfoStack() -> UIStackView {
        let imageView = setBookImage()
        let labels = setInfoLabelStack()
        
        labels.setContentHuggingPriority(.required, for: .vertical)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, labels])
        
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .top
        
        return stackView
    }
    
}

//MARK: Custom Components
// UILabel 생성자 정의
extension UILabel {
    convenience init(
        text: String,
        font: UIFont,
        color: UIColor
    ) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = color
    }
}

// 시리즈 버튼 원형 만들기
class SeriesButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}


@available(iOS 17.0, *)
#Preview{
    ViewController()
}

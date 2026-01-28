//
//  ViewController.swift
//  HarryPotterBookTracker
//
//  Created by Hanjuheon on 1/23/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    /// json 파싱 클래스
    private let dataService = DataService()
    /// 해리포터 책 정보 배열
    var bookData: [Book] = []
    
    /// 제목 헤더 레이블
    let labelHeader = UILabel()
    /// 책 이미지뷰
    let imageInfoImage = UIImageView()
    /// 상세정보 제목 레이블
    let labelInfoHeader = UILabel()
    /// 상세정보 저자 레이블
    let labelInfoAuthor = UILabel()
    /// 상세정보 책 출시일 레이블
    let labelInfoRelesed = UILabel()
    /// 상세정보 페이지 레이블
    let labelInfoPages = UILabel()
    /// 상세정보 헌사 레이블
    let labelInfoDedication = UILabel()
    /// 상세정보 개요 레이블
    let labelInfoSummary = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        configureUI()
        loadBooks()
    }
    
    /// 책 정보 로드 메소드
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                bookData = books
                setViewData(1)
            case .failure(let error):
                if let dataError = error as? DataService.DataError {
                    switch dataError {
                    case .fileNotFound:
                        DispatchQueue.main.async {self.showAlert("파일을 찾을 수 없습니다.")}
                    case .parsingFailed:
                        DispatchQueue.main.async {self.showAlert("파싱 실패")}
                    }
                }
            }
        }
    }
    
    /// UI 세팅 메소드
    private func configureUI(){
        
        /// 컨트롤 설정부
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
        
        let stackDetailMain = UIStackView()
        stackDetailMain.axis = .horizontal
        stackDetailMain.alignment = .top
        stackDetailMain.distribution = .fill
        stackDetailMain.spacing = 10
        
        let subView = UIView()
        
        imageInfoImage.contentMode = .scaleAspectFit
    
        labelInfoHeader.numberOfLines = 0
        labelInfoHeader.adjustsFontSizeToFitWidth = true
        labelInfoHeader.font = UIFont.boldSystemFont(ofSize: 20)
        labelInfoHeader.textColor = .black
        
        let labelAuthor = UILabel()
        labelAuthor.font = UIFont.boldSystemFont(ofSize: 16)
        labelAuthor.textColor = .black
        labelAuthor.text = "Author"
        labelInfoAuthor.font = UIFont.systemFont(ofSize: 18)
        labelInfoAuthor.textColor = .darkGray
        
        let labelReleased = UILabel()
        labelReleased.font = UIFont.boldSystemFont(ofSize: 14)
        labelReleased.textColor = .black
        labelReleased.text = "Released"
        labelInfoRelesed.font = UIFont.systemFont(ofSize: 14)
        labelInfoRelesed.textColor = .gray

        let labelPage = UILabel()
        labelPage.font = UIFont.boldSystemFont(ofSize: 14)
        labelPage.textColor = .black
        labelPage.text = "Page"
        labelInfoPages.font = UIFont.systemFont(ofSize: 14)
        labelInfoPages.textColor = .gray

        view.addSubview(labelHeader)
        view.addSubview(buttonBookCount)
        subView.addSubview(labelInfoHeader)
        subView.addSubview(labelAuthor)
        subView.addSubview(labelInfoAuthor)
        subView.addSubview(labelReleased)
        subView.addSubview(labelInfoRelesed)
        subView.addSubview(labelPage)
        subView.addSubview(labelInfoPages)
        stackDetailMain.addArrangedSubview(imageInfoImage)
        stackDetailMain.addArrangedSubview(subView)
        view.addSubview(stackDetailMain)
    
        
        /// 책 구성 스택뷰
        let stackMatter = UIStackView()
        stackMatter.axis = .vertical
        stackMatter.alignment = .top
        stackMatter.spacing = 24
        
        // 헌사 스택뷰
        let stackDedication = UIStackView()
        stackDedication.axis = .vertical
        stackDedication.alignment = .top
        stackDedication.spacing = 8
        
        // 개요 스텍뷰
        let stackSummary = UIStackView()
        stackSummary.axis = .vertical
        stackSummary.alignment = .top
        stackSummary.spacing = 8
        
        let labelDedication = UILabel()
        labelDedication.font = UIFont.boldSystemFont(ofSize: 18)
        labelDedication.textColor = .black
        labelDedication.text = "Dedication"
        labelInfoDedication.font = UIFont.systemFont(ofSize: 14)
        labelInfoDedication.textColor = .darkGray
        labelInfoDedication.numberOfLines = 0
        stackDedication.addArrangedSubview(labelDedication)
        stackDedication.addArrangedSubview(labelInfoDedication)
        
        let labelSummary = UILabel()
        labelSummary.font = UIFont.boldSystemFont(ofSize: 18)
        labelSummary.textColor = .black
        labelSummary.text = "Summary"
        labelInfoSummary.font = UIFont.systemFont(ofSize: 14)
        labelInfoSummary.textColor = .darkGray
        labelInfoSummary.numberOfLines = 0
        stackSummary.addArrangedSubview(labelSummary)
        stackSummary.addArrangedSubview(labelInfoSummary)
        
        stackMatter.addArrangedSubview(stackDedication)
        stackMatter.addArrangedSubview(stackSummary)
        
        view.addSubview(stackMatter)
        
        // 오토 레이아웃 선언부
        labelHeader.snp.makeConstraints{
            $0.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        buttonBookCount.snp.makeConstraints{
            $0.height.equalTo(30)
            $0.top.equalTo(labelHeader.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        imageInfoImage.snp.makeConstraints{
            $0.width.equalTo(100)
            $0.height.equalTo(imageInfoImage.snp.width).multipliedBy(1.5)
        }
        
        stackDetailMain.snp.makeConstraints{
            $0.top.equalTo(buttonBookCount.snp.bottom).offset(20)
            $0.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        
        labelInfoHeader.snp.makeConstraints{
            $0.leading.top.trailing.equalToSuperview()
        }
        
        labelAuthor.snp.makeConstraints{
            $0.top.equalTo(labelInfoHeader.snp.bottom).offset(7)
        }
    
        labelInfoAuthor.snp.makeConstraints{
            $0.centerY.equalTo(labelAuthor)
            $0.leading.equalTo(labelAuthor.snp.trailing).offset(8)
        }
        
        labelReleased.snp.makeConstraints{
            $0.top.equalTo(labelAuthor.snp.bottom).offset(5)
        }
        
        labelInfoRelesed.snp.makeConstraints{
            $0.centerY.equalTo(labelReleased.snp.centerY)
            $0.leading.equalTo(labelReleased.snp.trailing).offset(8)
        }
        
        labelPage.snp.makeConstraints{
            $0.top.equalTo(labelReleased.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        labelInfoPages.snp.makeConstraints{
            $0.centerY.equalTo(labelPage)
            $0.leading.equalTo(labelPage.snp.trailing).offset(8)
        }

        stackMatter.snp.makeConstraints{
            $0.top.equalTo(stackDetailMain.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
    }
    
    /// 경고 메소드
    func showAlert(_ messageText: String) {
        let alert = UIAlertController(
            title: "경고",
            message: messageText,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }

    /// 뷰 데이터 변환 메소드
    func setViewData(_ series: Int){
        guard bookData.count != 0 else{
            return
        }
        labelHeader.text = bookData[series-1].title
        labelInfoHeader.text = bookData[series-1].title
        labelInfoAuthor.text = bookData[series-1].author
        labelInfoRelesed.text = convertDateText(bookData[series-1].release_date)
        labelInfoPages.text = "\(bookData[series-1].pages)"
        labelInfoDedication.text = bookData[series-1].dedication
        labelInfoSummary.text = bookData[series-1].summary
        
        switch series {
        case 1:
            imageInfoImage.image = .harrypotter1
        case 2:
            imageInfoImage.image = .harrypotter2
        case 3:
            imageInfoImage.image = .harrypotter3
        case 4:
            imageInfoImage.image = .harrypotter4
        case 5:
            imageInfoImage.image = .harrypotter5
        case 6:
            imageInfoImage.image = .harrypotter6
        case 7:
            imageInfoImage.image = .harrypotter7
        default:
            imageInfoImage.image = .none
        }
    }
}

#Preview{
    ViewController()
}

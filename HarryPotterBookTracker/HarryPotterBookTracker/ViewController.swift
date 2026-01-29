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
    /// 상세정보 개요 뷰
    let viewInfoSummry = SummaryView()
    /// 챕터 스택뷰
    let stackChapters = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        loadBooks()
        configureUI()
        if bookData.count != 0{
            setViewData(book: bookData[0],bookNumber: 0)
        }
    }
    
    /// 책 정보 로드 메소드
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                bookData = books
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
        
        
        let stackButtons = UIStackView()
        stackButtons.axis = .horizontal
        stackButtons.spacing = 10
        stackButtons.alignment = .center
        stackButtons.distribution = .fill
        
        /// 책 수 만큼 버튼 생성
        bookData.enumerated().forEach{ (offset, element) in
            let button = UIButton()
            button.backgroundColor = .systemBlue
            button.setTitle(String(offset+1), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 15
            button.addAction(UIAction {[weak self] _ in  self?.setViewData(book: element, bookNumber: offset)}
                             , for: .touchDown)
            button.snp.makeConstraints{
                $0.width.height.greaterThanOrEqualTo(30)
            }
            stackButtons.addArrangedSubview(button)
        }
        
        // 책 핵심 내용 스택뷰 설정
        let stackDetailMain = UIStackView()
        stackDetailMain.axis = .horizontal
        stackDetailMain.alignment = .top
        stackDetailMain.distribution = .fill
        stackDetailMain.spacing = 10
        
        // 핵심내용 배치용 UIView
        let subView = UIView()
    
        // 이미지 뷰 설정
        imageInfoImage.contentMode = .scaleAspectFit
    
        // 책 제목 설정
        labelInfoHeader.numberOfLines = 0
        labelInfoHeader.adjustsFontSizeToFitWidth = true
        labelInfoHeader.font = UIFont.boldSystemFont(ofSize: 20)
        labelInfoHeader.textColor = .black
        
        // 책 저자 설정
        let labelAuthor = UILabel()
        labelAuthor.font = UIFont.boldSystemFont(ofSize: 16)
        labelAuthor.textColor = .black
        labelAuthor.text = "Author"
        labelInfoAuthor.font = UIFont.systemFont(ofSize: 18)
        labelInfoAuthor.textColor = .darkGray
        
        // 책 연도 설정
        let labelReleased = UILabel()
        // 책 페이지 설정
        let labelPage = UILabel()
        
        [labelReleased, labelPage].forEach{
            $0.font = UIFont.boldSystemFont(ofSize: 14)
            $0.textColor = .black
        }
        labelReleased.text = "Released"
        labelPage.text = "Page"

        [labelInfoRelesed, labelInfoPages].forEach{
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = .gray
        }

        // 스택뷰 삽입
        view.addSubview(labelHeader)
        view.addSubview(stackButtons)
        subView.addSubview(labelInfoHeader)
        subView.addSubview(labelAuthor)
        subView.addSubview(labelInfoAuthor)
        subView.addSubview(labelReleased)
        subView.addSubview(labelInfoRelesed)
        subView.addSubview(labelPage)
        subView.addSubview(labelInfoPages)
        stackDetailMain.addArrangedSubview(imageInfoImage)
        stackDetailMain.addArrangedSubview(subView)
        
        /// 책 구성 스택뷰
        let stackMatter = UIStackView()
        stackMatter.axis = .vertical
        stackMatter.alignment = .top
        stackMatter.spacing = 24
        
        // 헌사 스택뷰
        let stackDedication = UIStackView()
        // 개요 스텍뷰
        let stackSummary = UIStackView()
        [stackDedication, stackSummary].forEach{
            $0.axis = .vertical
            $0.alignment = .top
            $0.spacing = 8
        }
        
        // 헌사 설정
        let labelDedication = UILabel()
        labelDedication.font = UIFont.boldSystemFont(ofSize: 18)
        labelDedication.textColor = .black
        labelDedication.text = "Dedication"
        labelInfoDedication.font = UIFont.systemFont(ofSize: 14)
        labelInfoDedication.textColor = .darkGray
        labelInfoDedication.numberOfLines = 0
        stackDedication.addArrangedSubview(labelDedication)
        stackDedication.addArrangedSubview(labelInfoDedication)
        
        // 개요 설정
        let labelSummary = UILabel()
        labelSummary.font = UIFont.boldSystemFont(ofSize: 18)
        labelSummary.textColor = .black
        labelSummary.text = "Summary"
        stackSummary.addArrangedSubview(labelSummary)
        stackSummary.addArrangedSubview(viewInfoSummry)
        
        // 챕터 스택뷰 설정
        let stackChapter = UIStackView()
        [stackChapter, stackChapters].forEach{
            $0.axis = .vertical
            $0.alignment = .top
            $0.distribution = .fill
            $0.spacing = 8
        }
        
        // 책 챕터 라벨 설정
        let labelChapter = UILabel()
        labelChapter.font = UIFont.boldSystemFont(ofSize: 18)
        labelChapter.textColor = .black
        labelChapter.text = "Chapters"
        
        // 스택뷰에 책 헌사 및 개요 삽입
        stackMatter.addArrangedSubview(stackDedication)
        stackMatter.addArrangedSubview(stackSummary)
        stackChapter.addArrangedSubview(labelChapter)
        stackChapter.addArrangedSubview(stackChapters)
        
        // 스크롤 뷰에 컨트롤 삽입
        let scrollViewInfo = UIScrollView()
        scrollViewInfo.horizontalScrollIndicatorInsets = .zero
        scrollViewInfo.addSubview(stackDetailMain)
        scrollViewInfo.addSubview(stackMatter)
        scrollViewInfo.addSubview(stackChapter)
        view.addSubview(scrollViewInfo)

        // 오토 레이아웃 선언부
        labelHeader.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }

        stackButtons.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(labelHeader.snp.bottom).offset(16)
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }

        stackDetailMain.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
        
        labelInfoHeader.snp.makeConstraints{
            $0.leading.top.trailing.equalToSuperview()
        }
        
        imageInfoImage.snp.makeConstraints{
            $0.width.equalTo(100)
            $0.height.equalTo(imageInfoImage.snp.width).multipliedBy(1.5)
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
            $0.width.equalToSuperview()
        }
        
        stackChapter.snp.makeConstraints{
            $0.top.equalTo(stackMatter.snp.bottom).offset(24)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        scrollViewInfo.snp.makeConstraints{
            $0.top.equalTo(stackButtons.snp.bottom).offset(18)
            //$0.width.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    /// 경고 메시지 출력 메소드
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
    func setViewData(book: Book, bookNumber: Int){
        imageInfoImage.image = UIImage(named: "harrypotter\(bookNumber+1)")
        labelHeader.text = book.title
        labelInfoHeader.text = book.title
        labelInfoAuthor.text = book.author
        labelInfoRelesed.text = convertDateText(book.release_date)
        labelInfoPages.text = "\(book.pages)"
        labelInfoDedication.text = book.dedication
        viewInfoSummry.setLabelText(book.summary, bookNumber)
        
        
        if book.chapters.count > stackChapters.arrangedSubviews.count{
            for _ in 1...(book.chapters.count - stackChapters.arrangedSubviews.count){
                stackChapters.addArrangedSubview(getUILabelToChapter(""))
            }
        }
        stackChapters.arrangedSubviews.enumerated().forEach{
            guard let label = $0.element as? UILabel else {
                return
            }
            if $0.offset < book.chapters.count{
                label.text = book.chapters[$0.offset].title
                label.isHidden = false
            }
            else{
                label.isHidden = true
            }
        }
    }
    
    /// 챕터에 배치될 라벨 생성 메소드
    func getUILabelToChapter(_ Chapter: String)-> UILabel{
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = Chapter
        
        return label
    }
}

#Preview{
    ViewController()
}

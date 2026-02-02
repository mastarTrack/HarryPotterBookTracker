//
//  MainView.swift
//  HarryPotterBookTracker
//
//  Created by Hanjuheon on 1/30/26.
//

import UIKit
import SnapKit

/// 메인 뷰 클래스
class MainView: UIView{
    
    /// 제목 헤더 레이블
    private let labelHeader = UILabel()
    /// 책 권수 버튼을 담기위한 스택 뷰
    private let stackButtons = UIStackView()
    /// 책 이미지뷰
    private let imageInfoImage = UIImageView()
    /// 상세정보 제목 레이블
    private let labelInfoHeader = UILabel()
    /// 상세정보 저자 레이블
    private let labelInfoAuthor = UILabel()
    /// 상세정보 책 출시일 레이블
    private let labelInfoRelesed = UILabel()
    /// 상세정보 페이지 레이블
    private let labelInfoPages = UILabel()
    /// 상세정보 헌사 레이블
    private let labelInfoDedication = UILabel()
    /// 상세정보 개요 뷰
    private let viewInfoSummry = SummaryView()
    /// 챕터 스택뷰
    private let stackChapters = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI 초기 설정
    private func configureUI() {
        
        /// 핵심내용 배치용 UIView
        let subView = UIView()
        
        /// 책 핵심 내용 스택뷰
        let stackDetailMain = UIStackView()
        /// 책 구성 스택뷰
        let stackMatter = UIStackView()
        /// 헌사 스택뷰
        let stackDedication = UIStackView()
        /// 개요 스텍뷰
        let stackSummary = UIStackView()
        /// 챕터 스택뷰 설정
        let stackChapter = UIStackView()
        
        /// 챕터전용 스크롤 뷰
        let scrollViewInfo = UIScrollView()
        

        /// 책 저자 타이틀 레이블
        let labelAuthor = UILabel()
        /// 책 연도 타이틀 레이블
        let labelReleased = UILabel()
        /// 책 페이지 설정
        let labelPage = UILabel()
        /// 헌사 타이틀 레이블
        let labelDedication = UILabel()
        /// 개요 타이틀 레이블
        let labelSummary = UILabel()
        /// 책 챕터 타이틀 레이블
        let labelChapter = UILabel()

        
        /// UI 설졍
        labelHeader.textColor = .black
        labelHeader.textAlignment = .center
        labelHeader.font = UIFont.boldSystemFont(ofSize: 24)
        labelHeader.numberOfLines = 0
        
        stackButtons.axis = .horizontal
        stackButtons.spacing = 10
        stackButtons.alignment = .center
        stackButtons.distribution = .fill
    
        imageInfoImage.contentMode = .scaleAspectFit

        labelAuthor.font = UIFont.boldSystemFont(ofSize: 16)
        labelAuthor.textColor = .black
        labelAuthor.text = "Author"
        [labelReleased, labelPage].forEach{
            $0.font = UIFont.boldSystemFont(ofSize: 14)
            $0.textColor = .black
        }
        labelReleased.text = "Released"
        labelPage.text = "Page"
        
        labelInfoHeader.numberOfLines = 0
        labelInfoHeader.adjustsFontSizeToFitWidth = true
        labelInfoHeader.font = UIFont.boldSystemFont(ofSize: 20)
        labelInfoHeader.textColor = .black
        labelInfoAuthor.font = UIFont.systemFont(ofSize: 18)
        labelInfoAuthor.textColor = .darkGray
        [labelInfoRelesed, labelInfoPages].forEach{
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = .darkGray
        }
        
        labelDedication.font = UIFont.boldSystemFont(ofSize: 18)
        labelDedication.textColor = .black
        labelDedication.text = "Dedication"
        labelSummary.font = UIFont.boldSystemFont(ofSize: 18)
        labelSummary.textColor = .black
        labelSummary.text = "Summary"
        labelChapter.font = UIFont.boldSystemFont(ofSize: 18)
        labelChapter.textColor = .black
        labelChapter.text = "Chapters"
        
        labelInfoDedication.font = UIFont.systemFont(ofSize: 14)
        labelInfoDedication.textColor = .darkGray
        labelInfoDedication.numberOfLines = 0
        
        scrollViewInfo.horizontalScrollIndicatorInsets = .zero
        
        stackDetailMain.axis = .horizontal
        stackDetailMain.alignment = .top
        stackDetailMain.distribution = .fill
        stackDetailMain.spacing = 10
        [stackMatter, stackDedication, stackSummary].forEach {
            $0.axis = .vertical
            $0.alignment = .top
            $0.spacing = 8
        }
        stackMatter.spacing = 24
        
        [stackChapter, stackChapters].forEach {
            $0.axis = .vertical
            $0.alignment = .top
            $0.distribution = .fill
            $0.spacing = 8
        }
        
        // 책 상세 내용 삽입
        [labelInfoHeader, labelAuthor, labelInfoAuthor, labelReleased, labelInfoRelesed, labelPage, labelInfoPages].forEach { subView.addSubview($0)}
        stackDetailMain.addArrangedSubview(imageInfoImage)
        stackDetailMain.addArrangedSubview(subView)

        // 헌사, 개요, 챕터 삽입
        stackDedication.addArrangedSubview(labelDedication)
        stackDedication.addArrangedSubview(labelInfoDedication)
        stackSummary.addArrangedSubview(labelSummary)
        stackSummary.addArrangedSubview(viewInfoSummry)
        stackMatter.addArrangedSubview(stackDedication)
        stackMatter.addArrangedSubview(stackSummary)
        stackChapter.addArrangedSubview(labelChapter)
        stackChapter.addArrangedSubview(stackChapters)
        scrollViewInfo.addSubview(stackDetailMain)
        scrollViewInfo.addSubview(stackMatter)
        scrollViewInfo.addSubview(stackChapter)
        
        // 메인 뷰에 삽입
        addSubview(labelHeader)
        addSubview(stackButtons)
        addSubview(scrollViewInfo)
        
        // 오토 레이아웃 선언부
        labelHeader.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.width.greaterThanOrEqualTo(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
        }
        
        stackButtons.snp.makeConstraints  {
            $0.centerX.equalToSuperview()
            $0.height.width.greaterThanOrEqualTo(10)
            $0.top.equalTo(labelHeader.snp.bottom).offset(16)
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        stackDetailMain.snp.makeConstraints {
            $0.height.width.greaterThanOrEqualTo(10)
            $0.top.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
        
        labelInfoHeader.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
        
        imageInfoImage.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(imageInfoImage.snp.width).multipliedBy(1.5)
        }
        
        labelAuthor.snp.makeConstraints {
            $0.top.equalTo(labelInfoHeader.snp.bottom).offset(7)
        }
        
        labelInfoAuthor.snp.makeConstraints {
            $0.centerY.equalTo(labelAuthor)
            $0.leading.equalTo(labelAuthor.snp.trailing).offset(8)
        }
        
        labelReleased.snp.makeConstraints {
            $0.top.equalTo(labelAuthor.snp.bottom).offset(5)
        }
        
        labelInfoRelesed.snp.makeConstraints{
            $0.centerY.equalTo(labelReleased.snp.centerY)
            $0.leading.equalTo(labelReleased.snp.trailing).offset(8)
        }
        
        labelPage.snp.makeConstraints {
            $0.top.equalTo(labelReleased.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        labelInfoPages.snp.makeConstraints {
            $0.centerY.equalTo(labelPage)
            $0.leading.equalTo(labelPage.snp.trailing).offset(8)
        }
        
        stackMatter.snp.makeConstraints {
            $0.top.equalTo(stackDetailMain.snp.bottom).offset(24)
            $0.width.equalToSuperview()
        }
        
        stackChapter.snp.makeConstraints {
            $0.top.equalTo(stackMatter.snp.bottom).offset(24)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        scrollViewInfo.snp.makeConstraints {
            $0.top.equalTo(stackButtons.snp.bottom).offset(18)
            //$0.width.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    /// 책 권수 대비 버튼 및 버튼 액션 생성 메소드
    func makeBooksButtons(books:[Book]) {
        /// 책 수 만큼 버튼 생성
        books.enumerated().forEach{ (offset, element) in
            let button = UIButton()
            button.backgroundColor = .systemBlue
            button.setTitle(String(offset+1), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 15
            button.addAction(UIAction { [weak self] _ in  self?.setViewData(book: element, bookNumber: offset)}
                             , for: .touchDown)
            button.snp.makeConstraints {
                $0.width.height.greaterThanOrEqualTo(30)
            }
            stackButtons.addArrangedSubview(button)
        }
    }
    
    /// 뷰 데이터 변환 메소드
    func setViewData(book: Book, bookNumber: Int) {
        imageInfoImage.image = UIImage(named: "harrypotter\(bookNumber+1)")
        labelHeader.text = book.title
        labelInfoHeader.text = book.title
        labelInfoAuthor.text = book.author
        labelInfoRelesed.text = convertDateText(book.release_date)
        labelInfoPages.text = "\(book.pages)"
        labelInfoDedication.text = book.dedication
        viewInfoSummry.setLabelText(book.summary, bookNumber)
        
        
        if book.chapters.count > stackChapters.arrangedSubviews.count {
            for _ in 1...(book.chapters.count - stackChapters.arrangedSubviews.count) {
                stackChapters.addArrangedSubview(getUILabelToChapter(""))
            }
        }
        stackChapters.arrangedSubviews.enumerated().forEach {
            guard let label = $0.element as? UILabel else {
                return
            }
            if $0.offset < book.chapters.count {
                label.text = book.chapters[$0.offset].title
                label.isHidden = false
            } else {
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
  MainView()
}

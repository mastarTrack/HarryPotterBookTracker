//
//  ViewController.swift
//  harrypotter
//
//  Created by 손영빈 on 1/22/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let dataService = DataService() // DataService 생성
    var books: [Book] = [] //받아온 데이터 저장용 배열
    
    let titleText = UILabel()
    
    
    //    let seriesButton = SeriesButton()
    let seriesStackView = UIStackView()
    var seriesButtons: [SeriesButton] = []
    
    let scrollView = UIScrollView() // 스크롤 뷰 생성
    let contentView = UIStackView() // 스크롤 뷰 내부 메인 뷰
    
    let bookInfoView = BookInfoStackView() // bookInfoView 생성
    let bookSummaryStackView = BookSummaryStackView()
    let bookChapterStackView = BookChapterStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        loadBooks()
    }
    
}


extension ViewController {
    private func configUI() {
        
        bookSummaryStackView.delegate = self // bookSummaryStackView의 delegate는 ViewController 자신이다.
        view.backgroundColor = .white
        
        //        titleText.text = "ASDFASDFASDFASDFSADFSADFASDFSADFSADFSADFSADS"
        titleText.textColor = .black
        titleText.font = .systemFont(ofSize: 24, weight: .bold)
        titleText.numberOfLines = 0 // 줄 바꿈 제한 x
        titleText.textAlignment = .center // 텍스트 중앙 정렬
        
        //        seriesButton.setTitle("1", for: .normal)
        //        seriesButton.setTitleColor(.white , for: .normal)
        //        seriesButton.titleLabel?.font = .systemFont(ofSize: 16)
        //        seriesButton.backgroundColor = .systemBlue
        //        seriesButton.layer.cornerRadius = 8
        
        seriesStackView.axis = .horizontal
        seriesStackView.spacing = 6
        seriesStackView.distribution = .fillEqually
        seriesStackView.alignment = .center
        
        scrollView.showsVerticalScrollIndicator = false // 스크롤 바 숨기기
        
        contentView.axis = .vertical
        contentView.spacing = 24 // contentView 내부 컴포넌트들의 거리 24
        contentView.alignment = .leading
        
        [titleText, seriesStackView, scrollView].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        
        //        view.addSubview(bookInfoView) // bookInfoView 추가
        //        view.addSubview(bookSummaryStackView) //bookSummaryStackView 추가
        [bookInfoView, bookSummaryStackView, bookChapterStackView].forEach {
            contentView.addArrangedSubview($0)
        }
        
        titleText.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        seriesStackView.snp.makeConstraints {
            //            $0.leading.trailing.equalToSuperview().inset(20)
            $0.leading.trailing.greaterThanOrEqualToSuperview().inset(20) // leading, trailing 추가
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleText.snp.bottom).offset(16)
            /*$0.width.equalTo(seriesButton.snp.height)*/ // height에 width 고정 -> 가로, 세로 비율 유지
        }
        
        //scrollView 속성 정의
        scrollView.snp.makeConstraints {
            $0.top.equalTo(seriesStackView.snp.bottom).offset(20) // seriesStackView 기준으로 변경
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        //contentView 속성 정의 -> scrollView에 맞춤
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        //        bookInfoView.snp.makeConstraints {
        //            $0.top.equalTo(seriesButton.snp.bottom).offset(20)
        //            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        //        }
        //
        //        bookSummaryStackView.snp.makeConstraints {
        //            $0.top.equalTo(bookInfoView.snp.bottom).offset(24)
        //            $0.leading.trailing.equalToSuperview().inset(20)
        //        }
        
    }
}

// UIButton 상속받는 커스텀 SeriesButton 생성 : ( 레이아웃 결정 이후 cornerRadius 적용되기 때문 )
class SeriesButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

// data.json 파싱 이후 titleText에 적용, book에도 적용
extension ViewController {
    
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let books):
                self.books = books
                self.setSeriesButton(with: books)
                if let firstBook = books.first {
                    self.infoUpdate(with: firstBook, idx: 0) // 업데이트 정보가 많아져서 함수로 분리
                    selectedSeriesButton(0) // 기본 앱 실행 시 1권 표시 : 1번 버튼 선택
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                
                
//                self.present(alert, animated: true)
                
                
            }
        }
    }
    
    // 정보 업데이트 함수 분리
    func infoUpdate(with book: Book, idx: Int) {
        self.titleText.text = book.title
        self.bookInfoView.configure(with: book, idx: idx) // bookInfoView.configure 함수에 idx 넘겨주기
        
        // isFolded_\(book.title) 상대로 저장하는 이유 : 다음 챕터에서 책에 따라 버튼 생성 시 개별적으로 상태 저장하기 위해
        let isSaved = UserDefaults.standard.object(forKey: "isFolded_\(book.title)") != nil // UserDefauls에 isFolded_isFolded_\(book.title) 상태로 저장된 값 유무 확인
        self.bookSummaryStackView.config(dedication: book.dedication, summary: book.summary, folded: isSaved)

        self.bookChapterStackView.config(with: book.chapters)
    }
}

// 버튼 관련 메소드 관리
extension ViewController {
    
    // 기존 : 버튼 1개 생성 -> 배열로 받아와서 개수만큼 버튼 생성
    private func setSeriesButton(with books: [Book]) {
        
        // 기본 버튼 생성, 속성 정의
        for idx in books.indices {
            let button = SeriesButton()
            button.setTitle("\(idx + 1)", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16)
            button.backgroundColor = .systemGray5
            button.tag = idx
            button.addTarget(self, action: #selector(seriesButtonTapped(_:)), for: .touchDown)
            
            button.snp.makeConstraints {
                $0.width.equalTo(button.snp.height)
            }
            seriesStackView.addArrangedSubview(button)
            seriesButtons.append(button)
        }
    }
    
    // 버튼을 눌렀을 때, 동작하는 메서드 정의
    @objc
    private func seriesButtonTapped(_ sender: SeriesButton) {
        let idx = sender.tag
        let book = books[idx]
        
        infoUpdate(with: book, idx: idx) // infoUpdate에 idx 넘겨주기
        self.scrollView.setContentOffset(.zero, animated: false) // 스크롤 위치 초기화
        selectedSeriesButton(idx)
        
    }
    
    // 버튼 눌렸을 때 상태 변화 메서드 정의
    private func selectedSeriesButton(_ selectedSeriesIdx: Int) {
        for (idx, btn) in seriesButtons.enumerated() {
            btn.backgroundColor = (idx == selectedSeriesIdx) ? .systemBlue : .systemGray5
            
            let titleColor: UIColor = (idx == selectedSeriesIdx) ? .white : .systemBlue
            btn.setTitleColor(titleColor, for: .normal)
        }
    }
}

// Delegate 사용
extension ViewController: BookSummaryStackViewDelegate {
    
    func onTapExtraButton(isFolded: Bool) {
        guard let title = titleText.text else { return }
        
        if isFolded {
            UserDefaults.standard.set(true, forKey: "isFolded_\(title)") // 접혀있는 상태일 경우, UserDefaults에 isFolded_\(title) 형태로 저장
        } else {
            UserDefaults.standard.removeObject(forKey: "isFolded_\(title)") // 더보기 상태일 경우, UserDefaults에 저장된 isFolded_\(title) 제거
        }
    }
}


@available(iOS 17.0, *)
#Preview{
    ViewController()
}

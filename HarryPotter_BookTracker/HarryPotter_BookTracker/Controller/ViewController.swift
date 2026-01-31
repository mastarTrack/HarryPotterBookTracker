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
    private(set) var books: [Book] = []
    private(set) var isMore: Bool = false
    
    private let titleLabel = UILabel() // 최상단 제목 레이블
    let seriesButtonStack = SeriesButtonStack()
    
    var selected: Int = 0
    
    private let infoStack = InfoStack()
    private let dedicationStack = SummaryStack()
    private let summaryStack = SummaryStack()
    private let chapterStack = ChapterStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isMore = dataManager.fetchMoreStatus(idx: selected)
        getBooks()
        
        view.backgroundColor = .white
        
        setContents()
        setComponents()
        
        setLayout()
        
        setMoreButton()
        setMoreButtonAction()
    }
    
    func setComponents() {
        seriesButtonStack.set()
        seriesButtonStack.seriesButtons.forEach {
            $0.delegate = self
        }
        
        infoStack.set()
        dedicationStack.set(info: .dedication)
        summaryStack.set(info: .summary)
        chapterStack.set()
    }
    
    func setContents() {
        let book = books[selected]
        
        setTitleLabel(book)
        seriesButtonStack.setContents(num: books.count)
        infoStack.setContents(book: book, idx: selected)
        dedicationStack.setContents(book: book, info: .dedication)
        summaryStack.setContents(book: book, info: .summary, isMore: isMore)
        chapterStack.setContents(book)
    }
    
    func setLayout() {
        let infoScroll = setInfoScroll()
        
        view.addSubview(titleLabel)
        view.addSubview(seriesButtonStack)
        view.addSubview(infoScroll)
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        seriesButtonStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        infoScroll.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(seriesButtonStack.snp.bottom).offset(16)
        }
    }

    // 데이터([Book]) 가져오기
    func getBooks() {
        do {
            books = try dataManager.fetchBooks()
        } catch DataError.fileNotFound {
            showAlert("⛔️ JSON 파일을 찾을 수 없습니다.")
        } catch DataError.parsingFailed(let error) {
            showAlert("⛔️ JSON 파싱 에러: \(error)")
        } catch DataError.emptyData {
            showAlert("⛔️ 데이터가 비어있습니다.")
        }
        catch {
            showAlert("⛔️ 알 수 없는 오류: \(error)")
        }
    }
    
    func setTitleLabel(_ book: Book?) {
        titleLabel.text = book?.title ?? ""
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
}

//MARK: Alert
extension ViewController {
    // Alert 생성
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "오류 발생", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(confirm)

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: 스크롤뷰 설정
extension ViewController {
    func setInfoScroll() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false // 스크롤바 미표시
        
        [infoStack, dedicationStack, summaryStack, chapterStack].forEach {
            scrollView.addSubview($0)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints{
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        infoStack.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(scrollView.contentLayoutGuide)
        }
        
        dedicationStack.snp.makeConstraints {
            $0.top.equalTo(infoStack.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide)
        }
        
        summaryStack.snp.makeConstraints {
            $0.top.equalTo(dedicationStack.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide)
        }
        
        chapterStack.snp.makeConstraints {
            $0.top.equalTo(summaryStack.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
        }
        
        return scrollView
    }
}

extension ViewController {
    func setMoreButton() {
        let button = summaryStack.moreButton
        button.isSelected = isMore
        button.delegate = dataManager // delegate 설정
    }
    
    func setMoreButtonAction() {
        let more = UIAction { [weak self] _ in
            guard let self else { return }
            
            let button = self.summaryStack.moreButton
            button.isSelected.toggle()
            
            // isSelected 상태 저장
            button.delegate?.saveStatus(button.isSelected, idx: selected)
            self.isMore = button.isSelected
            
            // 요약 텍스트 재설정
            self.summaryStack.setContents(book: books[selected], info: .summary, isMore: self.isMore)
        }
        summaryStack.moreButton.addAction(more, for: .touchUpInside)
    }
}

extension ViewController: SeriesButtonDelegate {
    //TODO: isMore 변경
    func update(idx: Int) {
        selected = idx
        let book = books[selected]
        
        setTitleLabel(book)
        
        infoStack.setContents(book: book, idx: selected)
        
        dedicationStack.setContents(book: book, info: .dedication)
        summaryStack.setContents(book: book, info: .summary, isMore: isMore)
        
        chapterStack.setContents(book)
        chapterStack.update() // chapterStack subview 재설정
        
        //            self?.updateChapterStack()
        //            self?.moreButton.isHidden =
        //            self?.summaryLabel.text?.count ?? 0 < 450 ? true : false // 더보기 버튼 표시 여부 설정
    }
}

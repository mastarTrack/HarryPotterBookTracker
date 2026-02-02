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
    private var books: [Book] = []
    private var isMore: Bool = false
    private var selected: Int = 0
    
    private let titleLabel = UILabel() // 최상단 제목 레이블
    private let seriesButtonStack = SeriesButtonStack()
    
    private let infoStack = InfoStack()
    private let dedicationStack = SummaryStack()
    private let summaryStack = SummaryStack()
    private let chapterStack = ChapterStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setInitialData()
        setContents()
        setComponents()
        
        setLayout()
    }
    
    // 데이터 초기값 설정
    private func setInitialData() {
        isMore = dataManager.fetchMoreStatus(idx: selected)
        getBooks()
    }
    
    // 컴포넌트 컨텐츠 설정
    private func setContents() {
        let book = books[selected] // 현재 선택된 책
        
        setTitleLabel(book)
        infoStack.setContents(of: book, idx: selected)
        dedicationStack.setContents(of: book, info: .dedication)
        summaryStack.setContents(of: book, info: .summary, isMore: isMore)
        chapterStack.setContents(of: book)
    }
    
    // 컴포넌트 config 설정
    private func setComponents() {
        // 시리즈 버튼 설정
        seriesButtonStack.setButtonNum(num: books.count)
        seriesButtonStack.set()
        
        // 책 정보 영역 설정
        dedicationStack.setDedicationStack()
        summaryStack.setSummaryStack()
        chapterStack.set()
        
        // 각 버튼 delegate 설정
        setDelegate()
    }
    
    // 컴포넌트 레이아웃 설정
    private func setLayout() {
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
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(seriesButtonStack.snp.bottom).offset(16)
        }
    }
    
    // 버튼 delegate 설정
    private func setDelegate() {
        seriesButtonStack.seriesButtons.forEach {
            $0.delegate = self
        }
        summaryStack.moreButton.delegate = self
    }
    
    // 타이틀 레이블 설정
    private func setTitleLabel(_ book: Book?) {
        titleLabel.text = book?.title ?? ""
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
}

//MARK: 책 데이터 가져오기
extension ViewController {
    // 데이터([Book]) 가져오기
    private func getBooks() {
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
}

//MARK: Alert
extension ViewController {
    // Alert 생성
    private func showAlert(_ message: String) {
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
    private func setInfoScroll() -> UIScrollView {
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

//MARK: 버튼 delegate 동작 정의
extension ViewController: SeriesButtonDelegate {    
    func seriesButtonContentsUpdate(to idx: Int) {
        // 속성 업데이트
        selected = idx
        isMore = dataManager.fetchMoreStatus(idx: selected)
        
        // 컴포넌트 컨텐츠 업데이트
        setContents()
        
        // 컴포넌트 레이아웃 업데이트
        summaryStack.updateMoreButtonIsHidden() // 더보기 버튼 표시 유무 재설정
        chapterStack.update() // chapterStack subview 재설정
    }
}

extension ViewController: MoreButtonDelegate {
    // 권별 더보기 상태 저장
    func moreButtonSaveStatus(_ status: Bool) {
        self.isMore = status
        dataManager.saveMoreStatus(status, idx: selected)
    }
    
    // 요약 레이블 컨텐츠 변경
    func moreButtonUpdateSummaryStack() {
        summaryStack.updateSummaryText(books[selected])
    }
}

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
    
    var titleLabel = UILabel() // 최상단 제목 레이블
    var seriesButtons = [UIButton]()
    let seriesButtonStack = SeriesButtonStack()
    
    var selected: Int = 0
    
    let infoStack = InfoStack()
    let dedicationStack = SummaryStack()
    let summaryStack = SummaryStack()
    
//    var chapterLabels = [UILabel]()
//    var chapterStack = UIStackView()

    let chapterStack = ChapterStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: viewWillAppear에서 해야할까?
        isMore = dataManager.fetchMoreStatus(idx: selected)
        getBooks()
        
        view.backgroundColor = .white
        
        setContents()
        
        seriesButtonStack.set()
        infoStack.set()
        dedicationStack.set(info: .dedication)
        summaryStack.set(info: .summary)
        chapterStack.set()
        
        setLayout()
        
        setMoreButton()
        setMoreButtonAction()
    }
    
    func setContents() {
        let book = books[selected]
        
        setTitleLabel(book)
        seriesButtonStack.setContents(num: books.count)
        infoStack.setContents(book: book, idx: selected)
        dedicationStack.setContents(book: book, info: .dedication)
        summaryStack.setContents(book: book, info: .summary, isMore: isMore)
        chapterStack.setContents(book)
        
//        setChapterLabels(book)
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

//        setChapterLabelStack()
        
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

//MARK: 목차 영역
//extension ViewController {
//    func setChapterLabelStack() {
////        let title = makeInfoTitleLabel(.chapter)
////        chapterStack = setVerticalLabelStack([title] + chapterLabels)
//    }
//    
//    func updateChapterStack() {
//        if chapterStack.subviews.count < chapterLabels.count {
//            let num = chapterLabels.count - chapterStack.subviews.count
//            for i in (chapterLabels.count - 1)..<(chapterLabels.count + num)  {
//                chapterStack.addSubview(chapterLabels[i])
//            }
//        }
//    }
//    
//    func setChapterLabels(_ book: Book?) {
//        let chapters = book?.chapters ?? []
//        
//        // chapterLabels 배열 설정
//        for (i, chapter) in chapters.enumerated() {
//            if i < chapterLabels.count {
//                // 기존 chapterLabels보다 데이터가 적은 경우 - 텍스트 대체
//                chapterLabels[i].text = chapter.title
//            } else if i == chapterLabels.count {
//                // 기존 chapterLabels보다 데이터가 많은 경우 - 레이블 생성 및 추가
//                let text = chapter.title
//                let label = UILabel(
//                    text: text,
//                    font: .systemFont(ofSize: 14),
//                    color: .darkGray
//                )
//                chapterLabels.append(label)
//            }
//        }
//        
//        // chapterLabel 표시 여부 설정
//        for i in chapterLabels.indices {
//            if i >= chapters.count {
//                // chapterLabels가 데이터보다 많은 경우
//                chapterLabels[i].isHidden = true // 레이블 표시 x
//            } else {
//                // chapterLabels가 데이터보다 많지 않은 경우
//                chapterLabels[i].isHidden = false // 레이블 표시 o
//            }
//        }
//    }
//}

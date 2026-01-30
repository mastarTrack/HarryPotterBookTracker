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
    private(set) var books: [Book]?
    private(set) var isMore: Bool = false
    
    var titleLabel = UILabel() // 최상단 제목 레이블
    var seriesButtons = [UIButton]()
    var selected: Int = 0
    
    var bookImageView = UIImageView()
    var infoBookTitleLabel = UILabel()
    var authorLabel = UILabel()
    var releasedDateLabel = UILabel()
    var pagesLabel = UILabel()
    
    var dedicationLabel = UILabel()
    var summaryLabel = UILabel()
    
    var moreButton = MoreButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: viewWillAppear에서 해야할까?
        isMore = dataManager.fetchMoreStatus()
        getBooks()
        
        view.backgroundColor = .white
        
        setContents()
        setLayout()
        
        setMoreButton()
        setMoreButtonAction()
    }
    
    func setContents() {
        let book = books?[selected]
        setTitleLabel(book)
        setContentLabel(book)
        setBookImage(selected)
    }
    
    func setLayout() {
        let seriesButtonStack = setSeriesButtonStack()
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
        
        let book = books?[selected]
        
        let infoStack = setInfoStack()
        let dedicationStack = setSummaryLabelStack(.dedication)
        let summaryStack = setSummaryStack()
        let chapterStack = makeChapterStack(of: book)
        
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
        moreButton.isSelected = isMore
        moreButton.delegate = dataManager // delegate 설정
        
        // configuration 설정
        moreButton.configurationUpdateHandler = { button in
            
            var configuration = UIButton.Configuration.plain()
            
            switch button.state {
            case .normal: // 선택하지 않았을 경우
                configuration.title = "더보기"
            case .selected: // 선택했을 경우
                configuration.title = "접기"
                configuration.baseBackgroundColor = .clear
            default: break
            }
            
            configuration.attributedTitle?.font = .systemFont(ofSize: 14)
            configuration.attributedTitle?.foregroundColor = .systemBlue
            
            button.configuration = configuration
        }
    }
    
    func setMoreButtonAction() {
        let more = UIAction { [weak self] _ in
            self?.moreButton.isSelected.toggle()
            guard let isSelected = self?.moreButton.isSelected else {
                return
            }
            
            // isSelected 상태 저장
            self?.moreButton.delegate?.saveStatus(isSelected)
            self?.isMore = isSelected
            
            // 요약 텍스트 재설정
            self?.summaryLabel.text = self?.getSummaryText()
        }
        moreButton.addAction(more, for: .touchUpInside)
    }
}

//MARK: 목차 영역
extension ViewController {
    func makeChapterStack(of book: Book?) -> UIStackView {
        let title = UILabel(
            text: "Chapter",
            font: .boldSystemFont(ofSize: 18),
            color: .black
        )
        
        let chapters = book?.chapters ?? []
        var chapterLabels: [UILabel] = [title]
        
        for chapter in chapters {
            let text = chapter.title
            let label = UILabel(
                text: text,
                font: .systemFont(ofSize: 14),
                color: .darkGray
            )
            chapterLabels.append(label)
        }
        
        let stackView = UIStackView(arrangedSubviews: chapterLabels)
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        
        return stackView
    }
}

@available(iOS 17.0, *)
#Preview{
    ViewController()
}

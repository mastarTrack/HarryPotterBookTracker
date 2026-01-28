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
        
        let book = getBook(num: 1)
        
        let titleLabel = setTitleLabel(of: book)
        let seriesButton = setSeriesButton()
        let infoScroll = setInfoScroll(of: book)
        
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
    
    func setInfoScroll(of book: Book?) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        let infoStack = setInfoStack(of: book)
        contentView.addSubview(infoStack)
        
        infoStack.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        let dedicationStack = makeDedicationStack(.dedication, of: book)
        let summaryStack = makeDedicationStack(.summary, of: book)
        contentView.addSubview(dedicationStack)
        contentView.addSubview(summaryStack)
        
        dedicationStack.snp.makeConstraints {
            $0.top.equalTo(infoStack.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        summaryStack.snp.makeConstraints {
            $0.top.equalTo(dedicationStack.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        return scrollView
    }

}

//MARK: 제목 영역
extension ViewController {
    // TODO: 책 제목 레이블 생성 함수 분리하기?
    // 책 제목 레이블 생성
    func setTitleLabel(of book: Book?) -> UILabel {
        let text = book?.title ?? ""

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
    
    //TODO: 분리하기
    // 정보 레이블 가로 스택 생성
    func setHorizontalInfoLabelStack(_ info: Description, of book: Book?) -> UIStackView {
        let title = info.rawValue
        let titleLabel = UILabel(
            text: title,
            font: .boldSystemFont(ofSize: 16),
            color: .black
        )
        
        let infoDetail = switch info {
        case .author:
            book?.author ?? ""
        case .pages:
            "\(book?.pages ?? 0)"
        case .release_date:
            formatDate(book?.release_date ?? Date())
        default:
            ""
        }
        
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
    func setInfoLabelStack(of book: Book?) -> UIStackView {
        // 제목 레이블 생성
        let text = getBook(num: 1)?.title ?? ""

        let titleLabel = UILabel(
            text: text,
            font: .boldSystemFont(ofSize: 20),
            color: .black
        )
        titleLabel.numberOfLines  = 0
        
        // 저자, 발간일, 페이지 정보 레이블 스택 생성
        let authorStack = setHorizontalInfoLabelStack(.author, of: book)
        let releasedStack = setHorizontalInfoLabelStack(.release_date, of: book)
        let pagesStack = setHorizontalInfoLabelStack(.pages, of: book)
        
        // 레이블 전체 스택 생성
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorStack, releasedStack, pagesStack])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        
        return stackView
    }
    
    // 정보 영역 스택 생성
    func setInfoStack(of book: Book?) -> UIStackView {
        let imageView = setBookImage()
        let labels = setInfoLabelStack(of: book)
        
        labels.setContentHuggingPriority(.required, for: .vertical)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, labels])
        
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .top
        
        return stackView
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
            guard self.presentedViewController == nil else { return }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // 데이터(책) 가져오기
    func getBook(num: Int) -> Book? {
        var book: Book?
        
        do {
            book = try dataManager.fetchBook(num: num)
        } catch DataError.fileNotFound {
            showAlert("⛔️ 파일을 찾을 수 없습니다.")
        } catch DataError.parsingFailed(let error) {
            showAlert("⛔️ JSON 파싱 에러: \(error)")
        } catch DataError.invalidNumberOfBooks {
            showAlert("⛔️ 유효하지 않은 입력값입니다.")
        } catch {
            showAlert("⛔️ 알 수 없는 오류: \(error)")
        }
        return book
    }
    
    func formatDate(_ released: Date) -> String {
        // dateFormat 설정
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMMM dd, yyyy"
        
        // June 26, 1997 형태의 문자열 반환
        return newFormatter.string(from: released)
    }
}

//MARK: Dedication & Summary 영역
extension ViewController {
    func makeDedicationStack(_ info: Description, of book: Book?) -> UIStackView {
        let title = UILabel(
            text: info.rawValue,
            font: .boldSystemFont(ofSize: 18),
            color: .black
        )
        
        let infoText = switch info {
        case .dedication:
            book?.dedication ?? ""
        case .summary:
            book?.summary ?? ""
        default: ""
        }
        
        let infoLabel = UILabel(
            text: infoText,
            font: .systemFont(ofSize: 14),
            color: .darkGray
        )
        
        infoLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [title, infoLabel])
        
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

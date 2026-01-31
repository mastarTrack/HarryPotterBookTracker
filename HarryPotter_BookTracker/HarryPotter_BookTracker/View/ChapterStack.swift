//
//  InfoAreaStack.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/30/26.
//
import UIKit

class ChapterStack: UIStackView, CustomStackHelper {
    private var chapterCount = 0
    private var chapterLabels: [UILabel] = []
    
    func set() {
        let title = makeInfoTitleLabel(.chapter)
        
        addArrangedSubview(title)
        chapterLabels.forEach { addArrangedSubview($0) }
        
        axis = .vertical
        alignment = .leading
        spacing = 8
    }
    
    func update() {
        // - 1은 타이틀 레이블(Chapter)
        let current = arrangedSubviews.count - 1

        chapterLabels.forEach { $0.isHidden = false } // label 표시 상태 초기화
        
        if chapterCount > current { // 데이터가 더 많을 때 -- label 추가 배치
            for i in current..<chapterCount {
                addArrangedSubview(chapterLabels[i])
            }
        } else if chapterCount < current { // 데이터가 더 적을 때 -- label 가리기
            for i in chapterCount..<current {
                chapterLabels[i].isHidden = true
            }
        }
    }
}

//MARK: 컨텐츠 설정
extension ChapterStack {
    func setContents(of book: Book?) {
        let chapters = book?.chapters ?? []
        
        chapterCount = chapters.count
        
        for (i, chapter) in chapters.enumerated() {
            if i < chapterLabels.count {
                chapterLabels[i].text = chapter.title
            } else {
                let label = UILabel(
                    text: chapter.title,
                    font: .systemFont(ofSize: 14),
                    color: .darkGray
                )
                chapterLabels.append(label)
            }
        }
    }
}

//
//  ButtonDelegate.swift
//  HarryPotter_BookTracker
//
//  Created by 변예린 on 1/29/26.
//

import Foundation

protocol MoreButtonDelegate: AnyObject {
//    func saveIsMoreStatus(_ isMore: Bool)
//    func summarySatackUpdate()
    
    func moreButtonSaveStatus(_ isMore: Bool)
    func moreButtonUpdateSummaryStack()
}

protocol SeriesButtonDelegate: AnyObject {
//    func ContentsUpdate(to idx: Int)
    
    func seriesButtonContentsUpdate(to idx: Int)
}

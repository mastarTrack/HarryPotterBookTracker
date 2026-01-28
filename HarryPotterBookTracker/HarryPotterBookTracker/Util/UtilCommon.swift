//
//  UtilCommon.swift
//  HarryPotterBookTracker
//
//  Created by Hanjuheon on 1/28/26.
//

import Foundation

/// 날짜 포멧 변경 메소드
func convertDateText(_ date:String)->String{
    let inputDateFormatter = DateFormatter()
    inputDateFormatter.dateFormat = "yyyy-MM-dd"
    
    guard let date = inputDateFormatter.date(from: date) else{
        return "알 수 없음"
    }
    let changeDateFormatter = DateFormatter()
    changeDateFormatter.dateFormat = "MMMM dd, yyyy"
    return  changeDateFormatter.string(from: date)
}

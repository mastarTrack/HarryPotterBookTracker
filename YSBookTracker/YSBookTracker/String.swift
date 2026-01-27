//
//  String.swift
//  YSBookTracker
//
//  Created by Yeseul Jang on 1/27/26.
//
import Foundation

extension String {
    func changeToUSADate() -> String? {
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd"

        let output = DateFormatter()
        output.locale = Locale(identifier: "en_US_POSIX")
        output.dateFormat = "MMMM d, yyyy"

        guard let date = input.date(from: self) else {
            return nil
        }

        return output.string(from: date)
    }
}

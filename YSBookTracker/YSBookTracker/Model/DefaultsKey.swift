//
//  DefaultsKey.swift
//  YSBookTracker
//
//  Created by Yeseul Jang on 2/2/26.
//

enum DefaultsKey {
    static func isExpandedKey(volume: Int) -> String {
        return "summary.isExpanded.volume.\(volume)"
    }
}

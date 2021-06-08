//
//  SharePosterText.swift
//  Reborn
//
//  Created by Christian Liu on 14/4/21.
//

import Foundation
struct SharePosterTextData {
    private static let text = ["自由不是随心所欲，而是自我主宰",
                "每天进步一点点",
                "要重返生活就须有所奉献",
                "一切的付出只为了更好的自己",
                "只想更自由",
                "越努力，越幸运",
                "乐观面对每一天",
                "坚持是一种美德",
                "生活不是苟且，还有诗和远方",
    ]
    
    static var randomText: String {
        return SharePosterTextData.text.random ?? "自由不是随心所欲，而是自我主宰"
    }
}

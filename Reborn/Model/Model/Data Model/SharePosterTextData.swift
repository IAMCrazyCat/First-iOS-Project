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
                "生活是天籁,需要凝神静听"]
    
    static var randomText: String {
        return SharePosterTextData.text.random ?? "自由不是随心所欲，而是自我主宰"
    }
}

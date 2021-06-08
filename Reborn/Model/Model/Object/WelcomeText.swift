//
//  WelcomeText.swift
//  Reborn
//
//  Created by Christian Liu on 12/2/21.
//

import Foundation
struct WelcomeText {

    private var midnightFirstText: String = "夜深了，\(AppEngine.shared.currentUser.name)"
    private var morningFirstText: String = "早上好，\(AppEngine.shared.currentUser.name)"
    private var noonFirstText: String = "中午好，\(AppEngine.shared.currentUser.name)"
    private var afternoonFirstText: String = "下午好，\(AppEngine.shared.currentUser.name)"
    private var nightFirstText: String = "晚上好，\(AppEngine.shared.currentUser.name)"
    
    var timeRange: TimeRange
    
    var firstText: String {
        switch timeRange {
        case .midnight:
            return midnightFirstText
        case .morning:
            return morningFirstText
        case .noon:
            return noonFirstText
        case .afternoon:
            return afternoonFirstText
        case .night:
            return nightFirstText
        }
    }
    
    var secondText: String
    
    init(timeRange: TimeRange, secondText: String = "") {
        self.timeRange = timeRange
        self.secondText = secondText
    }
}

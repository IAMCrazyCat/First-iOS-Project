//
//  WelcomeText.swift
//  Reborn
//
//  Created by Christian Liu on 12/2/21.
//

import Foundation
struct WelcomeTextData {
    
    public var secondTextArray: Array<String> = AppEngine.shared.userSetting.encourageText
    private var defultSecondText: String {
        return secondTextArray.first ?? ""
    }
   
    private var midnightTextData: Array<WelcomeText> {
        var textArray: Array<WelcomeText> = []
        for seconText in secondTextArray {
            textArray.append(WelcomeText(timeRange: .midnight, secondText: seconText))
        }
        return textArray
    }
    
    private var morningTextData: Array<WelcomeText> {
        var textArray: Array<WelcomeText> = []
        for seconText in secondTextArray {
            textArray.append(WelcomeText(timeRange: .morning, secondText: seconText))
        }
        return textArray
    }
    
    private var noonTextData: Array<WelcomeText> {
        var textArray: Array<WelcomeText> = []
        for seconText in secondTextArray {
            textArray.append(WelcomeText(timeRange: .noon, secondText: seconText))
        }
        return textArray
    }
    private var afternoonTextData: Array<WelcomeText> {
        var textArray: Array<WelcomeText> = []
        for seconText in secondTextArray {
            textArray.append(WelcomeText(timeRange: .afternoon, secondText: seconText))
        }
        return textArray
    }
    
    private var nightTextData: Array<WelcomeText> {
        var textArray: Array<WelcomeText> = []
        for seconText in secondTextArray {
            textArray.append(WelcomeText(timeRange: .night, secondText: seconText))
        }
        return textArray
    }
    
    public func randomText(timeRange: TimeRange) -> WelcomeText {
        var welcomeText: WelcomeText = WelcomeText(timeRange: timeRange, secondText: defultSecondText)
        
        switch timeRange {
        case .midnight:
            if midnightTextData.count > 0 {
                let index = Int.random(in: 0 ... midnightTextData.count - 1)
                welcomeText = midnightTextData[index]
            }
        case .morning:
            if morningTextData.count > 0 {
                let index = Int.random(in: 0 ... morningTextData.count - 1)
                welcomeText = morningTextData[index]
            }
        case .noon:
            if noonTextData.count > 0 {
                let index = Int.random(in: 0 ... noonTextData.count - 1)
                welcomeText = noonTextData[index]
            }
        case .afternoon:
            if afternoonTextData.count > 0 {
                let index = Int.random(in: 0 ... afternoonTextData.count - 1)
                welcomeText = afternoonTextData[index]
            }
            
        case .night:
            if nightTextData.count > 0 {
                let index = Int.random(in: 0 ... nightTextData.count - 1)
                welcomeText = nightTextData[index]
            }
            
        }
        
        return welcomeText
    }
    
}

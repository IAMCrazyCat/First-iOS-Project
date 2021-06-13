//
//  App.swift
//  Reborn
//
//  Created by Christian Liu on 12/5/21.
//

import Foundation
class App {
    static var name: String {
       return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
    
    static var version: String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let versionBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
        return "\(appVersion) (build\(versionBuild))"
    }
    
    static var simpleVersion: String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        return "\(appVersion)"
    }
}

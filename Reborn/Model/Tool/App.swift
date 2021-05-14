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
}

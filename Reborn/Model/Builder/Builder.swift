//
//  Builder.swift
//  Reborn
//
//  Created by Christian Liu on 29/12/20.
//

import Foundation
import UIKit

protocol Builder {
    func buildStandardView()
    func getBuiltItem() -> Any
    
}

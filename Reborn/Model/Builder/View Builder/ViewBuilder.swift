//
//  Builder.swift
//  Reborn
//
//  Created by Christian Liu on 9/2/21.
//

import Foundation
import UIKit
protocol ViewBuilder {
    func buildView() -> UIView
    func createView() 
}

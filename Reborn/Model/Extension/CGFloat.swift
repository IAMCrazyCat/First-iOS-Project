//
//  CGFloat.swift
//  Reborn
//
//  Created by Christian Liu on 15/3/21.
//

import Foundation
import UIKit
extension CGFloat {
    func rounded(toPlaces places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}

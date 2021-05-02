//
//  Double.swift
//  Reborn
//
//  Created by Christian Liu on 1/5/21.
//

import Foundation
extension Double {
    func round(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

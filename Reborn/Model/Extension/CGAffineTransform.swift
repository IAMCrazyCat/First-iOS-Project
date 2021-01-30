//
//  CGAffineTransform.swift
//  Reborn
//
//  Created by Christian Liu on 29/1/21.
//

import Foundation
import UIKit
extension CGAffineTransform {
    
    var currentScale: Double {
        return sqrt(Double(self.a * self.a + self.c * self.c))
    }
    
    
}

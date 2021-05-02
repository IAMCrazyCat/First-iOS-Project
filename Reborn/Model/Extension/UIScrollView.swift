//
//  UIScrollView.swift
//  Reborn
//
//  Created by Christian Liu on 2/5/21.
//

import Foundation
import UIKit
extension UIScrollView {
    func scrollToTop(animated: Bool) {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        self.setContentOffset(desiredOffset, animated: animated)
   }
    
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.height + self.contentInset.bottom)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}

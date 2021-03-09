//
//  ConfettiCell.swift
//  Reborn
//
//  Created by Christian Liu on 9/3/21.
//

import Foundation
import UIKit
import SpriteKit
class ConfettiCell: UIImageView {
    
    var position: CGPoint = .zero {
        didSet {
            self.frame.origin = self.position
        }
    }
    
    var size: ConfettiSize = .small {
        didSet {
            
            switch size {
            case .small:
                self.frame.size = CGSize(width: 10, height: 10)
                self.layer.zPosition = 0
            case .medium:
                self.frame.size = CGSize(width: 20, height: 20)
                self.layer.zPosition = 1
            case .large:
                self.frame.size = CGSize(width: 30, height: 30)
                self.layer.zPosition = 2
            }
           
        }
    }
    
    var color: UIColor = .red {
        didSet {
            self.tintColor = color
        }
    }

    init(confetti: UIImage) {
        
        super.init(frame: .zero)
        self.image = confetti
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

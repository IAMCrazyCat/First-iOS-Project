//
//  ConfettiCell.swift
//  Reborn
//
//  Created by Christian Liu on 9/3/21.
//

import Foundation
import UIKit
import SpriteKit
class ConfettiCell: SKSpriteNode {
    
    var image: UIImage {
        didSet {
            self.texture = SKTexture(image: image)
        }
    }
    

    var confettiSize: ConfettiSize
    
    override var physicsBody: SKPhysicsBody? {
        didSet {
            switch self.confettiSize {
            case .small:
                self.zPosition = 0
                self.physicsBody?.linearDamping = CGFloat.random(in: 0.25 ... 0.35)
            case .medium:
                self.zPosition = 1
                self.physicsBody?.linearDamping = CGFloat.random(in: 0.15 ... 0.25)
            case .large:
                self.physicsBody?.linearDamping = CGFloat.random(in: 0.1 ... 0.15)
                self.zPosition = 2
            }
        }
    }

    init(image: UIImage, color: UIColor, size: ConfettiSize) {

        self.image = image
        self.confettiSize = size
        let cgSize: CGSize
        
        switch self.confettiSize {
        case .small:
            cgSize = CGSize(width: 10, height: 10)
        case .medium:
            cgSize = CGSize(width: 15, height: 15)
        case .large:
            cgSize = CGSize(width: 20, height: 20)
        }
        
        
        
        super.init(texture: SKTexture(image: self.image.withTintColor(color)), color: color, size: cgSize)
        self.colorBlendFactor = 1
        
        
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//
//  ConfettiAnimation.swift
//  Reborn
//
//  Created by Christian Liu on 9/3/21.
//

import Foundation
import UIKit
class ConfettiAnimationView: UIView {

    var animator: UIDynamicAnimator? = nil
    var gravity: UIGravityBehavior? = nil
    var vector: CGVector? = nil
    var confettiCells: Array<ConfettiCell> = []
    var confettiImages: Array<UIImage> = [#imageLiteral(resourceName: "confetti"), #imageLiteral(resourceName: "star"), #imageLiteral(resourceName: "diamond"), #imageLiteral(resourceName: "triangle.png")]
    var confettiSize: Array<ConfettiSize> = [.small, .medium, .large]
    var confettiColors: Array<UIColor> = [.red, .green, .blue, .purple]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        addConfettiCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConfettiCells() {
        let confettiCell = ConfettiCell(confetti: self.confettiImages.random!)
        confettiCell.position = CGPoint(x: Int.random(in: 0 ... Int(self.bounds.maxX)), y: 0)
        confettiCell.size = self.confettiSize.random!
        confettiCell.color = self.confettiColors.random!
        confettiCell.physic
        self.addSubview(confettiCell)
        self.confettiCells.append(confettiCell)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .repeat, animations: {
            confettiCell.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), CGFloat( Double.pi), CGFloat(Double.pi), 1.0)
        })

    }
    
    func excuteAnimation() {
        
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            
            
        }
        

        self.animator = UIDynamicAnimator(referenceView: self)
        self.gravity = UIGravityBehavior(items: self.confettiCells)
        self.vector = CGVector(dx: 0.0, dy: 1.0)
        self.gravity?.gravityDirection = self.vector!
        self.gravity?.magnitude = 1
        self.animator?.addBehavior(self.gravity!)
        
        
        
        
        
    }
    
}

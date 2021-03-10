//
//  ConfettiAnimation.swift
//  Reborn
//
//  Created by Christian Liu on 9/3/21.
//

import Foundation
import UIKit
import SpriteKit
class ConfettiAnimationView: UIView {

    private var skView: SKView?
    private var skScene: SKScene?
    
    private var confettiCells: Array<ConfettiCell> = []
    private var confettiImages: Array<UIImage> = [#imageLiteral(resourceName: "confetti"), #imageLiteral(resourceName: "star"), #imageLiteral(resourceName: "diamond"), #imageLiteral(resourceName: "triangle.png")]
    private var confettiSize: Array<ConfettiSize> = [.small, .small, .medium, .large]
    private var confettiColors: Array<UIColor> = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                                          UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                                          UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                                          UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                                          UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
    lazy var initialBurstPosition: CGPoint = CGPoint(x: self.skView!.bounds.width / 2, y: self.skView!.bounds.height + 150)
    private var randomZeroToOne: CGFloat {
        return CGFloat.random(in: 0 ... 1)
    }
    private var randomPointFiveToOne: CGFloat {
        return CGFloat.random(in: 0.5 ... 1)
    }
    
    public var density: Int = 1000
    public var animationSpeed: TimeInterval = 0.7
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        self.skView = SKView(frame: self.bounds)
        self.skScene = SKScene(size: self.bounds.size)
       

        setUpSKView()
        setUpSKScene()
        
        for _ in 0 ... self.density {
            addConfettiCells()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSKView() {
        self.skView!.showsFPS = true
        self.skView!.backgroundColor = .clear
    }
    
    func setUpSKScene() {
        self.skScene!.physicsWorld.gravity = CGVector(dx: 0, dy: -1.62 * animationSpeed)
        self.skScene!.backgroundColor = .clear
    }
    
    func addConfettiCells() {
       
       
        let confettiNode = ConfettiCell(image: self.confettiImages.random!, color: self.confettiColors.random!, size: self.confettiSize.random!)
        let initialSpeed: Double = 300
        var randomSpeed: TimeInterval {
            return TimeInterval.random(in: 0.3 ... 0.6)
        }
        let spinSpeed: TimeInterval = randomSpeed
        let rotateSpeed: TimeInterval = randomSpeed
        let randomX: CGFloat = randomPointFiveToOne
        let randomY: CGFloat = randomPointFiveToOne
        
        let rotateSequency = SKAction.rotate(byAngle: CGFloat.random(in: 0 ... CGFloat(180) * CGFloat.pi / 180), duration: spinSpeed)
        let scaleSequence = SKAction.sequence([SKAction.scaleY(to: -1, duration: spinSpeed),
                                               SKAction.scaleY(to: 1, duration: spinSpeed)]
                                              )
                                         
        let darkenSequence = SKAction.sequence([SKAction.colorize(with: SKColor.black, colorBlendFactor: 0.25, duration: randomSpeed), SKAction.colorize(withColorBlendFactor: 0, duration: randomSpeed)])
        let group = SKAction.group([rotateSequency, scaleSequence])
        let initialPositionOffset: CGFloat = 50
        
        confettiNode.position = CGPoint(x: CGFloat.random(in: initialBurstPosition.x - initialPositionOffset ... initialBurstPosition.x + initialPositionOffset), y: CGFloat.random(in: initialBurstPosition.y - initialPositionOffset ... initialBurstPosition.y + initialPositionOffset))
        confettiNode.physicsBody = SKPhysicsBody(rectangleOf: self.skView!.bounds.size)
        confettiNode.run(SKAction.repeatForever(group))
        confettiNode.xScale = -1
        confettiNode.physicsBody?.collisionBitMask = 0
//        let randomPointX = Double.random(in: -1 ... 1)
//        let randomPointY = Double.random(in: sin(Double.random(in: -180 ... 0) * Double.pi / 180) ... 0)
        let randomPointX = Double.random(in: -1 ... 1)
        let randomPointY = Double.random(in: -1 ... 1)
        confettiNode.physicsBody?.velocity = CGVector(dx: randomPointX * initialSpeed, dy: randomPointY * initialSpeed)
            
       
        self.skScene!.addChild(confettiNode)
        self.addSubview(skView!)

        
        

    }
    
    func excuteAnimation() {
        
        self.skView!.presentScene(self.skScene!)
        
        UIView.animate(withDuration: 0.5, delay: 8, options: .curveEaseOut, animations: {
            //self.animationSpeed += 0.5
            //self.skScene?.physicsWorld.gravity = CGVector(dx: 0, dy: -1.62 * self.animationSpeed)
        }) { _ in
            
        }
      
//        self.animator = UIDynamicAnimator(referenceView: self)
//        self.gravity = UIGravityBehavior(items: self.confettiCells)
//        self.vector = CGVector(dx: 0.0, dy: 1.0)
//        self.gravity?.gravityDirection = self.vector!
//        self.gravity?.magnitude = 1
//        self.animator?.addBehavior(self.gravity!)
        
        
        
        
        
    }
    
}

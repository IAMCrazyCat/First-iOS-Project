//
//  EncourageTextView.swift
//  Reborn
//
//  Created by Christian Liu on 5/7/21.
//

import Foundation
import UIKit
class EncourageTextView: UIView {
    public var text: String
    public var textView: UITextView
    private var movingField: CGSize
    private var delegate: UITextViewDelegate
    private var originalPosition: CGPoint = .zero
    private var randomDuration: TimeInterval = TimeInterval.random(in: 10 ... 20)
    private var randomPosition: CGPoint {
        return CGPoint(x: CGFloat.random(in: 0 ... movingField.width - self.frame.width), y: CGFloat.random(in: 0 ... movingField.height - self.frame.height))
    }
    private var temporaryPosition: CGPoint = .zero
   
    public init(text: String, frame: CGRect, movingField: CGSize, delegate: UITextViewDelegate) {
        self.text = text
        self.movingField = movingField
        self.delegate = delegate
        self.textView = UITextView()
        super.init(frame: frame)
        
        self.originalPosition = self.layer.position
        self.backgroundColor = .white.withAlphaComponent(0.3)
        self.setShadow()
        self.setCornerRadius(corderRadius: 20)
        
        textView.delegate = delegate
        textView.text = text
        textView.backgroundColor = .clear
        textView.returnKeyType = .done
        self.addSubview(textView)
        
        let constant: CGFloat = 10
        textView.tintColor = AppEngine.shared.userSetting.smartVisibleThemeColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: constant).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant).isActive = true
        textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: constant).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -constant).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func move() {
        self.movingBack = false
        self.layer.removeAllAnimations()
        let currentPosition = self.layer.presentation()?.position ?? self.layer.position
        self.layer.position = currentPosition
        
        let duration = randomDuration
      
        let toPosition = self.randomPosition
        let movingAnimation = CABasicAnimation(keyPath: "position")
        self.temporaryPosition = toPosition
        movingAnimation.delegate = self
        movingAnimation.fillMode = CAMediaTimingFillMode.forwards
        //movingAnimation.fromValue = self.layer.position
        movingAnimation.toValue = toPosition
        movingAnimation.duration = duration
        movingAnimation.isRemovedOnCompletion = false
        self.layer.add(movingAnimation, forKey: "MovingAnimation")
       
    }
    
    var movingBack: Bool = false
    
    public func moveBack() {
        self.movingBack = true
        self.layer.removeAllAnimations()
        let currentPosition = self.layer.presentation()?.position ?? self.temporaryPosition
        self.layer.position = currentPosition
        
        let movingBackAnimation = CABasicAnimation(keyPath: "position")
        movingBackAnimation.beginTime = CACurrentMediaTime()
        movingBackAnimation.toValue = self.originalPosition
        movingBackAnimation.duration = 1
        movingBackAnimation.fillMode = CAMediaTimingFillMode.forwards
        movingBackAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
        movingBackAnimation.isRemovedOnCompletion = false
        self.layer.add(movingBackAnimation, forKey: "MovingBackAnimation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.movingBack {
                self.layer.position = self.originalPosition
            }
        }
    }
}

extension EncourageTextView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !movingBack {
            //self.layer.removeAllAnimations()
            //self.layer.position = self.temporaryPosition
            self.move()
        }
       
    }
}

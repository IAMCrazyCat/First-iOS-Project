//
//  LoadingAnimationManager.swift
//  Reborn
//
//  Created by Christian Liu on 18/7/21.
//

import Foundation
import UIKit

public enum LoadingAnimationType {
    case leftToRightGradient
    case grayAlpha
}

class LoadingAnimationManager {
    
    public static let shared = LoadingAnimationManager()
    public var animationViews: Array<UIView> = []
    private init() {}
    
    public func add(loadingAnimation animationType: LoadingAnimationType, to view: UIView, frame: CGRect, cornerRadius: CGFloat = 0, identifier: String) {
        
        switch animationType {
        case .leftToRightGradient: addLeftToRightGradientAnimation(to: view, frame: frame, cornerRadius: cornerRadius, identifier: identifier)
        case .grayAlpha: addGrayAlphaAnimation(to: view, frame: frame, cornerRadius: cornerRadius, identifier: identifier)
        }

    }
    
    func add(to view: UIView, circleWidth: CGFloat = 5, circleRadius: CGFloat = 50, proportionallyOnYPosition proportion: Double = 0.5, backgroundAlpha: CGFloat = 0.5, identifier: String) {
        
        addCircleAnimation(to: view, circleWidth: circleWidth, circleRadius: circleRadius, proportionallyOnYPosition: proportion, backgroundAlpha: backgroundAlpha, idenifier: identifier)
    }
    

    public func removeAnimationWith(identifier: String) {
        for animationView in self.animationViews {
            if animationView.accessibilityIdentifier == identifier {
                animationView.removeFromSuperview()
            }
        }
    }
    
    public func removeAllAnimation() {
        for animationView in self.animationViews {
            animationView.removeFromSuperview()
        }
    }
    
    private func checkIfTimeOut(with identifier: String) -> Bool {
        for animationView in animationViews {
            if animationView.accessibilityIdentifier == identifier {
                return true
            }
        }
        return false
    }
    
    
    private func addLeftToRightGradientAnimation(to view: UIView, frame: CGRect, cornerRadius: CGFloat, identifier: String) {
        let animationView = UIView()
        animationView.accessibilityIdentifier = identifier
        animationView.frame = frame
        animationView.backgroundColor = .gray
        animationView.layer.cornerRadius = cornerRadius
        animationView.layer.masksToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let colors = [
            AppEngine.shared.userSetting.themeColor.uiColor.cgColor,
            UIColor.white.cgColor,
            AppEngine.shared.userSetting.themeColor.uiColor.cgColor
        ]
        let locations: [NSNumber] = [
            0.1,
            0.5,
            0.75
        ]
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.frame = animationView.layer.bounds
        animationView.layer.addSublayer(gradientLayer)
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.25]
        gradientAnimation.toValue = [0.75, 1.0, 1.0]
        gradientAnimation.duration = 3.0
        gradientAnimation.repeatCount = Float.infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
        
        self.animationViews.append(animationView)
        view.addSubview(animationView)
    }
    
    private func addGrayAlphaAnimation(to view: UIView, frame: CGRect, cornerRadius: CGFloat, identifier: String) {
        let animationView = UIView()
        animationView.accessibilityIdentifier = identifier
        animationView.frame = frame
        animationView.backgroundColor = SystemSetting.shared.grayColor.withAlphaComponent(0.7)
        animationView.layer.opacity = 0.5
        animationView.layer.cornerRadius = cornerRadius
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 0.5
        alphaAnimation.toValue = 1
        alphaAnimation.duration = 1
        alphaAnimation.repeatCount = Float.infinity
        animationView.layer.add(alphaAnimation, forKey: nil)
        
        self.animationViews.append(animationView)
        view.addSubview(animationView)
    }
    
    private func addCircleAnimation(to view: UIView, circleWidth: CGFloat = 5, circleRadius: CGFloat = 50, proportionallyOnYPosition proportion: Double = 0.5, backgroundAlpha: CGFloat = 0.5, idenifier: String) {

        
        let animationView = UIView()
        animationView.frame = view.bounds
        animationView.backgroundColor = .black.withAlphaComponent(backgroundAlpha)
        animationView.alpha = 0
        animationView.accessibilityIdentifier = idenifier
        view.addSubview(animationView)
        UIView.animate(withDuration: 0.8, animations: {
            animationView.alpha = 1
        })


        let progressWidth: CGFloat = circleWidth
        let circleRadius: CGFloat = circleRadius
        let circleViewCenter = CGPoint(x: view.frame.width / 2 , y: view.frame.height * CGFloat(proportion))
        let progress = 1
        let circleShapePath = UIBezierPath(arcCenter: circleViewCenter, radius: circleRadius, startAngle: -CGFloat.pi / 2, endAngle: CGFloat(progress) * 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        let shapeColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor
        let circleShapeLayer = CAShapeLayer()
        
        circleShapeLayer.path = circleShapePath.cgPath
        circleShapeLayer.strokeColor = shapeColor
        circleShapeLayer.lineWidth = progressWidth
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        circleShapeLayer.strokeEnd = 0
        animationView.layer.addSublayer(circleShapeLayer)
        
        circleShapeLayer.frame = animationView.bounds
        animationView.layer.zPosition = 5
        
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.beginTime = 0.3
        strokeStart.fromValue = 0
        strokeStart.toValue = 1
        strokeStart.duration = 2
        strokeStart.fillMode = CAMediaTimingFillMode.forwards
        strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
        strokeStart.isRemovedOnCompletion = false
        
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue = 0
        strokeEnd.toValue = 1
        strokeEnd.duration = 2
        strokeEnd.fillMode = CAMediaTimingFillMode.backwards
        strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
        strokeEnd.isRemovedOnCompletion = false
        
        
        let borderEnlarge = CABasicAnimation(keyPath: "lineWidth")
        borderEnlarge.fromValue = 0
        borderEnlarge.duration = 1.5
        borderEnlarge.toValue = 15
        borderEnlarge.fillMode = CAMediaTimingFillMode.forwards
        borderEnlarge.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
        borderEnlarge.isRemovedOnCompletion = false
        //self.circleShapeLayer.add(borderEnlarge, forKey:"animateBorder")
    
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 2
        strokeAnimationGroup.repeatDuration = .infinity
        strokeAnimationGroup.animations = [borderEnlarge, strokeStart, strokeEnd]
        
        circleShapeLayer.add(strokeAnimationGroup, forKey: nil)
        
        self.animationViews.append(animationView)
    }
  
   

}



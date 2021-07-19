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
}



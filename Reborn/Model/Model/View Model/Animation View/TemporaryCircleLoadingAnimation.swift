//
//  WaitingAnimation.swift
//  Reborn
//
//  Created by Christian Liu on 3/5/21.
//

import Foundation
import UIKit
class TemporaryCircleLoadingAnimation {
    
    private static var shared = TemporaryCircleLoadingAnimation()
    private var storedView: UIView? = nil
    private let circleShapeLayer = CAShapeLayer()
    private var timer: Timer? = nil
    private var yProportion: Double = 0.5
    public var animationView = UIView()
    init() {
    }
    
    
    static func add(to view: UIView, withRespondingTime respondingTime: TimeInterval, circleWidth: CGFloat = 5, circleRadius: CGFloat = 50, proportionallyOnYPosition proportion: Double = 0.5, timeOutAlertTitle: String = "操作超时", timeOutAlertBody: String = "请稍后再试") {

        let loadingAnimation = shared
        loadingAnimation.yProportion = proportion
        loadingAnimation.animationView.frame = view.bounds
        //loadingAnimation.animationView.backgroundColor = .black.withAlphaComponent(0.3)
        loadingAnimation.animationView.accessibilityIdentifier = "AnimationView"
        loadingAnimation.fadeInBackground()
        loadingAnimation.addProgressCircleView(circleWidth: circleWidth, circleRadius: circleRadius)
        loadingAnimation.showBorderAndCircle()
        view.addSubview(loadingAnimation.animationView)
        
        loadingAnimation.schedule(withRespondingTime: respondingTime, timeOutAlertTitle: timeOutAlertTitle, timeOutAlertBody: timeOutAlertBody)
        loadingAnimation.storedView = view
        

    }
    
    static func remove(finish: (() -> Void)? = nil) {
        TemporaryCircleLoadingAnimation.shared.timer?.invalidate()
        UIView.animate(withDuration: 0.8, animations: {
            TemporaryCircleLoadingAnimation.shared.animationView.alpha = 0
        }) { _ in
            TemporaryCircleLoadingAnimation.shared.animationView.removeFromSuperview()
            finish?()
        }
        
    }
    
    private func fadeInBackground() {
        self.animationView.backgroundColor = .black.withAlphaComponent(0.5)
        self.animationView.alpha = 0
        UIView.animate(withDuration: 0.8, animations: {
            self.animationView.alpha = 1
        })
    }
    
    private func schedule(withRespondingTime respondingTime: TimeInterval, timeOutAlertTitle: String, timeOutAlertBody: String) {
        var seconds = 0

        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if seconds > Int(respondingTime) {
                if let currentVC = UIApplication.shared.getCurrentViewController() {
                    SystemAlert.present(timeOutAlertTitle, and: timeOutAlertBody, from: currentVC)
                }
                
                TemporaryCircleLoadingAnimation.remove()
                
                seconds = -1000
                
            }
            seconds += 1
        }

    }
    
    
    private func addProgressCircleView(circleWidth: CGFloat, circleRadius: CGFloat) { // Circle progress bar
       
        let progressWidth: CGFloat = circleWidth
        let circleRadius: CGFloat = circleRadius
        let circleViewCenter = CGPoint(x: self.animationView.frame.width / 2 , y: self.animationView.frame.height * CGFloat(self.yProportion))
        
        
        self.renderView(circleRadius: circleRadius, circleViewCenter: circleViewCenter, progressWidth: progressWidth)
    }
    
    private func renderView(circleRadius: CGFloat, circleViewCenter: CGPoint, progressWidth: CGFloat) {

        let progress = 1
        let circleShapePath = UIBezierPath(arcCenter: circleViewCenter, radius: circleRadius, startAngle: -CGFloat.pi / 2, endAngle: CGFloat(progress) * 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        let shapeColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor

        let progressWidth: CGFloat = progressWidth
        
        
        self.circleShapeLayer.path = circleShapePath.cgPath
        self.circleShapeLayer.strokeColor = shapeColor
        self.circleShapeLayer.lineWidth = progressWidth
        self.circleShapeLayer.fillColor = UIColor.clear.cgColor
        self.circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        self.circleShapeLayer.strokeEnd = 0
        self.animationView.layer.addSublayer(circleShapeLayer)
        
        self.circleShapeLayer.frame = self.animationView.bounds
        self.animationView.layer.zPosition = 5
    }
    
    private func showBorderAndCircle() {
        
     
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
        
       
        
//        let fadeAnimation = CAKeyframeAnimation(keyPath:"opacity")
//        fadeAnimation.duration = 0.3
//        fadeAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
//        fadeAnimation.values = [0.0, 0.25, 0.5, 1.0]
//        fadeAnimation.isRemovedOnCompletion = false
//        fadeAnimation.fillMode = CAMediaTimingFillMode.forwards
//        circleTrackLayer.add(fadeAnimation, forKey:"animateOpacity")
        
    }

    
}

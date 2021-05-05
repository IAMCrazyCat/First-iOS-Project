//
//  ViewController.swift
//  Reborn
//
//  Created by Christian Liu on 16/12/20.
//

import UIKit

class WelcomViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appIntrocutionLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    let circleTrackLayer = CAShapeLayer()
    let circleShapeLayer = CAShapeLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutSubviews()
        initializeAppLabels()
        
    }
    
    override func viewDidLayoutSubviews() {
        initializeAnimationView()
        initializeAvatarView()
        initializeStartButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        excuteAnimation()

    }
    
    func initializeAppLabels() {
        appNameLabel.alpha = 0
        appIntrocutionLabel.alpha = 0
    }
    
    func initializeStartButton() {
        startButton.setCornerRadius()
        startButton.setSmartColor()
        startButton.alpha = 0
    }
    
    
    func initializeAnimationView() {
        
        animationView.frame.size = CGSize(width: 200, height: 200)
        animationView.center = topView.center
 
        animationView.layoutIfNeeded()
        
        animationView.setCornerRadius(corderRadius: 40)
        animationView.setShadow()
        animationView.layer.shadowOpacity = 0
    }
    
    func initializeAvatarView() {
        let proportion: CGFloat = 0.8

        avatarImageView.image = #imageLiteral(resourceName: "DefaultAvatarMale")
        avatarImageView.isHidden = true
        avatarImageView.layoutIfNeeded()
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.widthAnchor.constraint(equalTo: animationView.widthAnchor, multiplier: proportion).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: animationView.heightAnchor, multiplier: proportion).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: animationView.centerYAnchor).isActive = true
        avatarImageView.centerXAnchor.constraint(equalTo: animationView.centerXAnchor).isActive = true
    }
    
    func excuteAnimation() {
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.enlargeAvtar()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.addProgressCircleView()
            self.showBorderAndCircle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.fadeOutAvatarAndShrinkAnimationView()
            self.enlargeBorderAndShrinkCircle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.fadeInShadow()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.showOtherComponents()
            
        }
        
        
        
        
        
    }
    
    
    
    func enlargeAvtar() {

        avatarImageView.isHidden = false
        avatarImageView.alpha = 1
        avatarImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseOut], animations: {
            self.avatarImageView.alpha = 1
            self.avatarImageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.avatarImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { _ in

            }
        }
        
        
    }
    
    
    
    
    
    private func addProgressCircleView() { // Circle progress bar
       
        let progressWidth: CGFloat = 15
        let circleRadius: CGFloat = 100
        let circleViewCenter = CGPoint(x: self.animationView.frame.width / 2 , y: self.animationView.frame.height / 2)
        
        self.renderView(circleRadius: circleRadius, circleViewCenter: circleViewCenter, progressWidth: progressWidth)
    }
    
    private func renderView(circleRadius: CGFloat, circleViewCenter: CGPoint, progressWidth: CGFloat) {
        
//        animationView.frame.size = CGSize(width: circleRadius * 2, height: circleRadius * 2)
//        animationView.center = circleViewCenter
        let progress = 0.75
        let circleTrackPath = UIBezierPath(arcCenter: CGPoint(x: animationView.frame.width / 2, y: animationView.frame.height / 2), radius: circleRadius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        let circleShapePath = UIBezierPath(arcCenter: CGPoint(x: animationView.frame.width / 2, y: animationView.frame.height / 2), radius: circleRadius, startAngle: -CGFloat.pi / 2, endAngle: CGFloat(progress) * 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        let shapeColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor
        let trackColor = AppEngine.shared.userSetting.themeColor.uiColor.withAlphaComponent(0.3).cgColor
        let progressWidth: CGFloat = progressWidth
        
        self.circleTrackLayer.path = circleTrackPath.cgPath
        self.circleTrackLayer.strokeColor = trackColor
        self.circleTrackLayer.lineWidth = progressWidth
        self.circleTrackLayer.fillColor = UIColor.clear.cgColor
        self.circleTrackLayer.lineCap = CAShapeLayerLineCap.round
        animationView.layer.addSublayer(circleTrackLayer)
        
        self.circleShapeLayer.path = circleShapePath.cgPath
        self.circleShapeLayer.strokeColor = shapeColor
        self.circleShapeLayer.lineWidth = progressWidth
        self.circleShapeLayer.fillColor = UIColor.clear.cgColor
        self.circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        self.circleShapeLayer.strokeEnd = 0
        animationView.layer.addSublayer(circleShapeLayer)
        
        self.circleTrackLayer.frame = self.animationView.bounds
        self.circleShapeLayer.frame = self.animationView.bounds
    }
    
    
    
    private func showBorderAndCircle() {
        
        let moveCircleProgressBar = CABasicAnimation(keyPath: "strokeEnd")
        moveCircleProgressBar.beginTime = CACurrentMediaTime() + 0.8
        moveCircleProgressBar.toValue = 1
        moveCircleProgressBar.duration = 2
        moveCircleProgressBar.fillMode = CAMediaTimingFillMode.forwards
        moveCircleProgressBar.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
        moveCircleProgressBar.isRemovedOnCompletion = false
        circleShapeLayer.add(moveCircleProgressBar, forKey: "basicAnimation")
        
        self.circleTrackLayer.lineWidth = 0
        
        let borderAnimation = CABasicAnimation(keyPath: "lineWidth")
        
        borderAnimation.duration = 1.5
        borderAnimation.toValue = 15
        borderAnimation.fillMode = CAMediaTimingFillMode.forwards
        borderAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
        borderAnimation.isRemovedOnCompletion = false
        circleTrackLayer.add(borderAnimation, forKey:"animateBorder")
        
//        let fadeAnimation = CAKeyframeAnimation(keyPath:"opacity")
//        fadeAnimation.duration = 0.3
//        fadeAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
//        fadeAnimation.values = [0.0, 0.25, 0.5, 1.0]
//        fadeAnimation.isRemovedOnCompletion = false
//        fadeAnimation.fillMode = CAMediaTimingFillMode.forwards
//        circleTrackLayer.add(fadeAnimation, forKey:"animateOpacity")
        
    }
    
    func fadeOutAvatarAndShrinkAnimationView() {
        
        
        UIView.animate(withDuration: 1, animations: {
            self.avatarImageView.alpha = 0
            self.animationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
        
        UIView.animate(withDuration: 0.8, animations: {
            self.avatarImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.avatarImageView.alpha = 0
        })
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.avatarImageView.alpha = 0
        })
       
    }
    
    func enlargeBorderAndShrinkCircle() {
    
        let layerAnimation = CABasicAnimation(keyPath: "transform.scale")
        layerAnimation.beginTime = CACurrentMediaTime() + 0.3
        layerAnimation.toValue = 0.6
        layerAnimation.duration = 1
        layerAnimation.fillMode = CAMediaTimingFillMode.forwards
        layerAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
        layerAnimation.isRemovedOnCompletion = false

        self.circleTrackLayer.add(layerAnimation, forKey: nil)
        self.circleShapeLayer.add(layerAnimation, forKey: nil)
        
        let borderAnimation = CABasicAnimation(keyPath: "lineWidth")
        borderAnimation.beginTime = CACurrentMediaTime()
        borderAnimation.duration = 1.5
        borderAnimation.fromValue = 15
        borderAnimation.toValue = 20
        borderAnimation.fillMode = CAMediaTimingFillMode.forwards
        borderAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
        borderAnimation.isRemovedOnCompletion = false
        self.circleTrackLayer.add(borderAnimation, forKey:"animateBorder")
        self.circleShapeLayer.add(borderAnimation, forKey:"animateBorder")
    }
    
    
    func fadeInShadow() {

        
        
        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowAnimation.beginTime = CACurrentMediaTime() + 0.3
        shadowAnimation.toValue = 1
        shadowAnimation.duration = 0.5
        shadowAnimation.isRemovedOnCompletion = false
        
        self.animationView.layer.add(shadowAnimation, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animationView.layer.shadowOpacity = 1
        }
        
       
    }

    func showOtherComponents() {
        
        
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.appNameLabel.alpha = 1
        })
        
        UIView.animate(withDuration: 1, delay: 0.15, options: [], animations: {
            self.appIntrocutionLabel.alpha = 1
        })
        
        UIView.animate(withDuration: 1, delay: 1, options: [], animations: {
            self.startButton.alpha = 1
        })
        
    }
    
}


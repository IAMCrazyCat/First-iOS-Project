//
//  NavigationViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 10/2/21.
//

import Foundation
import UIKit
class OverAllProgressViewBuilder: ViewBuilder {
    
    let setting: SystemSetting = SystemSetting.shared
    let welcomeTextData = WelcomeTextData()
    
    let avatarImage: UIImage
    let progress: Double
    let outPutViewFrame: CGRect
    let outPutView: UIView = UIView()
    let circleView = UIView()
    
    let circleTrackLayer = CAShapeLayer()
    let circleShapeLayer = CAShapeLayer()
    
    init(avatarImage: UIImage, progress: Double, frame outPutViewFrame: CGRect) {
        self.avatarImage = avatarImage
        self.progress = progress
        self.outPutViewFrame = outPutViewFrame
        
    }
    
    public func buildView() -> UIView {
        
        
        if outPutViewFrame.height > 100 {
            
           
            createView()
            addTextLabel()
            addBigProgressCircleView()
            addCircleAnimation()
            addProgressLabel()
            
            
        } else {
            
           
            createSmallCircleView()
            addSmallProgressCircleView()
            addCircleAnimation()
            
        }
        
        return outPutView
       
    }
    
    internal func createView() {
        outPutView.accessibilityIdentifier = "OverAllProgressView"
        outPutView.frame = self.outPutViewFrame
        outPutView.backgroundColor = AppEngine.shared.userSetting.themeColorAndBlackContent

        outPutView.layer.cornerRadius = setting.itemCardCornerRadius
        outPutView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        
    }
    
    private func createSmallCircleView() {
        outPutView.accessibilityIdentifier = "OverAllProgressView"
        outPutView.frame = self.outPutViewFrame
        outPutView.backgroundColor = AppEngine.shared.userSetting.themeColorAndBlackContent
        
    }
    
    private func addTextLabel() {
        let firstTextLabel = UILabel()

        firstTextLabel.text = welcomeTextData.randomText(timeRange: TimeRange.current).firstText
        firstTextLabel.font = AppEngine.shared.userSetting.largeFont
        firstTextLabel.textColor = AppEngine.shared.userSetting.smartLabelColorAndWhite
        //firstTextLabel.frame.origin = CGPoint(x: 15, y: 0)
        //firstTextLabel.sizeToFit()
        self.outPutView.addSubview(firstTextLabel)
        
        firstTextLabel.translatesAutoresizingMaskIntoConstraints = false
        firstTextLabel.rightAnchor.constraint(equalTo: outPutView.rightAnchor, constant: -15).isActive = true
        firstTextLabel.leftAnchor.constraint(equalTo: outPutView.leftAnchor, constant: 15).isActive = true
        firstTextLabel.topAnchor.constraint(equalTo: outPutView.topAnchor).isActive = true
        
        self.outPutView.layoutIfNeeded()
        let vipButton = VipIcon.render(by: CGRect(x: firstTextLabel.frame.width + 25, y: firstTextLabel.frame.minY + 5, width: 40, height: 15), scale: 1)
        vipButton.isHidden = true//AppEngine.shared.currentUser.isVip ? false : true
        self.outPutView.addSubview(vipButton)
        
        
        let secondTextLabel = UILabel()
        secondTextLabel.font = AppEngine.shared.userSetting.smallFont
        secondTextLabel.text = welcomeTextData.randomText(timeRange: TimeRange.current).secondText
        secondTextLabel.textColor = AppEngine.shared.userSetting.smartLabelColorAndWhite
        secondTextLabel.lineBreakMode = .byWordWrapping
        secondTextLabel.numberOfLines = 3
        secondTextLabel.sizeToFit()
        
        self.outPutView.addSubview(secondTextLabel)
        secondTextLabel.translatesAutoresizingMaskIntoConstraints = false
        secondTextLabel.topAnchor.constraint(equalTo: firstTextLabel.bottomAnchor, constant: 10).isActive = true
        secondTextLabel.leftAnchor.constraint(equalTo: self.outPutView.leftAnchor, constant: 15).isActive = true
        
        secondTextLabel.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            secondTextLabel.alpha = 1
        })
    }
    
    private func addSmallProgressCircleView() {
        let progressWidth: CGFloat = 5
        let circleRadius: CGFloat = self.outPutView.frame.width / 2 - progressWidth
        let circleViewCenter = CGPoint(x: self.outPutViewFrame.width / 2 , y: self.outPutViewFrame.height / 2)
        
        self.renderView(circleRadius: circleRadius, circleViewCenter: circleViewCenter, progressWidth: progressWidth)
        
    }
    
    private func addBigProgressCircleView() { // Circle progress bar
       
        let progressWidth: CGFloat = 8
        let circleRadius: CGFloat = 60
        let circleViewCenter = CGPoint(x: self.outPutViewFrame.width / 2 , y: self.outPutViewFrame.height / 2 + 20)
        
        self.renderView(circleRadius: circleRadius, circleViewCenter: circleViewCenter, progressWidth: progressWidth)
    }
    
    private func renderView(circleRadius: CGFloat, circleViewCenter: CGPoint, progressWidth: CGFloat) {
        
        circleView.frame.size = CGSize(width: circleRadius * 2, height: circleRadius * 2)
        circleView.center = circleViewCenter
        
        let circleTrackPath = UIBezierPath(arcCenter: CGPoint(x: circleView.frame.width / 2, y: circleView.frame.height / 2), radius: circleRadius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        let circleShapePath = UIBezierPath(arcCenter: CGPoint(x: circleView.frame.width / 2, y: circleView.frame.height / 2), radius: circleRadius, startAngle: -CGFloat.pi / 2, endAngle: CGFloat(progress) * 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        let shapeColor = AppEngine.shared.userSetting.themeColorDarkAndThemeColor.cgColor
        let trackColor = AppEngine.shared.userSetting.brightAndDarkThemeColor.cgColor
        let progressWidth: CGFloat = progressWidth
        
        self.circleTrackLayer.path = circleTrackPath.cgPath
        self.circleTrackLayer.strokeColor = trackColor
        self.circleTrackLayer.lineWidth = progressWidth
        self.circleTrackLayer.fillColor = UIColor.clear.cgColor
        self.circleTrackLayer.lineCap = CAShapeLayerLineCap.round
        circleView.layer.addSublayer(circleTrackLayer)
        
        self.circleShapeLayer.path = circleShapePath.cgPath
        self.circleShapeLayer.strokeColor = shapeColor
        self.circleShapeLayer.lineWidth = progressWidth
        self.circleShapeLayer.fillColor = UIColor.clear.cgColor
        self.circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        self.circleShapeLayer.strokeEnd = 0
        circleView.layer.addSublayer(circleShapeLayer)

        
        let imageView = UIImageView() // Avatar
        imageView.frame.size = CGSize(width: (circleRadius * 2 - progressWidth) * 0.85, height: (circleRadius * 2 - progressWidth ) * 0.85)
        imageView.center = CGPoint(x: circleView.frame.width / 2, y: circleView.frame.height / 2)
        imageView.image = self.avatarImage
        imageView.contentMode = .scaleAspectFill
        imageView.setCornerRadius()
         
        circleView.accessibilityIdentifier = "ProgressCircleView"
        circleView.addSubview(imageView)
        outPutView.addSubview(circleView)
    }
    
    
    
    private func addCircleAnimation() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
        basicAnimation.isRemovedOnCompletion = false
        circleShapeLayer.add(basicAnimation, forKey: "basicAnimation")
     
        
    }
    
    private func addProgressLabel() {
        let progressLabel = UILabel()
        progressLabel.text = "已重启: \(String(format: "%.1f", progress * 100))%"
        progressLabel.font = AppEngine.shared.userSetting.smallFont
        progressLabel.textColor = AppEngine.shared.userSetting.smartLabelColorAndWhite
        progressLabel.sizeToFit()
        progressLabel.center = CGPoint(x: self.circleView.center.x, y: self.circleView.center.y + 90)
        
        self.outPutView.addSubview(progressLabel)
    }
}

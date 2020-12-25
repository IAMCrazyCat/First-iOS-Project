//
//  AppViewController.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var overallProgressView: UIView!
    @IBOutlet weak var quittingItemView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var overallProgressLabel: UILabel!
    @IBOutlet weak var itemCardView: UIView!
    @IBOutlet weak var itemsTitleLabel: UILabel!
    
    var setting = SystemStyleSetting()
    let cardBGImage = SystemStyleSetting.itemCardBGImage
    var overallProgress = 0.9
    
    let circleTrackLayer = CAShapeLayer()
    let circleShapeLayer = CAShapeLayer()
    
    let shapeColor = UserStyleSetting.themeColor?.cgColor
    let trackColor = UserStyleSetting.themeColor?.withAlphaComponent(0.3).cgColor
    let progressWidth: CGFloat = 8
    
    let engine = AppEngine()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checkButton.layer.cornerRadius = setting.checkButtonCornerRadius
        mainScrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        overallProgressView.layer.contents = cardBGImage.cgImage
        quittingItemView.layer.contents = cardBGImage.cgImage
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        
   
        overallProgressView.layoutIfNeeded()
        addProgressCircle()
        excuteCircleAnimation()
        //excuteProgressLabelAnimation()
        updateUI()
        
        
    }
    
    func addProgressCircle() { // Circle progress bar
       
        
        let center = CGPoint(x: overallProgressView.frame.width / 2 , y: overallProgressView.frame.height / 2)
        print(overallProgressView.frame.width)
        let circleTrackPath = UIBezierPath(arcCenter: center, radius: 60, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)

        

        circleTrackLayer.path = circleTrackPath.cgPath
        circleTrackLayer.strokeColor = trackColor
        circleTrackLayer.lineWidth = progressWidth
        circleTrackLayer.fillColor = UIColor.clear.cgColor
        circleTrackLayer.lineCap = CAShapeLayerLineCap.round
        overallProgressView.layer.addSublayer(circleTrackLayer)
   

        let circleShapePath = UIBezierPath(arcCenter: center, radius: 60, startAngle: -CGFloat.pi / 2, endAngle: CGFloat(overallProgress) * 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        
        circleShapeLayer.path = circleShapePath.cgPath
        circleShapeLayer.strokeColor = shapeColor
        circleShapeLayer.lineWidth = progressWidth
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        circleShapeLayer.strokeEnd = 0
        overallProgressView.layer.addSublayer(circleShapeLayer)
        
       
    }
    
    func excuteCircleAnimation() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
        basicAnimation.isRemovedOnCompletion = false
        circleShapeLayer.add(basicAnimation, forKey: "basicAnimation")
     
        
    }
    
    @objc func excuteProgressLabelAnimation() {
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(excuteProgressLabelAnimation), userInfo: nil, repeats: true)
        let currentTransitionValue = (circleShapeLayer.presentation()?.value(forKeyPath: "strokeEnd") ?? 0.0) as! Double
        
        overallProgressLabel.text = "已完成: " + String(format: "%.1f", currentTransitionValue * overallProgress * 100) + "%"
        if currentTransitionValue == 1 {
            timer.invalidate()
        }
    }
    
    
    func updateUI() {
      
        let quittingItemArray = engine.getItemArray()
        var cordinateY: CGFloat = 0.0
        for item in quittingItemArray {
            
            let newItemCardView = UIView()
            newItemCardView.layer.contents = cardBGImage.cgImage
            newItemCardView.frame = CGRect(x: self.itemsTitleLabel.frame.origin.x, y: self.itemsTitleLabel.frame.origin.y + self.itemsTitleLabel.frame.height + 10 + cordinateY, width: self.view.frame.width - 16, height: setting.itemCardHeight)

            //------------------------------------------------------------------------
            let nameLabel = UILabel()
            
            nameLabel.text = item.name
            nameLabel.textColor = UIColor.black
            //nameLabel.frame = CGRect(x: 20, y: 20, width: 50, height: 20)
            nameLabel.font = UserStyleSetting.fontSmall
            
            newItemCardView.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
            nameLabel.topAnchor.constraint(equalTo: newItemCardView.topAnchor, constant: 20).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: newItemCardView.leftAnchor, constant: 20).isActive = true
            
            //------------------------------------------------------------------------
            let typeLabel = UILabel()
            if let _ = item as? QuittingItem {
                typeLabel.text = "已戒除"
            } else {
                typeLabel.text = "已坚持"
            }
            
            typeLabel.textColor = UIColor.black
            typeLabel.font = UserStyleSetting.fontSmall
            typeLabel.sizeToFit()
            
            newItemCardView.addSubview(typeLabel)
            typeLabel.translatesAutoresizingMaskIntoConstraints = false
            typeLabel.centerYAnchor.constraint(equalTo: newItemCardView.centerYAnchor).isActive = true
            typeLabel.leftAnchor.constraint(equalTo: newItemCardView.leftAnchor, constant: setting.centerObjectsOffset).isActive = true
            
            //------------------------------------------------------------------------
            
            let finishedDaysLabel = UILabel()
            
            let attrs1 = [NSAttributedString.Key.font: UserStyleSetting.fontLarge]
            let attrs2 = [NSAttributedString.Key.font: UserStyleSetting.fontSmall, NSAttributedString.Key.foregroundColor: UIColor.gray]
            let finishedDaysString = NSMutableAttributedString(string: "\(item.finishedDays)", attributes: attrs1)
            let unit = NSMutableAttributedString(string: "  天", attributes: attrs2)
            
            finishedDaysString.append(unit)
            finishedDaysLabel.attributedText = finishedDaysString
            finishedDaysLabel.sizeToFit()
            
            newItemCardView.addSubview(finishedDaysLabel)
            finishedDaysLabel.translatesAutoresizingMaskIntoConstraints = false
            finishedDaysLabel.centerYAnchor.constraint(equalTo: newItemCardView.centerYAnchor, constant: -3).isActive = true
            finishedDaysLabel.centerXAnchor.constraint(equalTo: newItemCardView.centerXAnchor).isActive = true
            
            
            //------------------------------------------------------------------------
            
            let barTrackPath = UIBezierPath(roundedRect: CGRect(x: 20, y: newItemCardView.frame.height - 30, width: newItemCardView.frame.width - setting.progressBarLengthOffset, height: 10), cornerRadius: 10)
            let barTrackLayer = CAShapeLayer()
            barTrackLayer.path = barTrackPath.cgPath
            barTrackLayer.lineWidth = self.progressWidth
            barTrackLayer.fillColor = self.trackColor
            barTrackLayer.lineCap = CAShapeLayerLineCap.round
            barTrackLayer.strokeEnd = 0
            newItemCardView.layer.addSublayer(barTrackLayer)
            
            let barShapePath = UIBezierPath(roundedRect: CGRect(x: 20, y: newItemCardView.frame.height - 30, width: CGFloat(item.finishedDays / item.days) * (newItemCardView.frame.width - setting.progressBarLengthOffset), height: 10), cornerRadius: 10)
            let barShapeLayer = CAShapeLayer()
            barShapeLayer.path = barShapePath.cgPath
            barShapeLayer.lineWidth = self.progressWidth
            barShapeLayer.fillColor = self.shapeColor
            barShapeLayer.lineCap = CAShapeLayerLineCap.round
            barShapeLayer.strokeEnd = 0
            newItemCardView.layer.addSublayer(barShapeLayer)
           
            //------------------------------------------------------------------------
            
            let daysLabel = UILabel()
            
            let atr1 = [NSAttributedString.Key.font: UserStyleSetting.fontSmall]
            let atr2 = [NSAttributedString.Key.font: UserStyleSetting.fontSmall, NSAttributedString.Key.foregroundColor: UIColor.black]
            let daysString = NSMutableAttributedString(string: "\(item.days)", attributes: atr1)
            let daysUnit = NSMutableAttributedString(string: "天", attributes: atr2)
            
            daysString.append(daysUnit)
            daysLabel.attributedText = daysString
            daysLabel.sizeToFit()
            
            newItemCardView.addSubview(daysLabel)
            daysLabel.translatesAutoresizingMaskIntoConstraints = false
            daysLabel.rightAnchor.constraint(equalTo: newItemCardView.rightAnchor, constant: -20).isActive = true
            daysLabel.bottomAnchor.constraint(equalTo: newItemCardView.bottomAnchor, constant: -18).isActive = true
            
            
            //------------------------------------------------------------------------
            
            let punchInButton = UIButton()
            punchInButton.setTitle("打卡", for: .normal)
            punchInButton.titleLabel!.font = UserStyleSetting.fontSmall
            punchInButton.backgroundColor = UserStyleSetting.themeColor
            punchInButton.layer.cornerRadius = setting.checkButtonCornerRadius
            
            newItemCardView.addSubview(punchInButton)
            punchInButton.translatesAutoresizingMaskIntoConstraints = false
            punchInButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            punchInButton.rightAnchor.constraint(equalTo: newItemCardView.rightAnchor, constant: -setting.centerObjectsOffset).isActive = true
            punchInButton.centerYAnchor.constraint(equalTo: newItemCardView.centerYAnchor).isActive = true
            
            //------------------------------------------------------------------------
            self.contentView.addSubview(newItemCardView)
            cordinateY += newItemCardView.frame.height + 10
            
        }
        
       
    }
    

}

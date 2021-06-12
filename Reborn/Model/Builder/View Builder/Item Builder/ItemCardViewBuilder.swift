//
//  ItemBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 26/12/20.
//
import Foundation
import UIKit

class ItemCardViewBuilder: ViewBuilder {

    let item: Item
    let punchInButtonTag: Int
    var cordinateX: CGFloat
    var cordinateY: CGFloat
    var width: CGFloat
    var height: CGFloat
    let setting: SystemSetting = SystemSetting.shared
    let outPutView: UIView = UIView()
    var isInteractable: Bool
    init(item: Item, frame: CGRect, punchInButtonTag: Int = 11607, isInteractable: Bool){ // for home page

        self.item = item
        self.width = frame.width
        self.height = frame.height
        self.cordinateX = frame.origin.x
        self.cordinateY = frame.origin.y
        self.punchInButtonTag = punchInButtonTag
        self.isInteractable = isInteractable
    }

    public func buildView() -> UIView {
      
        createView()
        addIconAndNameLabel()
        addGoDetailsButton()
        addTypeLabel()
        addFinishedDaysLabel(labelFrame: nil, withTypeLabel: false)
        addProgressBar(barFrame: CGRect(x: self.setting.mainDistance, y: outPutView.frame.height - 30, width: outPutView.frame.width - self.setting.progressBarLengthToRightEdgeOffset, height: 10), withProgressLabel: false)
        addTargetDaysLabel(labelFrame: nil, withTypeLabel: false)
        addPunInButton()
        addItemCardFreqencyLabel()
        
        
        
        return outPutView
    
    }
    
  
    
    internal func createView() {
        
        
        outPutView.accessibilityIdentifier = setting.itemCardIdentifier
        outPutView.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackContent
        outPutView.layer.cornerRadius = setting.itemCardCornerRadius
        outPutView.setShadow()
        outPutView.frame = CGRect(x: cordinateX, y: cordinateY, width: width, height: height)
        item.hasSanction ? lockItemCard() : ()
        item.finishedDays == item.targetDays ? addConfettiTopView() : ()

    }
    
    
    
    private func addIconAndNameLabel() {
        
        
        let icon = UIImageView()
        icon.image = self.item.icon.image
        icon.contentMode = .scaleAspectFill

        outPutView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.leftAnchor.constraint(equalTo: outPutView.leftAnchor, constant: self.setting.mainDistance).isActive = true
        icon.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: self.setting.mainPadding).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
       
        if self.item.type == .quitting {
        
            let forbiddenIcon = UIImageView()
            outPutView.layoutIfNeeded()
            forbiddenIcon.image = Icon.forbidden.image
            forbiddenIcon.frame = icon.frame
            forbiddenIcon.alpha = 0.5
            //icon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            outPutView.addSubview(forbiddenIcon)
           
//            forbiddenIcon.translatesAutoresizingMaskIntoConstraints = false
//            forbiddenIcon.centerXAnchor.constraint(equalTo: icon.centerXAnchor).isActive = true
//            forbiddenIcon.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
//            forbiddenIcon.heightAnchor.constraint(equalToConstant: icon.frame.height + 5).isActive = true
//            forbiddenIcon.widthAnchor.constraint(equalToConstant: icon.frame.width + 5).isActive = true
            
        }
        
        let nameLabel = UILabel()
        nameLabel.accessibilityIdentifier = "NameLabel"
        nameLabel.text = item.type.rawValue + item.name

        nameLabel.textColor = .label
        nameLabel.font = AppEngine.shared.userSetting.smallFont
        
        outPutView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: outPutView.frame.width - 240).isActive = true
       
    }
    
    private func addItemCardFreqencyLabel() {
        let freqencyLabel = UILabel()
        freqencyLabel.accessibilityIdentifier = "FreqencyLabel"
        
        if let newFreqency = item.newFrequency{
            freqencyLabel.text = newFreqency.getFreqencyString()
        } else {
            freqencyLabel.text = "(请更新频率)"
        }
        
        
        freqencyLabel.textColor = AppEngine.shared.userSetting.properThemeColor
        freqencyLabel.font = AppEngine.shared.userSetting.smallFont
        freqencyLabel.sizeToFit()
        
        outPutView.addSubview(freqencyLabel)
        
        if let nameLabel = outPutView.getSubviewBy(idenifier: "NameLabel") {
            freqencyLabel.translatesAutoresizingMaskIntoConstraints = false
            freqencyLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
            freqencyLabel.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: self.setting.mainDistance).isActive = true
            freqencyLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 10).isActive = true
        }
        
        let stateLabel = UILabel()
        stateLabel.accessibilityIdentifier = "StateLabel"
        stateLabel.text = item.state == .duringBreak ? "（休息中）" : item.state == .completed ? "（已完成）" : ""
        stateLabel.textColor = AppEngine.shared.userSetting.properThemeColor
        stateLabel.font = AppEngine.shared.userSetting.smallFont
        stateLabel.sizeToFit()
        
        outPutView.addSubview(stateLabel)
        
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.leftAnchor.constraint(equalTo: freqencyLabel.rightAnchor, constant: 0).isActive = true
        stateLabel.centerYAnchor.constraint(equalTo: freqencyLabel.centerYAnchor).isActive = true
        stateLabel.heightAnchor.constraint(equalTo: freqencyLabel.heightAnchor).isActive = true

    }
    
   
    
    
    private func addGoDetailsButton() {
        
        
        let goDetailsButton = UIButton()
        goDetailsButton.accessibilityIdentifier = "GoDetailsButton"
        goDetailsButton.setBackgroundImage(UIImage(named: "DetailsButton"), for: .normal)
        goDetailsButton.setTitleColor(.black, for: .normal)
        goDetailsButton.titleLabel!.font = AppEngine.shared.userSetting.smallFont
        goDetailsButton.tintColor = AppEngine.shared.userSetting.themeColor.uiColor.darkColor
        outPutView.addSubview(goDetailsButton)
        
        goDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        goDetailsButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        goDetailsButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        goDetailsButton.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: 20).isActive = true
        goDetailsButton.rightAnchor.constraint(equalTo: outPutView.rightAnchor, constant: -20).isActive = true
        
        let fullViewButton = UIButton()
        fullViewButton.frame = CGRect(x: 0, y: 0, width: self.outPutView.frame.width, height: self.outPutView.frame.height)
        fullViewButton.layer.zPosition = 2
        fullViewButton.tag = self.punchInButtonTag
        
        if isInteractable {
            fullViewButton.addTarget(Actions.shared, action: Actions.detailsViewAction, for: .touchUpInside)
        }
        
        outPutView.addSubview(fullViewButton)
    }
    
    private func addTypeLabel() {
        let typeLabel = UILabel()
        typeLabel.accessibilityIdentifier = "TypeLabel"
        
        typeLabel.text = "已打卡"
        typeLabel.textColor = .label
        typeLabel.font = AppEngine.shared.userSetting.smallFont
        typeLabel.sizeToFit()
        
        outPutView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.centerYAnchor.constraint(equalTo: outPutView.centerYAnchor).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: outPutView.leftAnchor, constant: self.setting.itemCardCenterObjectsToEdgeOffset).isActive = true
    }
    
    
    private func addFinishedDaysLabel(labelFrame: CGRect?, withTypeLabel: Bool) {
        
        let finishedDaysLabel = UILabel()
        let attrs1 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.largeFont]
        let attrs2 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.smallFont, NSAttributedString.Key.foregroundColor: UIColor.gray]
        finishedDaysLabel.accessibilityIdentifier = "FinishedDaysLabel"
        finishedDaysLabel.sizeToFit()
        
        let finishedDaysString = NSMutableAttributedString(string: "\(self.item.finishedDays)", attributes: attrs1)
        let unit = NSMutableAttributedString(string: "  天", attributes: attrs2)
        
        if withTypeLabel {
            if labelFrame != nil {
                
                finishedDaysLabel.frame.origin = labelFrame!.origin
                let attrs0 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.smallFont, NSAttributedString.Key.foregroundColor: UIColor.gray]
                let typeString = NSMutableAttributedString(string: "已打卡:  ", attributes: attrs0)
                
                finishedDaysString.append(unit)
                typeString.append(finishedDaysString)
                
                finishedDaysLabel.attributedText = typeString
                finishedDaysLabel.sizeToFit()
                outPutView.addSubview(finishedDaysLabel)
            }
    
        } else {
        
            finishedDaysString.append(unit)
            finishedDaysLabel.attributedText = finishedDaysString

            outPutView.addSubview(finishedDaysLabel)
            finishedDaysLabel.translatesAutoresizingMaskIntoConstraints = false
            finishedDaysLabel.centerYAnchor.constraint(equalTo: outPutView.centerYAnchor, constant: -3).isActive = true
            finishedDaysLabel.centerXAnchor.constraint(equalTo: outPutView.centerXAnchor).isActive = true
        }
        
      
    }
    
    
    private  func addProgressBar(barFrame: CGRect, withProgressLabel: Bool) {
        let barTrackPath = UIBezierPath(roundedRect: barFrame, cornerRadius: 10)
        let barTrackLayer = CAShapeLayer()
        
        let shapeColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor
        let trackColor = AppEngine.shared.userSetting.themeColor.uiColor.withAlphaComponent(0.3).cgColor
        let progressWidth: CGFloat = 10

        barTrackLayer.name = "ProgressTrack"
        barTrackLayer.path = barTrackPath.cgPath
        barTrackLayer.lineWidth = progressWidth
        barTrackLayer.fillColor = trackColor
        barTrackLayer.lineCap = CAShapeLayerLineCap.round
        barTrackLayer.strokeEnd = 0
        outPutView.layer.addSublayer(barTrackLayer)
        
        var barShapeWitdh: CGFloat {
            let width = CGFloat(self.item.progress) * barFrame.width
            if width > barFrame.width {
                return barFrame.width
            } else {
                return width
            }
        }
        
        let barShapePath = UIBezierPath(roundedRect: CGRect(x: barFrame.origin.x, y: barFrame.origin.y, width: barShapeWitdh, height: barFrame.height), cornerRadius: 10)
        let barShapeLayer = CAShapeLayer()
        barShapeLayer.name = "ProgressBar"
        barShapeLayer.path = barShapePath.cgPath
        barShapeLayer.lineWidth = progressWidth
        barShapeLayer.fillColor = shapeColor
        barShapeLayer.lineCap = CAShapeLayerLineCap.round
        barShapeLayer.strokeEnd = 0
        outPutView.layer.addSublayer(barShapeLayer)
        
        if withProgressLabel {
            let progressLabel = UILabel()
            progressLabel.frame.origin = CGPoint(x: CGFloat(self.item.progress) * barFrame.width - 10, y: barFrame.origin.y - barFrame.height - 10)
            progressLabel.font = AppEngine.shared.userSetting.smallFont
            progressLabel.text = self.item.progressInPercentageString
            progressLabel.sizeToFit()
            outPutView.addSubview(progressLabel)
        }
    }
    
    private func addTargetDaysLabel(labelFrame: CGRect?, withTypeLabel: Bool) {
        if withTypeLabel {
            
            if labelFrame != nil {
                let daysLabel = UILabel()
                daysLabel.accessibilityIdentifier = "DaysLabel"
                daysLabel.frame.origin = labelFrame!.origin
                
                let atr0 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.smallFont]
                let atr1 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.largeFont]
                let atr2 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.smallFont, NSAttributedString.Key.foregroundColor: UIColor.label]
                
                let typeString = NSMutableAttributedString(string: "目标:  ", attributes: atr0)
                let daysString = NSMutableAttributedString(string: "\(self.item.targetDays)", attributes: atr1)
                let daysUnit = NSMutableAttributedString(string: " 天", attributes: atr2)
                
                daysString.append(daysUnit)
                typeString.append(daysString)
                
                daysLabel.attributedText = typeString
                daysLabel.sizeToFit()
                
                outPutView.addSubview(daysLabel)
    
            }
           
            
        } else {
            
            let daysLabel = UILabel()
            daysLabel.accessibilityIdentifier = "DaysLabel"
            
            let atr1 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.smallFont]
            let atr2 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.smallFont, NSAttributedString.Key.foregroundColor: UIColor.label]
            let daysString = NSMutableAttributedString(string: "\(self.item.targetDays)", attributes: atr1)
            let daysUnit = NSMutableAttributedString(string: "天", attributes: atr2)
            
            daysString.append(daysUnit)
            daysLabel.attributedText = daysString
            daysLabel.sizeToFit()
            
            outPutView.addSubview(daysLabel)
            daysLabel.translatesAutoresizingMaskIntoConstraints = false
            daysLabel.rightAnchor.constraint(equalTo: outPutView.rightAnchor, constant: -20).isActive = true
            daysLabel.bottomAnchor.constraint(equalTo: outPutView.bottomAnchor, constant: -18).isActive = true
        }
      
    }
    
    private func addPunInButton() {
        let punchInButton = UIButton()
        punchInButton.accessibilityIdentifier = "PunchInButton"
        punchInButton.accessibilityValue = "\(self.item.ID)"
        punchInButton.setTitle("打卡", for: .normal)
        punchInButton.setTitle("撤销", for: .selected)
        punchInButton.setTitleColor(AppEngine.shared.userSetting.themeColor.uiColor.darkColor, for: .normal)
        punchInButton.setTitleColor(AppEngine.shared.userSetting.smartLabelColor, for: .selected)
       
        punchInButton.titleLabel!.font = AppEngine.shared.userSetting.smallFont
        punchInButton.layer.cornerRadius = self.setting.checkButtonCornerRadius
        punchInButton.layer.zPosition = 3
        punchInButton.setBackgroundColor(.clear, for: .normal)
        punchInButton.setBackgroundColor(AppEngine.shared.userSetting.themeColor.uiColor, for: .selected)
    
        punchInButton.isSelected = self.item.isPunchedIn ? true : false
        
        if punchInButton.isSelected {
            punchInButton.layer.borderWidth = 0
            
        } else {
            punchInButton.layer.borderWidth = 1
            punchInButton.layer.borderColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor
            
        }
        
        outPutView.addSubview(punchInButton)
        punchInButton.translatesAutoresizingMaskIntoConstraints = false
        punchInButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        punchInButton.rightAnchor.constraint(equalTo: outPutView.rightAnchor, constant: -self.setting.itemCardCenterObjectsToEdgeOffset).isActive = true
        punchInButton.centerYAnchor.constraint(equalTo: outPutView.centerYAnchor).isActive = true
        punchInButton.tag = self.punchInButtonTag
        
        if isInteractable {
            punchInButton.addTarget(Actions.shared, action: Actions.punchInAction, for: .touchUpInside)
        }
        
        if let lastPunchIndate = self.item.punchInDates.last {
            
            if self.item.state == .completed && lastPunchIndate != CustomDate.current {
                punchInButton.isSelected = true
                punchInButton.setTitle("完成", for: .selected)
                punchInButton.isUserInteractionEnabled = false
            }
        }
        
        
    }
    
    private func addConfettiTopView() {
        
        let confettiTopView = UIView()
        confettiTopView.accessibilityIdentifier = "TopConfettiView"
        confettiTopView.frame = CGRect(x: 0, y: 0, width: outPutView.frame.width, height: 40)
        confettiTopView.layer.cornerRadius = outPutView.layer.cornerRadius
        confettiTopView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        confettiTopView.layer.masksToBounds = true
        confettiTopView.addConfettiView()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = confettiTopView.bounds
        gradientLayer.colors = [AppEngine.shared.userSetting.whiteAndBlackContent.withAlphaComponent(0).cgColor, AppEngine.shared.userSetting.whiteAndBlackContent.withAlphaComponent(1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        confettiTopView.layer.addSublayer(gradientLayer)
        outPutView.addSubview(confettiTopView)
    }
    
    private func lockItemCard() {
        
        outPutView.isUserInteractionEnabled = false
        outPutView.alpha = 0.4

//        let lockView = UIView()
//        lockView.frame = outPutView.bounds
//        lockView.layer.cornerRadius = outPutView.layer.cornerRadius
//        outPutView.addSubview(lockView)
//
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = lockView.bounds
//        blurView.layer.cornerRadius = lockView.layer.cornerRadius
//        lockView.addSubview(blurView)
//
//
//
//        lockView.addSubview(blurView)
//
//        let lockImageView = UIImageView()
//        lockImageView.image = #imageLiteral(resourceName: "Lock")
//        lockView.addSubview(lockImageView)
//
//
//        lockImageView.translatesAutoresizingMaskIntoConstraints = false
//        lockImageView.centerYAnchor.constraint(equalTo: lockView.centerYAnchor).isActive = true
//        lockImageView.centerXAnchor.constraint(equalTo: lockView.centerXAnchor).isActive = true
//        lockImageView.topAnchor.constraint(equalTo: lockView.topAnchor, constant: 20).isActive = true
//        lockImageView.bottomAnchor.constraint(equalTo: lockView.bottomAnchor, constant: -20).isActive = true
//        lockImageView.widthAnchor.constraint(equalTo: lockImageView.heightAnchor).isActive = true
    }
    
    
  
}

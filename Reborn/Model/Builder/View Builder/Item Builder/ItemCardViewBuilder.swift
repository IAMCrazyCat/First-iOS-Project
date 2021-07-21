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
    var cordinateX: CGFloat
    var cordinateY: CGFloat
    var width: CGFloat
    var height: CGFloat
    let setting: SystemSetting = SystemSetting.shared
    let itemCardView: ItemCardView
    var isInteractable: Bool
    let contentView: UIView = UIView()
    
    let icon = UIImageView()
    let titleLabel = UILabel()
    let frequencyLabel = UILabel()
    let stateLabel = UILabel()
    let notificationIcon = UIImageView()
    let rightButton = UIButton()
    let fullViewButton = UIButton()
    let typeLabel = UILabel()
    let finishedDaysLabel = UILabel()
    let punchInButton = UIButton()
    let confettiTopView = UIView()
    
    init(item: Item, frame: CGRect, isInteractable: Bool){ // for home page

        self.item = item
        self.width = frame.width
        self.height = frame.height
        self.cordinateX = frame.origin.x
        self.cordinateY = frame.origin.y
        self.isInteractable = isInteractable
        self.itemCardView = ItemCardView(frame: frame, item: item, contentView: contentView)
    }

    public func buildView() -> UIView {
      
        createView()
        addIcon()
        addTitileLabel()
        addRightButton()
        addFullViewButton()
        addTypeLabel()
        addFinishedDaysLabel(labelFrame: nil, withTypeLabel: false)
        addProgressBar(barFrame: CGRect(x: self.setting.mainDistance, y: itemCardView.frame.height - 30, width: itemCardView.frame.width - self.setting.progressBarLengthToRightEdgeOffset, height: 10), withProgressLabel: false)
        addTargetDaysLabel(labelFrame: nil, withTypeLabel: false)
        addPunInButton()
        addItemCardFreqencyLabel()
        addStateLabel()
        if self.item.notificationTimes.count > 0 {
            addNotificationIcon()
        }
        return itemCardView
    
    }
    
    public func buildContentView() -> UIView {
        createView()
        addIcon()
        addTitileLabel()
        addRightButton()
        addFullViewButton()
        addTypeLabel()
        addFinishedDaysLabel(labelFrame: nil, withTypeLabel: false)
        addProgressBar(barFrame: CGRect(x: self.setting.mainDistance, y: itemCardView.frame.height - 30, width: itemCardView.frame.width - self.setting.progressBarLengthToRightEdgeOffset, height: 10), withProgressLabel: false)
        addTargetDaysLabel(labelFrame: nil, withTypeLabel: false)
        addPunInButton()
        addItemCardFreqencyLabel()
        addStateLabel()
        if self.item.notificationTimes.count > 0 {
            addNotificationIcon()
        }
        return contentView
    }
  
    
    internal func createView() {
        
        itemCardView.accessibilityIdentifier = "ItemCardView"
        itemCardView.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackContent
        itemCardView.layer.cornerRadius = setting.itemCardCornerRadius
        itemCardView.setShadow(style: .view)
        
        contentView.frame = itemCardView.bounds
        contentView.backgroundColor = .clear
        itemCardView.contentView = contentView
        itemCardView.addSubview(contentView)
        
        item.hasSanction ? lockItemCard() : ()
        item.getFinishedDays() == item.targetDays ? addConfettiTopView() : ()

    }
    
    
  
    
    private func addIcon() {
        
        
        icon.image = self.item.icon.image
        icon.contentMode = .scaleAspectFill

        contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: self.setting.mainDistance).isActive = true
        icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: self.setting.mainPadding).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
       
        if self.item.type == .quitting {
        
            let forbiddenIcon = UIImageView()
            contentView.layoutIfNeeded()
            forbiddenIcon.image = Icon.forbidden.image
            forbiddenIcon.frame = icon.frame
            forbiddenIcon.alpha = 0.5
            contentView.addSubview(forbiddenIcon)
            
        }
        
    }
    
    
    
    private func addTitileLabel() {
        
        titleLabel.accessibilityIdentifier = "TitleLabel"
        titleLabel.text = item.getFullName()
        titleLabel.textColor = .label
        titleLabel.font = AppEngine.shared.userSetting.smallFont
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: self.icon.rightAnchor, constant: 10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.icon.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: self.contentView.frame.width - 240).isActive = true
       

    }
    
    private func addItemCardFreqencyLabel() {
        
        frequencyLabel.accessibilityIdentifier = "FreqencyLabel"
        frequencyLabel.text = item.newFrequency.getFreqencyString()
        frequencyLabel.textColor = AppEngine.shared.userSetting.properThemeColor
        frequencyLabel.font = AppEngine.shared.userSetting.smallFont
        frequencyLabel.sizeToFit()
        
        contentView.addSubview(frequencyLabel)
        
        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        frequencyLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        frequencyLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: self.setting.mainDistance).isActive = true
        frequencyLabel.leftAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 10).isActive = true
    }
    
    private func addStateLabel() {
       
        stateLabel.accessibilityIdentifier = "StateLabel"
        stateLabel.text = item.state == .duringBreak ? "(休息中)" : item.state == .completed ? "(已完成)" : ""
        stateLabel.textColor = AppEngine.shared.userSetting.properThemeColor
        stateLabel.font = AppEngine.shared.userSetting.smallFont
        stateLabel.sizeToFit()
        
        contentView.addSubview(stateLabel)
        
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.leftAnchor.constraint(equalTo: self.frequencyLabel.rightAnchor, constant: 5).isActive = true
        stateLabel.centerYAnchor.constraint(equalTo: self.frequencyLabel.centerYAnchor).isActive = true
        stateLabel.heightAnchor.constraint(equalTo: self.frequencyLabel.heightAnchor).isActive = true
        
    }
    
    private func addNotificationIcon() {
        
        
        notificationIcon.accessibilityIdentifier = "NotificationIcon"
        notificationIcon.image = UIImage(named: "Notification6-Templete") ?? UIImage()
        notificationIcon.tintColor = AppEngine.shared.userSetting.themeColor.uiColor
        contentView.addSubview(notificationIcon)
        
        notificationIcon.translatesAutoresizingMaskIntoConstraints = false
        notificationIcon.topAnchor.constraint(equalTo: self.stateLabel.topAnchor).isActive = true
        notificationIcon.bottomAnchor.constraint(equalTo: self.stateLabel.bottomAnchor).isActive = true
        notificationIcon.leftAnchor.constraint(equalTo: self.stateLabel.rightAnchor, constant: 5).isActive = true
        notificationIcon.widthAnchor.constraint(equalTo: self.stateLabel.heightAnchor).isActive = true
    }
    
    private func addRightButton() {
        
       
        rightButton.accessibilityIdentifier = "RightButton"
        rightButton.setBackgroundImage(UIImage(named: "DetailsButton"), for: .normal)
        rightButton.setTitleColor(.black, for: .normal)
        rightButton.titleLabel!.font = AppEngine.shared.userSetting.smallFont
        rightButton.tintColor = AppEngine.shared.userSetting.themeColor.uiColor.darkColor
        contentView.addSubview(rightButton)
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        rightButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        rightButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        
    }
    
  
    
    private func addFullViewButton() {
       
        fullViewButton.frame = CGRect(x: 0, y: 0, width: self.itemCardView.frame.width, height: self.itemCardView.frame.height)
        fullViewButton.layer.zPosition = 2
        
        if isInteractable {
            fullViewButton.addTarget(self.itemCardView, action: #selector(self.itemCardView.itemDetailsButtonPressed(_:)), for: .touchUpInside)
        }
        
        contentView.addSubview(fullViewButton)
    }
    
   
    private func addTypeLabel() {
        
        typeLabel.accessibilityIdentifier = "TypeLabel"
        
        typeLabel.text = "已打卡"
        typeLabel.textColor = .label
        typeLabel.font = AppEngine.shared.userSetting.smallFont
        typeLabel.sizeToFit()
        
        contentView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: self.setting.itemCardCenterObjectsToEdgeOffset).isActive = true
    }
    
   
    
    private func addFinishedDaysLabel(labelFrame: CGRect?, withTypeLabel: Bool) {
        
        
        let attrs1 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.largeFont]
        let attrs2 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.smallFont, NSAttributedString.Key.foregroundColor: UIColor.label]
        finishedDaysLabel.accessibilityIdentifier = "FinishedDaysLabel"
        finishedDaysLabel.sizeToFit()
        
        let finishedDaysString = NSMutableAttributedString(string: "\(self.item.getFinishedDays())", attributes: attrs1)
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
                contentView.addSubview(finishedDaysLabel)
            }
    
        } else {
        
            finishedDaysString.append(unit)
            finishedDaysLabel.attributedText = finishedDaysString

            contentView.addSubview(finishedDaysLabel)
            finishedDaysLabel.translatesAutoresizingMaskIntoConstraints = false
            finishedDaysLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -3).isActive = true
            finishedDaysLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
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
        contentView.layer.addSublayer(barTrackLayer)

        var barShapeWitdh: CGFloat {
            let width = CGFloat(self.item.getProgress()) * barFrame.width
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
        contentView.layer.addSublayer(barShapeLayer)
       
        if withProgressLabel {
            let progressLabel = UILabel()
            progressLabel.frame.origin = CGPoint(x: CGFloat(self.item.getProgress()) * barFrame.width - 10, y: barFrame.origin.y - barFrame.height - 10)
            progressLabel.font = AppEngine.shared.userSetting.smallFont
            progressLabel.text = self.item.getProgressInPercentageString()
            progressLabel.sizeToFit()
            contentView.addSubview(progressLabel)
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
                
                contentView.addSubview(daysLabel)
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
            
            contentView.addSubview(daysLabel)
            
            daysLabel.translatesAutoresizingMaskIntoConstraints = false
            daysLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
            daysLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18).isActive = true
            
        }
       
    }
    
   
    
    private func addPunInButton() {
        
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
    
        punchInButton.isSelected = self.item.isPunchedIn() ? true : false
        
        punchInButton.layer.borderWidth = 1
        punchInButton.layer.borderColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor
//        if punchInButton.isSelected {
//            punchInButton.layer.borderWidth = 0
//
//        } else {
//            punchInButton.layer.borderWidth = 1
//            punchInButton.layer.borderColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor
//
//        }
        
        contentView.addSubview(punchInButton)
        punchInButton.translatesAutoresizingMaskIntoConstraints = false
        punchInButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        punchInButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -self.setting.itemCardCenterObjectsToEdgeOffset).isActive = true
        punchInButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        if isInteractable {
            punchInButton.addTarget(self.itemCardView, action: #selector(self.itemCardView.itemPunchInButtonPressed(_:)), for: .touchUpInside)
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
        
        
        confettiTopView.accessibilityIdentifier = "TopConfettiView"
        confettiTopView.frame = CGRect(x: 0, y: 0, width: itemCardView.frame.width, height: 40)
        confettiTopView.layer.cornerRadius = itemCardView.layer.cornerRadius
        confettiTopView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        confettiTopView.layer.masksToBounds = true
        confettiTopView.addConfettiView()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = confettiTopView.bounds
        gradientLayer.colors = [AppEngine.shared.userSetting.whiteAndBlackContent.withAlphaComponent(0).cgColor, AppEngine.shared.userSetting.whiteAndBlackContent.withAlphaComponent(1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        confettiTopView.layer.addSublayer(gradientLayer)
        contentView.addSubview(confettiTopView)
    
    }
    
    private func lockItemCard() {
        
        itemCardView.isUserInteractionEnabled = false
        itemCardView.alpha = 0.4

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

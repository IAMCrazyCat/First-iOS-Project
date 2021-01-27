//
//  ItemBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 26/12/20.
//
import Foundation
import UIKit

class ItemViewBuilder {

    let item: Item
    let punchInButtonTag: Int
    var cordinateX: CGFloat
    var cordinateY: CGFloat
    var width: CGFloat
    var height: CGFloat
    var punchInButtonAction: Selector?
    var detailsButtonAction: Selector?
    
    let cardBGImage: UIImage = SystemStyleSetting.shared.itemCardBGImage
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let outPutView: UIView = UIView()
    var freqency: DataOption? = nil
    
    init(item: Item, width: CGFloat, height: CGFloat, corninateX: CGFloat, cordinateY: CGFloat, punchInButtonTag: Int, punchInButtonAction: Selector, detailsButtonAction: Selector){

        self.item = item
        self.cordinateX = corninateX
        self.cordinateY = cordinateY
        self.punchInButtonTag = punchInButtonTag
        self.width = width
        self.height = height
        self.punchInButtonAction = punchInButtonAction
        self.detailsButtonAction = detailsButtonAction
        if let freqency = item.frequency {
            self.freqency = freqency
        }
    }
    
    init(item: Item, width: CGFloat, height: CGFloat, corninateX: CGFloat, cordinateY: CGFloat){

        self.item = item
        self.cordinateX = corninateX
        self.cordinateY = cordinateY
        self.punchInButtonTag = 11607
        self.width = width
        self.height = height
        self.punchInButtonAction = nil
        self.detailsButtonAction = nil
        
        if let freqency = item.frequency {
            self.freqency = freqency
        }
    }
    
    
    public func buildItemCardView() -> UIView {
      
        createItemCardView() //1
        addNameLabel() //2
        addGoDetailsButton() //3
        addTypeLabel() //4
        addFinishedDaysLabel(labelFrame: nil, withTypeLabel: false) //5
        addProgressBar(barFrame: CGRect(x: self.setting.mainDistance, y: outPutView.frame.height - 30, width: outPutView.frame.width - self.setting.progressBarLengthToRightEdgeOffset, height: 10), withProgressLabel: false) //5
        addTargetDaysLabel(labelFrame: nil, withTypeLabel: false) //6
        addPunInButton() //7
        addItemCardFreqencyLabel()
        
        return outPutView
    
    }
    
    public func buildDetailsView() -> UIView {
        //freqency = DataOption(data: 1)
        createItemDetailsView()
        addProgressBar(barFrame: CGRect(x: self.setting.mainPadding, y: outPutView.frame.height - 30, width: outPutView.frame.width - self.setting.mainPadding * 2, height: 15), withProgressLabel: true)
        addItemDetailsFreqencyLabel()
        addFinishedDaysLabel(labelFrame: CGRect(x: 100, y: 100, width: 0, height: 0), withTypeLabel: true)
        addTargetDaysLabel(labelFrame: CGRect(x: 220, y: 100, width: 0, height: 0), withTypeLabel: true)
        
        return outPutView
    }
    
    private func createItemCardView() {
   
        outPutView.accessibilityIdentifier = setting.itemCardIdentifier
        outPutView.backgroundColor = setting.whiteAndBlack
        outPutView.layer.cornerRadius = setting.itemCardCornerRadius
        outPutView.setViewShadow()
        outPutView.frame = CGRect(x: cordinateX, y: cordinateY, width: width, height: height)
        
    }
    
    private func createItemDetailsView() {
        outPutView.backgroundColor = setting.whiteAndBlack
        outPutView.layer.cornerRadius = setting.itemCardCornerRadius
        outPutView.frame = CGRect(x: cordinateX, y: cordinateY, width: width, height: height)
    }
    
    private func addNameLabel() {
        let nameLabel = UILabel()
        nameLabel.accessibilityIdentifier = "nameLabel"
        nameLabel.text = item.type.rawValue + item.name

        nameLabel.textColor = .black
        nameLabel.font = UserStyleSetting.fontSmall
        
        outPutView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        nameLabel.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: self.setting.mainDistance).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: outPutView.leftAnchor, constant: self.setting.mainDistance).isActive = true
    }
    
    private func addItemCardFreqencyLabel() {
        let freqencyLabel = UILabel()
        freqencyLabel.accessibilityIdentifier = "freqencyLabel"
        
        freqencyLabel.text = freqency?.title
        freqencyLabel.textColor = .black
        freqencyLabel.font = UserStyleSetting.fontSmall
        freqencyLabel.sizeToFit()
        
        outPutView.addSubview(freqencyLabel)
        
        
        for subview in  outPutView.subviews {
            if subview.accessibilityIdentifier == "nameLabel" {
                let nameLabel = subview
                freqencyLabel.translatesAutoresizingMaskIntoConstraints = false
                freqencyLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
                freqencyLabel.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: self.setting.mainDistance).isActive = true
                freqencyLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 10).isActive = true
            }
        }

    }
    
    private func addItemDetailsFreqencyLabel() {
        let freqencyLabel = UILabel()

        freqencyLabel.accessibilityIdentifier = "freqencyLabel"
        freqencyLabel.text = "频率: \(freqency?.title ?? "自由打卡")"
        freqencyLabel.textColor = .black
        freqencyLabel.font = UserStyleSetting.fontMedium
        freqencyLabel.sizeToFit()
        
        outPutView.addSubview(freqencyLabel)
        freqencyLabel.translatesAutoresizingMaskIntoConstraints = false
        freqencyLabel.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: 20).isActive = true
        freqencyLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        freqencyLabel.rightAnchor.constraint(equalTo: outPutView.rightAnchor, constant: -self.setting.mainPadding).isActive = true
        
        
        

    }
    
    
    private func addGoDetailsButton() {
        
        
        let goDetailsButton = UIButton()
        goDetailsButton.accessibilityIdentifier = "goDetailsButton"
        goDetailsButton.setBackgroundImage(UIImage(named: "DetailsButton"), for: .normal)
        goDetailsButton.setTitleColor(.black, for: .normal)
        goDetailsButton.titleLabel!.font = UserStyleSetting.fontSmall
        goDetailsButton.tintColor = UserStyleSetting.themeColor
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
        print("DetailsButtonAdded, item: \(item)")
        if detailsButtonAction != nil {
            fullViewButton.addTarget(self, action: detailsButtonAction!, for: .touchDown)
        }
        outPutView.addSubview(fullViewButton)
    }
    
    private func addTypeLabel() {
        let typeLabel = UILabel()
        typeLabel.accessibilityIdentifier = "typeLabel"
        
        typeLabel.text = "已打卡"
        typeLabel.textColor = .black
        typeLabel.font = UserStyleSetting.fontSmall
        typeLabel.sizeToFit()
        
        outPutView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.centerYAnchor.constraint(equalTo: outPutView.centerYAnchor).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: outPutView.leftAnchor, constant: self.setting.itemCardCenterObjectsToEdgeOffset).isActive = true
    }
    
    
    private func addFinishedDaysLabel(labelFrame: CGRect?, withTypeLabel: Bool) {
        
        let finishedDaysLabel = UILabel()
        let attrs1 = [NSAttributedString.Key.font: UserStyleSetting.fontLarge]
        let attrs2 = [NSAttributedString.Key.font: UserStyleSetting.fontSmall, NSAttributedString.Key.foregroundColor: UIColor.gray]
        finishedDaysLabel.accessibilityIdentifier = "finishedDaysLabel"
        finishedDaysLabel.sizeToFit()
        
        let finishedDaysString = NSMutableAttributedString(string: "\(self.item.finishedDays)", attributes: attrs1)
        let unit = NSMutableAttributedString(string: "  天", attributes: attrs2)
        
        if withTypeLabel {
            if labelFrame != nil {
                
                finishedDaysLabel.frame.origin = labelFrame!.origin
                let attrs0 = [NSAttributedString.Key.font: UserStyleSetting.fontSmall, NSAttributedString.Key.foregroundColor: UIColor.gray]
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
        
        let shapeColor = UserStyleSetting.themeColor.cgColor
        let trackColor = UserStyleSetting.themeColor.withAlphaComponent(0.3).cgColor
        let progressWidth: CGFloat = 10

        barTrackLayer.name = "progressTrack"
        barTrackLayer.path = barTrackPath.cgPath
        barTrackLayer.lineWidth = progressWidth
        barTrackLayer.fillColor = trackColor
        barTrackLayer.lineCap = CAShapeLayerLineCap.round
        barTrackLayer.strokeEnd = 0
        outPutView.layer.addSublayer(barTrackLayer)
        
        let barShapePath = UIBezierPath(roundedRect: CGRect(x: barFrame.origin.x, y: barFrame.origin.y, width: CGFloat(self.item.progress) * barFrame.width, height: barFrame.height), cornerRadius: 10)
        let barShapeLayer = CAShapeLayer()
        barShapeLayer.name = "progressBar"
        barShapeLayer.path = barShapePath.cgPath
        barShapeLayer.lineWidth = progressWidth
        barShapeLayer.fillColor = shapeColor
        barShapeLayer.lineCap = CAShapeLayerLineCap.round
        barShapeLayer.strokeEnd = 0
        outPutView.layer.addSublayer(barShapeLayer)
        
        if withProgressLabel {
            let progressLabel = UILabel()
            progressLabel.frame.origin = CGPoint(x: CGFloat(self.item.progress) * barFrame.width - 10, y: barFrame.origin.y - barFrame.height - 10)
            progressLabel.font = UserStyleSetting.fontSmall
            progressLabel.text = self.item.progressInPercentageString
            progressLabel.sizeToFit()
            outPutView.addSubview(progressLabel)
        }
    }
    
    private func addTargetDaysLabel(labelFrame: CGRect?, withTypeLabel: Bool) {
        if withTypeLabel {
            
            if labelFrame != nil {
                let daysLabel = UILabel()
                daysLabel.accessibilityIdentifier = "daysLabel"
                daysLabel.frame.origin = labelFrame!.origin
                
                let atr0 = [NSAttributedString.Key.font: UserStyleSetting.fontSmall]
                let atr1 = [NSAttributedString.Key.font: UserStyleSetting.fontLarge]
                let atr2 = [NSAttributedString.Key.font: UserStyleSetting.fontSmall, NSAttributedString.Key.foregroundColor: UIColor.black]
                
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
            daysLabel.accessibilityIdentifier = "daysLabel"
            
            let atr1 = [NSAttributedString.Key.font: UserStyleSetting.fontSmall]
            let atr2 = [NSAttributedString.Key.font: UserStyleSetting.fontSmall, NSAttributedString.Key.foregroundColor: UIColor.black]
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
        punchInButton.accessibilityIdentifier = "punchInButton"
        
        punchInButton.setTitle("打卡", for: .normal)
        punchInButton.titleLabel!.font = UserStyleSetting.fontSmall
        punchInButton.backgroundColor = UserStyleSetting.themeColor
        punchInButton.layer.cornerRadius = self.setting.checkButtonCornerRadius
        punchInButton.layer.zPosition = 3
        
        outPutView.addSubview(punchInButton)
        punchInButton.translatesAutoresizingMaskIntoConstraints = false
        punchInButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        punchInButton.rightAnchor.constraint(equalTo: outPutView.rightAnchor, constant: -self.setting.itemCardCenterObjectsToEdgeOffset).isActive = true
        punchInButton.centerYAnchor.constraint(equalTo: outPutView.centerYAnchor).isActive = true
        punchInButton.tag = self.punchInButtonTag
        
        if punchInButtonAction != nil {
            punchInButton.addTarget(self, action: punchInButtonAction!, for: .touchDown)
        }
    }
    

    
    
  
}

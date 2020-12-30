//
//  ItemBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 26/12/20.
//
import Foundation
import UIKit

class ItemCardBuilder: Builder {

    let item: Item
    let cordinateX: CGFloat
    var cordinateY: CGFloat
    let width: CGFloat
    let punchInButtonTag: Int
    
    let cardBGImage: UIImage
    let setting: SystemStyleSetting
    let newItemCardView: UIView
    
    
    init(item: Item, corninateX: CGFloat, cordinateY: CGFloat, punchInButtonTag: Int){

        self.item = item
        self.cordinateX = corninateX
        self.cordinateY = cordinateY
        self.setting = SystemStyleSetting.shared
        self.width = setting.viewFrame.width - 20 * 2
        self.punchInButtonTag = punchInButtonTag
        self.cardBGImage = setting.itemCardBGImage
        self.newItemCardView = UIView()
       
    }
    
    func buildStandardView() {
        createItemCardUIView() //1
        addNameLabel() //2
        addGoDetailsButton() //3
        addTypeLabel() //4
        addFinishedDaysLabel() //5
        addProgressBar() //5
        addDaysLabel() //6
        addPunInButton() //7
    
    }
    
    func createItemCardUIView() {
   
        newItemCardView.layer.contents = cardBGImage.cgImage
        newItemCardView.frame = CGRect(x:cordinateX, y: cordinateY, width: width, height: self.setting.itemCardHeight)
    }
    
    func addNameLabel() {
        let nameLabel = UILabel()
        nameLabel.accessibilityIdentifier = "nameLabel"
        nameLabel.text = item.type.rawValue + item.name

        nameLabel.textColor = UIColor.black
        nameLabel.font = UserStyleSetting.fontSmall
        
        newItemCardView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        nameLabel.topAnchor.constraint(equalTo: newItemCardView.topAnchor, constant: 20).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: newItemCardView.leftAnchor, constant: 20).isActive = true
    }
    
    func addGoDetailsButton() {
        
        let goDetailsButton = UIButton()
        goDetailsButton.accessibilityIdentifier = "goDetailsButton"
        
        goDetailsButton.setTitle("TEST", for: .normal)
        goDetailsButton.setTitleColor(UIColor.black, for: .normal)
        goDetailsButton.titleLabel!.font = UserStyleSetting.fontSmall
        newItemCardView.addSubview(goDetailsButton)
        
        goDetailsButton.sizeToFit()
        goDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        goDetailsButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        goDetailsButton.topAnchor.constraint(equalTo: newItemCardView.topAnchor, constant: 20).isActive = true
        goDetailsButton.rightAnchor.constraint(equalTo: newItemCardView.rightAnchor, constant: -20).isActive = true
    }
    
    func addTypeLabel() {
        let typeLabel = UILabel()
        typeLabel.accessibilityIdentifier = "typeLabel"
        
        typeLabel.text = "已打卡"
        typeLabel.textColor = UIColor.black
        typeLabel.font = UserStyleSetting.fontSmall
        typeLabel.sizeToFit()
        
        newItemCardView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.centerYAnchor.constraint(equalTo: newItemCardView.centerYAnchor).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: newItemCardView.leftAnchor, constant: self.setting.itemCardCenterObjectsOffset).isActive = true
    }
    
    func addFinishedDaysLabel() {
        let finishedDaysLabel = UILabel()
        finishedDaysLabel.accessibilityIdentifier = "finishedDaysLabel"
        
        let attrs1 = [NSAttributedString.Key.font: UserStyleSetting.fontLarge]
        let attrs2 = [NSAttributedString.Key.font: UserStyleSetting.fontSmall, NSAttributedString.Key.foregroundColor: UIColor.gray]
        let finishedDaysString = NSMutableAttributedString(string: "\(self.item.finishedDays)", attributes: attrs1)
        let unit = NSMutableAttributedString(string: "  天", attributes: attrs2)
        
        finishedDaysString.append(unit)
        finishedDaysLabel.attributedText = finishedDaysString
        finishedDaysLabel.sizeToFit()
        
        newItemCardView.addSubview(finishedDaysLabel)
        finishedDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        finishedDaysLabel.centerYAnchor.constraint(equalTo: newItemCardView.centerYAnchor, constant: -3).isActive = true
        finishedDaysLabel.centerXAnchor.constraint(equalTo: newItemCardView.centerXAnchor).isActive = true
    }
    
    func addProgressBar() {
        let barTrackPath = UIBezierPath(roundedRect: CGRect(x: 20, y: newItemCardView.frame.height - 30, width: newItemCardView.frame.width - self.setting.progressBarLengthToRightEdgeOffset, height: 10), cornerRadius: 10)
        let barTrackLayer = CAShapeLayer()
        
        let shapeColor = UserStyleSetting.themeColor?.cgColor
        let trackColor = UserStyleSetting.themeColor?.withAlphaComponent(0.3).cgColor
        let progressWidth: CGFloat = 10

        barTrackLayer.name = "progressTrack"
        barTrackLayer.path = barTrackPath.cgPath
        barTrackLayer.lineWidth = progressWidth
        barTrackLayer.fillColor = trackColor
        barTrackLayer.lineCap = CAShapeLayerLineCap.round
        barTrackLayer.strokeEnd = 0
        newItemCardView.layer.addSublayer(barTrackLayer)
        
        let barShapePath = UIBezierPath(roundedRect: CGRect(x: 20, y: newItemCardView.frame.height - 30, width: CGFloat(self.item.finishedDays) / CGFloat(self.item.days) * (newItemCardView.frame.width - self.setting.progressBarLengthToRightEdgeOffset), height: 10), cornerRadius: 10)
        let barShapeLayer = CAShapeLayer()
        barShapeLayer.name = "progressBar"
        barShapeLayer.path = barShapePath.cgPath
        barShapeLayer.lineWidth = progressWidth
        barShapeLayer.fillColor = shapeColor
        barShapeLayer.lineCap = CAShapeLayerLineCap.round
        barShapeLayer.strokeEnd = 0
        newItemCardView.layer.addSublayer(barShapeLayer)
    }
    
    func addDaysLabel() {
        let daysLabel = UILabel()
        daysLabel.accessibilityIdentifier = "daysLabel"
        
        let atr1 = [NSAttributedString.Key.font: UserStyleSetting.fontSmall]
        let atr2 = [NSAttributedString.Key.font: UserStyleSetting.fontSmall, NSAttributedString.Key.foregroundColor: UIColor.black]
        let daysString = NSMutableAttributedString(string: "\(self.item.days)", attributes: atr1)
        let daysUnit = NSMutableAttributedString(string: "天", attributes: atr2)
        
        daysString.append(daysUnit)
        daysLabel.attributedText = daysString
        daysLabel.sizeToFit()
        
        newItemCardView.addSubview(daysLabel)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.rightAnchor.constraint(equalTo: newItemCardView.rightAnchor, constant: -20).isActive = true
        daysLabel.bottomAnchor.constraint(equalTo: newItemCardView.bottomAnchor, constant: -18).isActive = true
    }
    
    func addPunInButton() {
        let punchInButton = UIButton()
        punchInButton.accessibilityIdentifier = "punchInButton"
        
        punchInButton.setTitle("打卡", for: .normal)
        punchInButton.titleLabel!.font = UserStyleSetting.fontSmall
        punchInButton.backgroundColor = UserStyleSetting.themeColor
        punchInButton.layer.cornerRadius = self.setting.checkButtonCornerRadius
        
        newItemCardView.addSubview(punchInButton)
        punchInButton.translatesAutoresizingMaskIntoConstraints = false
        punchInButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        punchInButton.rightAnchor.constraint(equalTo: newItemCardView.rightAnchor, constant: -self.setting.itemCardCenterObjectsOffset).isActive = true
        punchInButton.centerYAnchor.constraint(equalTo: newItemCardView.centerYAnchor).isActive = true
        
        //punchInButton.addTarget(self, action: .punchInButtonAction, for: .touchDown)
        punchInButton.tag = self.punchInButtonTag
    }
    
    
    func getBuiltItem() -> Any {
        return newItemCardView
    }
}

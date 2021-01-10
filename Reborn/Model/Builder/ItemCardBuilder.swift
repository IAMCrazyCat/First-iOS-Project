//
//  ItemBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 26/12/20.
//
import Foundation
import UIKit

class ItemCardBuilder {

    let item: Item
    let cordinateX: CGFloat
    var cordinateY: CGFloat
    let width: CGFloat
    let height: CGFloat
    let punchInButtonTag: Int
    
    let cardBGImage: UIImage = SystemStyleSetting.shared.itemCardBGImage
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let newItemCardView: UIView = UIView()
    var freqency: DataOption? = nil
    
    init(item: Item, width: CGFloat, height: CGFloat, corninateX: CGFloat, cordinateY: CGFloat, punchInButtonTag: Int){

        self.item = item
        self.cordinateX = corninateX
        self.cordinateY = cordinateY
        self.punchInButtonTag = punchInButtonTag
        self.width = width
        self.height = height
        
        if let freqency = item.frequency {
            self.freqency = freqency
        }
    }
    
    
    public func buildItemCardView() -> UIView {
        createItemCardUIView() //1
        addNameLabel() //2
        addGoDetailsButton() //3
        addTypeLabel() //4
        addFinishedDaysLabel() //5
        addProgressBar() //5
        addDaysLabel() //6
        addPunInButton() //7
        
        if freqency != nil {
            addFreqencyLabel()
        }
        
        return newItemCardView
    
    }
    
    private func createItemCardUIView() {
   
        newItemCardView.accessibilityIdentifier = setting.itemCardIdentifier
        newItemCardView.backgroundColor = setting.whiteAndBlack
        newItemCardView.layer.cornerRadius = setting.itemCardCornerRadius
        newItemCardView.setViewShadow()
        newItemCardView.frame = CGRect(x: cordinateX + 5, y: cordinateY + 5, width: width - 10, height: height)
    }
    
    private func addNameLabel() {
        let nameLabel = UILabel()
        nameLabel.accessibilityIdentifier = "nameLabel"
        nameLabel.text = item.type.rawValue + item.name

        nameLabel.textColor = UIColor.black
        nameLabel.font = UserStyleSetting.fontSmall
        
        newItemCardView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        nameLabel.topAnchor.constraint(equalTo: newItemCardView.topAnchor, constant: self.setting.mainDistance).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: newItemCardView.leftAnchor, constant: self.setting.mainDistance).isActive = true
    }
    
    private func addFreqencyLabel() {
        let freqencyLabel = UILabel()
        freqencyLabel.accessibilityIdentifier = "freqencyLabel"
        
        freqencyLabel.text = freqency?.title
        freqencyLabel.textColor = UIColor.black
        freqencyLabel.font = UserStyleSetting.fontSmall
        freqencyLabel.sizeToFit()
        
        newItemCardView.addSubview(freqencyLabel)
        
        
        for subview in  newItemCardView.subviews {
            if subview.accessibilityIdentifier == "nameLabel" {
                let nameLabel = subview
                freqencyLabel.translatesAutoresizingMaskIntoConstraints = false
                freqencyLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
                freqencyLabel.topAnchor.constraint(equalTo: newItemCardView.topAnchor, constant: self.setting.mainDistance).isActive = true
                freqencyLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 10).isActive = true
            }
        }
        
        

    }
    
    private func addFrequencyLabel() {
        
    }
    
    private func addGoDetailsButton() {
        
        let goDetailsButton = UIButton()
        goDetailsButton.accessibilityIdentifier = "goDetailsButton"
        goDetailsButton.setBackgroundImage(UIImage(named: "DetailsButton"), for: .normal)
        
        goDetailsButton.setTitleColor(UIColor.black, for: .normal)
        goDetailsButton.titleLabel!.font = UserStyleSetting.fontSmall
        newItemCardView.addSubview(goDetailsButton)
        
        goDetailsButton.tintColor = UserStyleSetting.themeColor
        goDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        goDetailsButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        goDetailsButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        goDetailsButton.topAnchor.constraint(equalTo: newItemCardView.topAnchor, constant: 20).isActive = true
        goDetailsButton.rightAnchor.constraint(equalTo: newItemCardView.rightAnchor, constant: -20).isActive = true
    }
    
    private func addTypeLabel() {
        let typeLabel = UILabel()
        typeLabel.accessibilityIdentifier = "typeLabel"
        
        typeLabel.text = "已打卡"
        typeLabel.textColor = UIColor.black
        typeLabel.font = UserStyleSetting.fontSmall
        typeLabel.sizeToFit()
        
        newItemCardView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.centerYAnchor.constraint(equalTo: newItemCardView.centerYAnchor).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: newItemCardView.leftAnchor, constant: self.setting.itemCardCenterObjectsToEdgeOffset).isActive = true
    }
    
   
    
    
    private func addFinishedDaysLabel() {
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
    
    
    private  func addProgressBar() {
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
    
    private func addDaysLabel() {
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
    
    private func addPunInButton() {
        let punchInButton = UIButton()
        punchInButton.accessibilityIdentifier = "punchInButton"
        
        punchInButton.setTitle("打卡", for: .normal)
        punchInButton.titleLabel!.font = UserStyleSetting.fontSmall
        punchInButton.backgroundColor = UserStyleSetting.themeColor
        punchInButton.layer.cornerRadius = self.setting.checkButtonCornerRadius
        
        newItemCardView.addSubview(punchInButton)
        punchInButton.translatesAutoresizingMaskIntoConstraints = false
        punchInButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        punchInButton.rightAnchor.constraint(equalTo: newItemCardView.rightAnchor, constant: -self.setting.itemCardCenterObjectsToEdgeOffset).isActive = true
        punchInButton.centerYAnchor.constraint(equalTo: newItemCardView.centerYAnchor).isActive = true
        
        punchInButton.addTarget(self, action: #selector(HomeViewController.shared.punchInButtonPressed(_:)), for: .touchDown)
        punchInButton.tag = self.punchInButtonTag
    }
    
    
  
}

//
//  ItemDetailsViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 9/2/21.
//

import Foundation
import UIKit
class ItemProgressViewBuilder: ViewBuilder {
    
    let setting: SystemSetting = SystemSetting.shared
    let item: Item
    let punchInButtonTag: Int
    var cordinateX: CGFloat
    var cordinateY: CGFloat
    var width: CGFloat
    var height: CGFloat
    var outPutView: UIView = UIView()
    
    
    init(item: Item, frame: CGRect){ // for new item view preview card

        self.item = item
        self.cordinateX = frame.origin.x
        self.cordinateY = frame.origin.y
        self.punchInButtonTag = 11607
        self.width = frame.width
        self.height = frame.height

    }
    
    func buildView() -> UIView {
        createView()
        addProgressBar(barFrame: CGRect(x: self.setting.mainPadding, y: outPutView.frame.height / 2, width: outPutView.frame.width - self.setting.mainPadding * 2, height: 15), withProgressLabel: true)
        return outPutView
    }
    
    internal func createView() {
        outPutView.backgroundColor = .clear
        //outPutView.layer.cornerRadius = setting.itemCardCornerRadius
        outPutView.frame = CGRect(x: cordinateX, y: cordinateY, width: width, height: height)
    }
    
    private func addItemDetailsFreqencyLabel() {
        let freqencyLabel = UILabel()

        freqencyLabel.accessibilityIdentifier = "freqencyLabel"
        freqencyLabel.text = "频率: \(item.frequency.dataModel.title)"
        freqencyLabel.textColor = .black
        freqencyLabel.font = AppEngine.shared.userSetting.mediumFont
        freqencyLabel.sizeToFit()
        
        outPutView.addSubview(freqencyLabel)
        freqencyLabel.translatesAutoresizingMaskIntoConstraints = false
        freqencyLabel.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: 20).isActive = true
        freqencyLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        freqencyLabel.rightAnchor.constraint(equalTo: outPutView.rightAnchor, constant: -self.setting.mainPadding).isActive = true
        
    }
    
    private  func addProgressBar(barFrame: CGRect, withProgressLabel: Bool) {
        let barTrackPath = UIBezierPath(roundedRect: barFrame, cornerRadius: 10)
        let barTrackLayer = CAShapeLayer()
        
        let shapeColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor
        let trackColor = AppEngine.shared.userSetting.themeColor.uiColor.withAlphaComponent(0.3).cgColor
        let progressWidth: CGFloat = 10

        barTrackLayer.name = "progressTrack"
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
        barShapeLayer.name = "progressBar"
        barShapeLayer.path = barShapePath.cgPath
        barShapeLayer.lineWidth = progressWidth
        barShapeLayer.fillColor = shapeColor
        barShapeLayer.lineCap = CAShapeLayerLineCap.round
        barShapeLayer.strokeEnd = 0
        outPutView.layer.addSublayer(barShapeLayer)
        
        if withProgressLabel {
            let progressLabel = UILabel()
            var labelX = CGFloat(self.item.progress) * barFrame.width
            let labelY = barFrame.origin.y - barFrame.height - 10
            
            if labelX - 10 > 0 {
                labelX -= 10
            }
            
            progressLabel.frame.origin = CGPoint(x: labelX, y: labelY)
            progressLabel.font = AppEngine.shared.userSetting.smallFont
            progressLabel.text = self.item.progressInPercentageString
            progressLabel.sizeToFit()
            
            progressLabel.layoutIfNeeded()
            if progressLabel.frame.maxX > barFrame.maxX { // if stretched out keep it in proper position
                progressLabel.frame.origin.x = barFrame.maxX - progressLabel.frame.width
            } else if progressLabel.frame.minX < barFrame.minX {
                progressLabel.frame.origin.x = barFrame.minX
            }
            outPutView.addSubview(progressLabel)
        }
    }

}

//
//  ItemCardView.swift
//  Reborn
//
//  Created by Christian Liu on 17/7/21.
//

import Foundation
import UIKit
class ItemCardView: UIView {
    var item: Item
    var icon: UIImageView = UIImageView()
    var notificationIcon: UIImageView = UIImageView()
    var titileLabel: UILabel = UILabel()
    var frequencyLabel: UILabel = UILabel()
    var finishedDaysLabel: UILabel = UILabel()
    var targetDaysLabel: UILabel = UILabel()
    var stateLabel: UILabel = UILabel()
    var progressTrackLayer: CAShapeLayer = CAShapeLayer()
    var progressShapeLayer: CAShapeLayer = CAShapeLayer()
    var progressShapeColor: CGColor = UIColor.red.cgColor
    var progressPathFrame: CGRect = .zero
    var punchInButton: UIButton = UIButton()
    var fullViewButton: UIButton = UIButton()
    var rightButton: UIButton = UIButton()
    var confettiView: UIView = UIView()
    
    public init(frame: CGRect, item: Item) {
        self.item = item
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateItem() {
        
        if !item.isPunchedIn {
            item.punchIn()
            
            Vibrator.vibrate(withNotificationType: .success)
        } else {
            item.revokePunchIn()

            Vibrator.vibrate(withImpactLevel: .light)
        }
        
        AppEngine.shared.currentUser.updateEnergy(by: item)
        
    }
    
    private func updateFinishedDaysLabel() {
        let attrs1 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.largeFont]
        let attrs2 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.smallFont, NSAttributedString.Key.foregroundColor: UIColor.label]
        let unit = NSMutableAttributedString(string: "  天", attributes: attrs2)
        let attrs0 = [NSAttributedString.Key.font: AppEngine.shared.userSetting.smallFont, NSAttributedString.Key.foregroundColor: UIColor.gray]
        let typeString = NSMutableAttributedString(string: "已打卡:  ", attributes: attrs0)
        let finishedDaysString = NSMutableAttributedString(string: "\(self.item.finishedDays)", attributes: attrs1)
        
        finishedDaysString.append(unit)
        self.finishedDaysLabel.attributedText = finishedDaysString

    }
    
    private func updateButton() {
        self.punchInButton.isSelected = self.item.isPunchedIn ? true : false
    }
    
    private func showAnimationIfNeeded() {
//        if self.item.isPunchedIn {
//            showConfettiAnimationAtBack(isRemovedOnCompletion: true)
//        }
        
    }
    
    public func updateUI() {
        updateItem()
        updateButton()
        updateProgressBar()
        updateFinishedDaysLabel()
        showAnimationIfNeeded()
    }
    
    private func updateProgressBar() {
        var barShapeWitdh: CGFloat {
            let width = CGFloat(self.item.progress) * progressPathFrame.width
            if width > progressPathFrame.width {
                return progressPathFrame.width
            } else {
                return width
            }
        }
        var newFrame = self.progressPathFrame
        newFrame.size.width = barShapeWitdh
        let newShapePath = UIBezierPath(roundedRect: newFrame, cornerRadius: 10)

        let newShapeLayer = CAShapeLayer()
        newShapeLayer.name = "ProgressBar"
        newShapeLayer.path = newShapePath.cgPath
        newShapeLayer.lineWidth = self.progressTrackLayer.lineWidth
        newShapeLayer.fillColor = self.progressShapeColor
        newShapeLayer.lineCap = CAShapeLayerLineCap.round
        newShapeLayer.strokeEnd = 0
        self.progressShapeLayer.removeFromSuperlayer()
        self.layer.addSublayer(newShapeLayer)
        self.progressShapeLayer = newShapeLayer
       
//        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        progressAnimation.toValue = 1
//        progressAnimation.duration = 1.5
//        progressAnimation.fillMode = CAMediaTimingFillMode.forwards
//        progressAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
//        progressAnimation.isRemovedOnCompletion = false
//        newShapeLayer.add(progressAnimation, forKey: nil)
        //self.layoutSubviews()
    }

    
    @objc func itemPunchInButtonPressed(_ sender: UIButton!) {
        
        updateUI()
        AppEngine.shared.saveUser()
       
//        AppEngine.shared.notifyUIObservers(withIdentifier: "HomeViewController")
//        AppEngine.shared.notifyUIObservers(withIdentifier: "ItemManagementViewController")
 
        if self.item.state == .completed {
            UIApplication.shared.getCurrentViewController()?.presentItemCompletedPopUp(for: item)
        }
    }
    
    @objc func itemDetailsButtonPressed(_ sender: UIButton!) {
        Vibrator.vibrate(withImpactLevel: .medium)

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let senderViewController = sender.findViewController(),
              let navigationController = senderViewController.navigationController,
              let itemDetailViewController = storyBoard.instantiateViewController(withIdentifier: "ItemDetailView") as? ItemDetailViewController
        else {
            return
        }
        
        itemDetailViewController.item = self.item
        itemDetailViewController.lastViewController = senderViewController
        navigationController.pushViewController(itemDetailViewController, animated: true)

    }
}

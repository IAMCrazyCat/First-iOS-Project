//
//  CustomTargetViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 29/12/20.
//

import Foundation
import UIKit

class PopUpViewBuilder: ViewBuilder {
    
    private let doneButton = UIButton()
    private let cancelButton = UIButton()
    
    internal var outPutView: UIView = UIView()
    internal var popUpViewController: PopUpViewController
    internal let titleLabel = UILabel()
    internal var setting: SystemSetting = SystemSetting.shared
    internal var frame: CGRect
    
    public var contentView: UIView = UIView()
    
    init(popUpViewController: PopUpViewController, frame: CGRect) {
        self.popUpViewController = popUpViewController
        self.frame = frame
    }
    
    public func buildView() -> UIView {
        createView()
        addCancelButton()
        addDoneButton()
        addTitleLabel()
        addContentView()
        addPopUpWindowToBgView()
        outPutView.layoutIfNeeded()
        return outPutView
    }

    
    
    // Building common fetures
    internal func createView() {
        
        // Tag 0
        outPutView.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
        outPutView.frame = frame
       
        outPutView.layer.cornerRadius = setting.popUpWindowCornerRadius
        //outPutView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        outPutView.tag = 0
    }
    
    private func addCancelButton() { // Tag 2
    
        cancelButton.setBackgroundImage(#imageLiteral(resourceName: "CancelButton"), for: .normal)
        cancelButton.tag = 2
        cancelButton.addTarget(popUpViewController, action: #selector(popUpViewController.cancelButtonPressed(_:)), for: .touchUpInside)
        outPutView.addSubview(cancelButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: self.setting.mainDistance).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: outPutView.rightAnchor, constant: -self.setting.mainDistance).isActive = true
        
        
    }
    
    private func addDoneButton() { // Tag 3
        
        doneButton.accessibilityIdentifier = "DoneButton"
        doneButton.backgroundColor = AppEngine.shared.userSetting.themeColor
        doneButton.setTitle("确定", for: .normal)
        
        doneButton.tag = setting.popUpWindowDoneButtonTag
        doneButton.addTarget(popUpViewController, action: #selector(popUpViewController.doneButtonPressed(_:)), for: .touchUpInside)
        outPutView.addSubview(doneButton)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.bottomAnchor.constraint(equalTo: self.outPutView.bottomAnchor, constant: -self.setting.mainDistance - 20).isActive = true
        doneButton.leftAnchor.constraint(equalTo: self.outPutView.leftAnchor, constant: self.setting.mainDistance).isActive = true
        doneButton.rightAnchor.constraint(equalTo: self.outPutView.rightAnchor, constant: -self.setting.mainDistance).isActive = true
       
        doneButton.proportionallySetHeightWithScreen()
        doneButton.setCornerRadius()
        
    }
    
    private func addContentView() {
        
        contentView.accessibilityIdentifier = "ContentView"
        outPutView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: setting.mainDistance).isActive = true
        contentView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -setting.mainDistance).isActive = true
        contentView.leftAnchor.constraint(equalTo: outPutView.leftAnchor, constant: setting.mainDistance).isActive = true
        contentView.rightAnchor.constraint(equalTo: outPutView.rightAnchor, constant: -setting.mainDistance).isActive = true
        contentView.layoutIfNeeded()
        
    }
    
    private func addTitleLabel() {
        
        titleLabel.accessibilityIdentifier = "TitleLabel"
        titleLabel.text = "(弹窗名)"
        titleLabel.font = AppEngine.shared.userSetting.largeFont
        titleLabel.sizeToFit()
        
        outPutView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: 50).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: outPutView.leftAnchor, constant: setting.mainDistance).isActive = true
    }
    
    
    private func addPopUpWindowToBgView() {
        popUpViewController.view.addSubview(outPutView)
    }
    
    
   
}

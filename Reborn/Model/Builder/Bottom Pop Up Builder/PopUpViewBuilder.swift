//
//  CustomTargetViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 29/12/20.
//

import Foundation
import UIKit

class PopUpViewBuilder: ViewBuilder {
    
    private var outPutView: UIView = UIView()
    private let doneButton = UIButton()
    private let cancelButton = UIButton()
    
    internal var popUpViewController: PopUpViewController?
    internal var contentView: UIView = UIView()
    internal let titleLabel = UILabel()
    internal var setting: SystemSetting
    
    
    init(popUpViewController: PopUpViewController) {
        self.setting = SystemSetting.shared
        self.popUpViewController = popUpViewController
    }
    
    public func buildView() -> UIView {
        createPopUpUIViews()
        addCancelButton()
        addDoneButton()
        addTitleLabel()
        addContentView()
        addPopUpWindowToBgView()
        outPutView.layoutIfNeeded()
        return outPutView
    }
    
    
    // Building common fetures
    private func createPopUpUIViews() {
        
        // Tag 0
        outPutView.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
        outPutView.frame = CGRect(x: 0, y: 0, width: setting.screenFrame.width, height: setting.popUpWindowHeight)
        outPutView.layer.cornerRadius = setting.popUpWindowCornerRadius
        outPutView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        outPutView.tag = 0
    }
    
    private func addCancelButton() { // Tag 2
    
        cancelButton.setBackgroundImage(#imageLiteral(resourceName: "CancelButton"), for: .normal)
        cancelButton.tag = 2
        cancelButton.addTarget(popUpViewController, action: #selector(popUpViewController?.cancelButtonPressed(_:)), for: .touchDown)
        outPutView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: self.setting.mainDistance).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: outPutView.rightAnchor, constant: -self.setting.mainDistance).isActive = true
        
        
    }
    
    private func addDoneButton() { // Tag 3
        
        doneButton.backgroundColor = AppEngine.shared.userSetting.themeColor
        doneButton.setTitle("确定", for: .normal)
        doneButton.layer.cornerRadius = self.setting.mainButtonCornerRadius
        doneButton.tag = setting.popUpWindowDoneButtonTag
        doneButton.addTarget(popUpViewController, action: #selector(popUpViewController?.doneButtonPressed(_:)), for: .touchDown)
        outPutView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.bottomAnchor.constraint(equalTo: self.outPutView.bottomAnchor, constant: -self.setting.mainDistance - 20).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: self.outPutView.centerXAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: self.setting.mainButtonHeight).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: self.setting.screenFrame.width - 2 * self.setting.mainDistance).isActive = true

        
    }
    
    private func addContentView() {
        
        outPutView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: setting.mainPadding).isActive = true
        contentView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -setting.mainPadding).isActive = true
        contentView.leftAnchor.constraint(equalTo: outPutView.leftAnchor, constant: setting.mainPadding).isActive = true
        contentView.rightAnchor.constraint(equalTo: outPutView.rightAnchor, constant: -setting.mainPadding).isActive = true
        contentView.layoutIfNeeded()
        
    }
    
    private func addTitleLabel() {
        
        titleLabel.text = "(弹窗名)"
        titleLabel.font = AppEngine.shared.userSetting.fontLarge
        titleLabel.sizeToFit()
        
        self.outPutView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: 50).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: outPutView.leftAnchor, constant: self.setting.mainDistance).isActive = true
    }
    
    
    private func addPopUpWindowToBgView() {
        popUpViewController?.view.addSubview(outPutView)
    }
    
    
   
}

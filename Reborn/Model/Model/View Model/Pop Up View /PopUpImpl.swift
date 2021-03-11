//
//  PopUpImpl.swift
//  Reborn
//
//  Created by Christian Liu on 8/3/21.
//

import Foundation
import UIKit
class PopUpImpl: PopUp {
    
    var frame: CGRect = .zero
    var window: UIView = UIView()
    var contentView: UIView? {
        return self.window.getSubviewBy(idenifier: "ContentView")
    }
    var titleLabel: UIView? {
        return self.window.getSubviewBy(idenifier: "TitleLabel")
    }
    var cancelButton: UIButton? {
        return self.contentView?.getSubviewBy(idenifier: "CancelButton") as? UIButton
    }
    var doneButton: UIButton? {
        return self.window.getSubviewBy(idenifier: "DoneButton") as? UIButton
    }
    var presentAnimationType: PopUpAnimationType
    weak var popUpViewController: PopUpViewController!
    
    let setting: SystemSetting = SystemSetting.shared
    var type: PopUpType
    
    init(presentAnimationType: PopUpAnimationType, popUpViewController: PopUpViewController, type: PopUpType) {
        self.presentAnimationType = presentAnimationType
        self.popUpViewController = popUpViewController
        self.type = type
        
        self.frame =  self.getFrame()
        self.window = self.createWindow()
    }
    
    
    func isReadyToDismiss() -> Bool {
        return true
    }
    
    func getStoredData() -> Any? {
        return nil
    }
    
    private func getFrame() -> CGRect {
        let popUpWindowFrame: CGRect
        switch presentAnimationType {
        case .fadeInFromCenter:
            
            let widthProportion: CGFloat = 0.9
            let heightProportion: CGFloat = 0.6
            popUpWindowFrame = CGRect(x: (self.setting.screenFrame.width - self.setting.screenFrame.width * widthProportion) / 2, y: (self.setting.screenFrame.height - self.setting.screenFrame.height * heightProportion) / 2, width: self.setting.screenFrame.width * widthProportion, height: self.setting.screenFrame.height * heightProportion)
            
        case .slideInToBottom:
            
            popUpWindowFrame = CGRect(x: 0, y: self.setting.screenFrame.height - self.setting.popUpWindowHeight, width: setting.screenFrame.width, height: setting.popUpWindowHeight)
            
        case .slideInToCenter:
            
            let widthProportion: CGFloat = 0.9
            let heightProportion: CGFloat = 0.5
            popUpWindowFrame =  CGRect(x: (self.setting.screenFrame.width - self.setting.screenFrame.width * widthProportion) / 2, y: (self.setting.screenFrame.height - self.setting.screenFrame.height * heightProportion) / 2, width: self.setting.screenFrame.width * widthProportion, height: self.setting.screenFrame.height * heightProportion)
            
        }
        return popUpWindowFrame
    }
    
    func createWindow() -> UIView {
        return UIView()
    }
    
    func updateUI() {
        
    }
    
    func excuteAnimation() {
        
    }
}

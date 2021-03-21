//
//  PopUpImpl.swift
//  Reborn
//
//  Created by Christian Liu on 8/3/21.
//

import Foundation
import UIKit
class PopUpImpl: PopUp {
    
    var frame: CGRect {
        return self.getFrame()
    }
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
    var size: PopUpSize
    
    init(presentAnimationType: PopUpAnimationType, type: PopUpType, size: PopUpSize, popUpViewController: PopUpViewController) {
        self.presentAnimationType = presentAnimationType
        self.popUpViewController = popUpViewController
        self.type = type
        self.size = size
        self.window = self.createWindow()

    }
    
    
    func isReadyToDismiss() -> Bool {
        return true
    }
    
    func getStoredData() -> Any? {
        return nil
    }
    
    private func getFrame() -> CGRect {
        var popUpWindowSize: CGSize
        var popUpWindowPosition: CGPoint
        let widthProportion: CGFloat
        let heightProportion: CGFloat
        
        switch self.size {
            
        case .small:
            
            widthProportion = 0.9
            heightProportion = 0.5
            popUpWindowSize =  CGSize(width: self.setting.screenFrame.width * widthProportion, height: self.setting.screenFrame.height * heightProportion)
            
        case .medium:
            
            widthProportion = 0.9
            heightProportion = 0.6
            popUpWindowSize =  CGSize(width: self.setting.screenFrame.width * widthProportion, height: self.setting.screenFrame.height * heightProportion)
            
        case .large:
        
            widthProportion = 0.9
            heightProportion = 0.7
            popUpWindowSize =  CGSize(width: self.setting.screenFrame.width * widthProportion, height: self.setting.screenFrame.height * heightProportion)
            
        }
        
        switch presentAnimationType {
        
        case .slideInToBottom:
            popUpWindowPosition = CGPoint(x: 0, y: self.setting.screenFrame.height - popUpWindowSize.height)
            popUpWindowSize.width = self.setting.screenFrame.width
            
        case .fadeInFromCenter, .slideInToCenter:
            popUpWindowPosition = CGPoint(x: (self.setting.screenFrame.width - self.setting.screenFrame.width * widthProportion) / 2, y: (self.setting.screenFrame.height - self.setting.screenFrame.height * heightProportion) / 2)
        }
        
        return CGRect(origin: popUpWindowPosition, size: popUpWindowSize)
    }
    
    func createWindow() -> UIView {
        return UIView()
    }
    
    func updateUI() {
        
    }
    
    func excuteAnimation() {
        
    }
}

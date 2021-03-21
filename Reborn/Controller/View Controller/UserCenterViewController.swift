//
//  UserCenterViewController.swift
//  Reborn
//
//  Created by Christian Liu on 6/1/21.
//

import UIKit
import StoreKit
class UserCenterViewController: UIViewController {
    @IBOutlet weak var perchaseButton: UIButton!
    
    @IBOutlet weak var avaterView: UIImageView!
    @IBOutlet weak var purchaseView: UIView!
    @IBOutlet weak var punchInSettingView: UIView!
    @IBOutlet weak var timeMachineSettingView: UIView!
    @IBOutlet weak var appSettingView: UIView!
    
    @IBOutlet weak var appVersionLabelButton: UIButton!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var energyButton: UIButton!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var themeColorButton: UIButton!
    @IBOutlet weak var lightAndDarkModeButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var restorePurchaseButton: UIButton!
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var editPartButton: UIButton!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    
    @IBOutlet weak var verticalContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    
    var scrollViewTopOffset: CGFloat = 0
    var scrollViewLastOffset: CGFloat = 0
    var setting: SystemSetting = SystemSetting.shared
    let engine: AppEngine = AppEngine.shared
    
    @IBOutlet var settingButtons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        AppEngine.shared.add(observer: self)
        
      
        editPartButton.alpha = 0.7
        avaterView.setCornerRadius()
        purchaseView.layer.cornerRadius = setting.itemCardCornerRadius - 5
        punchInSettingView.layer.cornerRadius = setting.itemCardCornerRadius - 5
        timeMachineSettingView.layer.cornerRadius = setting.itemCardCornerRadius - 5
        appSettingView.layer.cornerRadius = setting.itemCardCornerRadius
        
        purchaseView.setShadow()
        punchInSettingView.setShadow()
        timeMachineSettingView.setShadow()
        appSettingView.setShadow()
        
        verticalScrollView.delegate = self
        scrollViewTopOffset = avaterView.frame.origin.y - 10
 
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Error"
        self.appVersionLabelButton.setTitle("  v\(appVersion)", for: .normal)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarViewTapped))
        self.avaterView.addGestureRecognizer(gesture)
 
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
       
    }
    
    @objc func avatarViewTapped() {
        print("TAPPED")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func purchaseButtonPressed(_ sender: UIButton) {
        self.presentViewController(withIentifier: "PurchaseViewController")

    }
    @IBAction func notificationTimeButtonPressed(_ sender: UIButton) {
  
        self.present(.notificationTimePopUp, animation: .slideInToCenter)
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        self.present(.customThemeColorPopUp, animation: .slideInToCenter)
    }
    
    
    @IBAction func lightAndDarkButtonPressed(_ sender: UIButton) {
        self.present(.lightAndDarkModePopUp, animation: .slideInToCenter)
    }
    
    @IBAction func userNameButtonPressed(_ sender: UIButton!) {
        self.present(.customUserNamePopUp, animation: .slideInToBottom)
    }
    
    @IBAction func energyButtonPressed(_ sender: UIButton!) {
        self.presentViewController(withIentifier: "EnergySettingViewController")
    }
    
    @objc func settingButtonTouchedDown(_ sender: UIButton!) {
        sender.isSelected = true
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
            sender.isSelected = false
        }
    }
    
    func setButtonsAppearance() {
        self.themeColorButton.tintColor = AppEngine.shared.userSetting.themeColor
        for button in self.settingButtons {
            button.addTarget(self, action: #selector(self.settingButtonTouchedDown(_:)), for: .touchDown)
            button.setBackgroundColor(.systemGray3, for: .selected)
            button.layer.cornerRadius = self.setting.itemCardCornerRadius - 5
        }
    }
    
    func updateNavigationBar() {
        navigationController?.navigationBar.removeBorder()
        navigationController?.navigationBar.barTintColor = engine.userSetting.themeColorAndBlack
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: engine.userSetting.smartLabelColorAndThemeColor]
    }
    
    func updateUserNameButton() {
        self.userNameButton.setTitle(self.engine.currentUser.name, for: .normal)
    }
    
    func updateAvatarView() {
        self.avaterView.image = self.engine.currentUser.getAvatarImage()
    }
    
    func updateVerticalContentViewHeight() {
        //self.verticalScrollView.layoutIfNeeded()
        self.verticalContentViewHeightConstraint.constant = self.appVersionLabelButton.frame.maxY + self.setting.contentToScrollViewBottomDistance
    }
    
    func updateDateLabel() {
        dateLabel.text = "\(engine.currentDate.year)年\(engine.currentDate.month)月\(engine.currentDate.day)日"
    }
    
    func updateNotificationTimeLabel() {
        
        if self.engine.isNotificationEnabled() {
            self.notificationTimeLabel.text = "\(self.engine.userSetting.notificationTime.count)次提醒"
            print(self.engine.userSetting.notificationTime)
        } else {
            self.notificationTimeLabel.text = "已禁用"
        }
        

    }
    
    func updateEnergyLabel() {
        energyLabel.text = "× \(engine.currentUser.keys)"
    }
    
}


extension UserCenterViewController: UIObserver {
    func updateUI() {
        
        updateNavigationBar()
        setButtonsAppearance()
        updateUserNameButton()
        updateAvatarView()
        updateVerticalContentViewHeight()
        updateDateLabel()
        updateNotificationTimeLabel()
        updateEnergyLabel()
    }
}

extension UserCenterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage

        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        self.engine.currentUser.setAvatarImage(newImage)
        self.engine.notifyAllUIObservers()
        self.engine.saveUser()
        self.dismiss(animated: true)
    }
}

extension UserCenterViewController: PopUpViewDelegate {
    // Delegate extension
    func willDismissView() {
        
    }

    func didDismissPopUpViewWithoutSave() {

    }
    
    func didSaveAndDismissPopUpView(type: PopUpType) {
        if type == .customUserNamePopUp {
            
            self.engine.currentUser.name = (AppEngine.shared.storedDataFromPopUpView as? String) ?? "没有名字"
            
            
        } else if type == .notificationTimePopUp {
            
            if let notificationTime = self.engine.storedDataFromPopUpView as? Array<CustomTime> {
                self.engine.userSetting.notificationTime = notificationTime
                self.engine.saveSetting()
                self.engine.scheduleNotification()
            }

        }
        
        self.engine.notifyAllUIObservers()
    }
}

extension UserCenterViewController: UIScrollViewDelegate {
    
    
    // scrollview delegate functions
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y < self.scrollViewTopOffset / 2 && scrollView.contentOffset.y > 0 { // [0, crollViewTopOffset / 2]
            
            if scrollView.contentOffset.y > scrollViewLastOffset { // scroll up
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                }, completion: nil)
                
            }
            
        } else if scrollView.contentOffset.y > self.scrollViewTopOffset / 2 && scrollView.contentOffset.y < self.scrollViewTopOffset { // [crollViewTopOffset / 2, offset]
            
            if scrollView.contentOffset.y > scrollViewLastOffset  { // scroll up
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollViewTopOffset), animated: false)
                }, completion: nil)
            } else { // scroll down
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                }, completion: nil)
            }
        }
       
        self.scrollViewLastOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollViewTopOffset)
        let navigationBar = self.navigationController?.navigationBar
        if scrollView.contentOffset.y < self.scrollViewTopOffset - 10 {
            
            UIView.animate(withDuration: 0.2, animations: {
                navigationBar!.barTintColor = self.view.backgroundColor
                navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: self.engine.userSetting.smartLabelColorAndThemeColor.withAlphaComponent(0)]
                navigationBar!.layoutIfNeeded()
            })
            
        } else {
            
            UIView.animate(withDuration: 0.2, animations: {
                navigationBar!.barTintColor = self.engine.userSetting.themeColorAndBlack
                navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: self.engine.userSetting.smartLabelColorAndThemeColor.withAlphaComponent(1)]
                navigationBar!.layoutIfNeeded()
            })
            
        }
    }
    
}

//
//  UserCenterViewController.swift
//  Reborn
//
//  Created by Christian Liu on 6/1/21.
//

import UIKit
import StoreKit
import MessageUI
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
    @IBOutlet weak var purchaseRightButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var themeColorLabel: UILabel!
    @IBOutlet weak var energyButton: UIButton!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var energyRedDot: UIButton!
    @IBOutlet weak var energyRightButton: UIButton!
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
    @IBOutlet weak var appAppearanceModeLabel: UILabel!
    @IBOutlet weak var vipButton: UIButton!
    @IBOutlet weak var genderImageView: UIImageView!
    
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
        
        energyRedDot.setCornerRadius()
        vipButton.layer.cornerRadius = 5
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
        
        self.appVersionLabelButton.setTitle("  v\(self.engine.getAppVersion())", for: .normal)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarViewTapped))
        self.avaterView.addGestureRecognizer(gesture)
        AdStrategy().addBottomBannerAd(to: self)
        updateUI()

    }
    
    override func viewDidLayoutSubviews() {
       
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    
    @objc func avatarViewTapped() {
       
        presentImagePicker()
    }
    
    @IBAction func editAvatarButtonPressed(_ sender: UIButton) {
        Vibrator.vibrate(withImpactLevel: .medium)
        presentImagePicker()
    }
    
    @IBAction func purchaseButtonPressed(_ sender: UIButton) {
        self.presentViewController(withIentifier: "PurchaseViewController")

    }
    @IBAction func notificationTimeButtonPressed(_ sender: UIButton) {
    
        self.present(.notificationTimePopUp, size: .small, animation: .slideInToCenter)
    }
    
    @IBAction func themeColorButtonPressed(_ sender: UIButton) {

        self.present(.customThemeColorPopUp, size: .medium, animation: .slideInToCenter)
    }
    
    
    @IBAction func lightAndDarkButtonPressed(_ sender: UIButton) {

        self.present(.lightAndDarkModePopUp, size: .medium, animation: .slideInToCenter)
    }
    
    @IBAction func userNameButtonPressed(_ sender: UIButton!) {
        Vibrator.vibrate(withImpactLevel: .medium)
        self.present(.customUserInformationPopUp, size: .large, animation: .fadeInFromCenter)
    }
    
    @IBAction func energyButtonPressed(_ sender: UIButton!) {
        self.pushViewController(withIentifier: "EnergySettingViewController")
    }
    
    @IBAction func feedBackButtonPressed(_ sender: UIButton!) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["liuzimingjay@gmail.com"])
            mail.setSubject("User feedback of Reborn from: \(self.engine.currentUser.name)")
            mail.setMessageBody("<p>Hi CrazyCat, \n</p>", isHTML: true)

            present(mail, animated: true)
            
            } else {
                SystemAlert.present("您的设备未设置邮箱", and: "您可以手动发送反馈邮件到liuzimingjay@gmail.com", from: self)
                
        }
    }
    
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
        engine.requestReview()
    }
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        if let name = URL(string: "https://apps.apple.com/app/id1555988168"), !name.absoluteString.isEmpty {
          let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          self.present(activityVC, animated: true, completion: nil)
        } else {
          // show alert for not available
        }
    }
    
    @IBAction func restoredPurchaseButtonPressed(_ sender: UIButton) {
        
        self.verticalScrollView.scrollToTop(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.presentViewController(withIentifier: "PurchaseViewController")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if let purchaseViewController = UIApplication.shared.getTopViewController() as? PurchaseViewController {
                purchaseViewController.restoreApp()
            }
        })
        
    }
    @objc func settingButtonTouchedDown(_ sender: UIButton!) {
        sender.isSelected = true
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
            sender.isSelected = false
        }
    }
    
    func presentImagePicker() {
        LoadingAnimation.add(to: self.view, withRespondingTime: 5)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true) {
            LoadingAnimation.remove()
        }
    }
    
    func setButtonsAppearance() {
        self.themeColorButton.tintColor = AppEngine.shared.userSetting.themeColor.uiColor
        for button in self.settingButtons {
            button.addTarget(self, action: #selector(self.settingButtonTouchedDown(_:)), for: .touchUpInside)
            button.setBackgroundColor(SystemSetting.shared.smartLabelGrayColor, for: .selected)
            button.layer.cornerRadius = self.setting.itemCardCornerRadius - 5
        }
    }
    
    func updateNavigationBar() {
        self.setNavigationBarAppearance()
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
        dateLabel.text = "\(CustomDate.current.month)月\(CustomDate.current.day)日\( CustomDate.current.weekday.name)"
    }
    
    func updateNotificationTimeLabel() {
        
        if self.engine.isNotificationEnabled() {
            self.notificationTimeLabel.text = "\(self.engine.userSetting.notificationTime.count)次提醒"
            print(self.engine.userSetting.notificationTime)
        } else {
            self.notificationTimeLabel.text = "已禁用"
        }
        

    }
    
    func updateEnergyButton() {
        
        if self.engine.userSetting.hasViewedEnergyUpdate {
            
            self.energyRightButton.isHidden = false
            self.energyRedDot.isHidden = true
            self.energyLabel.text = "× \(engine.currentUser.energy)"
            
        } else {
            
            self.energyRightButton.isHidden = true
            self.energyRedDot.isHidden = false
            self.energyLabel.text = "新能量"
        }
        
    
    }
    
    func updateThemeColorView() {
        
//        var themeColorName: String = ""
//        for themeColor in ThemeColor.allCases {
//            print(AppEngine.shared.userSetting.themeColor == themeColor.uiColor)
//            if AppEngine.shared.userSetting.themeColor == themeColor.uiColor {
//                themeColorName = themeColor.name
//                
//            }
//        }
        self.themeColorLabel.text = "\(AppEngine.shared.userSetting.themeColor.name)"
    }
    
    func updateAppAppearanceModeLabel() {
        appAppearanceModeLabel.text = "\(engine.userSetting.appAppearanceMode.name)"
    }
    
    func updateVipButton() {
        vipButton.titleLabel?.font = engine.userSetting.smallFont.withSize(13)
        vipButton.isHidden = engine.currentUser.isVip ? false : true

        
    }
    
    func updateGenderImageView() {
        switch engine.currentUser.gender {
        case .male:
            genderImageView.image = #imageLiteral(resourceName: "MaleIcon")
            genderImageView.tintColor = ThemeColor.blue.uiColor
        case .female:
            genderImageView.image = #imageLiteral(resourceName: "FemaleIcon")
            genderImageView.tintColor = ThemeColor.pink.uiColor
        default:
            genderImageView.image = UIImage()
        }
    }
    
    func showVipIcon() {
        
        self.vipButton.isHidden = false
        self.vipButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.8, delay: 1 , animations: {
            self.vipButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.vipButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })  { _ in

            }
        }
        
       
    }
    
    func updatePurchaseButton() {
        if engine.currentUser.isVip {
            purchaseButton.setTitle("您正在使用\(App.name)-高级版", for: .normal)
            //purchaseButton.isUserInteractionEnabled = false
            purchaseRightButton.isHidden = true
        } else {
            purchaseButton.setTitle("升级成为完整版", for: .normal)
            purchaseButton.isUserInteractionEnabled = true
            purchaseRightButton.isHidden = false
        }
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
        updateEnergyButton()
        updateThemeColorView()
        updateAppAppearanceModeLabel()
        updateVipButton()
        updateGenderImageView()
        updatePurchaseButton()
        AdStrategy().removeBottomBannerAd(from: self)

    }
}

extension UserCenterViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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

    func didDismissPopUpViewWithoutSave(_ type: PopUpType) {
        
        self.engine.saveSetting()
        self.engine.notifyAllUIObservers()
    
    }
    
    func didSaveAndDismiss(_ type: PopUpType) {

        switch type {
        case .customUserInformationPopUp:
            
            let dataFromPopUp = (AppEngine.shared.storedDataFromPopUpView as? [String]) ?? ["没有名字", Gender.secret.rawValue]
            self.engine.currentUser.name = dataFromPopUp.first!
            self.engine.currentUser.gender = Gender(rawValue: dataFromPopUp.last!) ?? Gender.secret
            self.engine.saveUser()
        case .notificationTimePopUp:
            
            if let notificationTime = self.engine.storedDataFromPopUpView as? Array<CustomTime> {
                self.engine.userSetting.notificationTime = notificationTime
                self.engine.saveSetting()
                self.engine.scheduleNotification()
            }
        default:
            break
        }
        
        self.engine.saveSetting()
        Vibrator.vibrate(withNotificationType: .success)
        
        DispatchQueue.main.async {
            self.engine.notifyAllUIObservers()
        }
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

    }
    
}

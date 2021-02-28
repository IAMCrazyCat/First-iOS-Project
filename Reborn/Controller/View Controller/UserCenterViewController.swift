//
//  UserCenterViewController.swift
//  Reborn
//
//  Created by Christian Liu on 6/1/21.
//

import UIKit

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
    @IBOutlet weak var myKeysButton: UIButton!
    @IBOutlet weak var themeColorButton: UIButton!
    @IBOutlet weak var lightAndDarkModeButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var restorePurchaseButton: UIButton!
    @IBOutlet weak var instructionButton: UIButton!
    
    var scrollViewTopOffset: CGFloat = 0
    var scrollViewLastOffset: CGFloat = 0
    var setting: SystemSetting = SystemSetting.shared
    let engine: AppEngine = AppEngine.shared
    
    var settingButtons: Array<UIButton> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppEngine.shared.register(observer: self)
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
        
        //purchaseButton.setCornerRadius()
        settingButtons.append(purchaseButton)
        settingButtons.append(notificationButton)
        settingButtons.append(myKeysButton)
        settingButtons.append(themeColorButton)
        settingButtons.append(lightAndDarkModeButton)
        settingButtons.append(reviewButton)
        settingButtons.append(feedbackButton)
        settingButtons.append(shareButton)
        settingButtons.append(restorePurchaseButton)
        settingButtons.append(instructionButton)
        
        
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
    
 
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        self.showBottom(.customThemeColor)
    }
    
    func setButtonsAppearence() {
        self.themeColorButton.tintColor = AppEngine.shared.userSetting.themeColor
        for button in self.settingButtons {
            button.setBackgroundColor(.systemGray3, for: .highlighted)
            button.layer.cornerRadius = self.setting.itemCardCornerRadius - 5
        }
    }
    
    func updateNavigationBar() {
        navigationController?.navigationBar.removeBorder()
        navigationController?.navigationBar.barTintColor = engine.userSetting.themeColorAndBlack
    }
    
}

extension UserCenterViewController: Observer {
    func updateUI() {
        updateNavigationBar()
        setButtonsAppearence()
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

        self.dismiss(animated: true)
    }
}

extension UserCenterViewController: PopUpViewDelegate, UIScrollViewDelegate {
    // Delegate extension
    func willDismissView() {
        
    }

    func didDismissPopUpViewWithoutSave() {

    }
    
    func didSaveAndDismissPopUpView(type: PopUpType) {
        
    }
    
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
                navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationBar!.tintColor.withAlphaComponent(0)]
                navigationBar!.layoutIfNeeded()
            })
            
        } else {
            
            UIView.animate(withDuration: 0.2, animations: {
                navigationBar!.barTintColor = self.engine.userSetting.themeColorAndBlack
                navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationBar!.tintColor.withAlphaComponent(1)]
                navigationBar!.layoutIfNeeded()
            })
            
        }
    }
    
}

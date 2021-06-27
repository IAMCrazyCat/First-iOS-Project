//
//  PurchaseViewController.swift
//  Reborn
//
//  Created by Christian Liu on 6/3/21.
//

import UIKit

class PurchaseViewController: UIViewController {

    @IBOutlet weak var itemLimitLabel: UILabel!
    
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var middleScrollView: UIScrollView!
    @IBOutlet var middleContentView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var shadowCoverView: UIView!
    @IBOutlet var middleContentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var purchaseButton: UIButton!
    @IBOutlet var functionNumberButtons: [UIButton]!
    @IBOutlet var functionViews: [UIView]!
    
    @IBOutlet weak var restorePurchaseButton: UIButton!
    @IBOutlet var monthSubscriptionButton: UIButton!
    @IBOutlet var yearSubscriptionButton: UIButton!
    @IBOutlet var permanentSubscriptionButton: UIButton!
    
    @IBOutlet var subscriptionButtons: [UIButton]!
    @IBOutlet var textView: UITextView!
    
    
    @IBOutlet weak var oneMonthPrice: UILabel!
    @IBOutlet weak var oneDayOfOneMonthPrice: UILabel!
    @IBOutlet weak var oneYearPrice: UILabel!
    @IBOutlet weak var oneDayOfOneYearPrice: UILabel!
    @IBOutlet weak var permanentPrice: UILabel!
    
    var selectedSubscriptionButton: UIButton!
    
    var lastViewController: UIViewController?
    let engine: AppEngine = AppEngine.shared
    var selectedPurchaseType: PurchaseType = .oneMonth
    var purchasedType: PurchaseType = .none
    var loadingFailed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarView.contentMode = .scaleAspectFill
        itemLimitLabel.text = "解锁最多\(SystemSetting.shared.nonVipUserMaxItems)个习惯创建的限制"
        inilializeSubscriptionButtons()
        updateUI()
        restorePurchaseButton.setTitleColor(AppEngine.shared.userSetting.smartVisibleThemeColor, for: .normal)
        bottomView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        bottomView.layer.shadowOffset =  CGSize(width: 0, height: -2)
        bottomView.layer.shadowOpacity = 0.4
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowPath = UIBezierPath(rect: bottomView.bounds).cgPath
        bottomView.layer.masksToBounds = false
        shadowCoverView.layer.zPosition = 2
        
        textView.delegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
      
        
        avatarView.setCornerRadius()
        purchaseButton.setCornerRadius()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        middleScrollView.flashScrollIndicators()
        if self.loadingFailed {
            SystemAlert.present("加载商品失败", and: "请重新尝试", from: self, action1: UIAlertAction(title: "取消", style: .cancel, handler: nil), action2: UIAlertAction(title: "重新加载", style: .default, handler: { _ in self.updateUI() }), completion: nil)
            self.loadingFailed = false
        }
    }
   
    @IBAction func restorePurchaseButtonPressed(_ sender: UIButton) {
        restoreApp()
        
    }
    
    @IBAction func subscriptionButtonSelected(_ sender: UIButton) {
        Vibrator.vibrate(withImpactLevel: .light)
        for button in self.subscriptionButtons {
            button.isSelected = false
        }
        
        self.selectedSubscriptionButton = sender
        if self.selectedSubscriptionButton == self.monthSubscriptionButton {
            self.selectedPurchaseType = .oneMonth
        } else if self.selectedSubscriptionButton == self.yearSubscriptionButton {
            self.selectedPurchaseType = .oneYear
        } else if self.selectedSubscriptionButton == self.permanentSubscriptionButton {
            self.selectedPurchaseType = .permanent
        }

        self.updateUI()
    }
    
    
    
    @IBAction func purchaseButtonPressed(_ sender: UIButton) {
        Vibrator.vibrate(withImpactLevel: .medium)
        LoadingAnimation.add(to: self.view, withRespondingTime: 60, proportionallyOnYPosition: 0.4)
        InAppPurchaseManager.shared.add(self)
        InAppPurchaseManager.shared.purchase(selectedPurchaseType)
    }
    
    func restoreApp() {
        
        if engine.currentUser.isVip {
            SystemAlert.present("恢复失败", and: "您已经在使用高级版，无需恢复", from: self)
        } else {
            LoadingAnimation.add(to: self.view, withRespondingTime: 15, proportionallyOnYPosition: 0.4, timeOutAlertTitle: "恢复失败", timeOutAlertBody: "操作超时，请稍后再试")
            InAppPurchaseManager.shared.add(self)
            InAppPurchaseManager.shared.restorePurchase()
        }
       
        
        
    }
    
    
    func inilializeSubscriptionButtons() {
        let userPurchasedType: PurchaseType = AppEngine.shared.currentUser.purchasedType
        self.purchasedType = userPurchasedType
        switch userPurchasedType {
        case .oneMonth:
            self.selectedPurchaseType = userPurchasedType
            self.selectedSubscriptionButton = self.monthSubscriptionButton
//            self.yearSubscriptionButton.alpha = 0.5
//            self.yearSubscriptionButton.isUserInteractionEnabled = false
            self.permanentSubscriptionButton.alpha = 0.5
            self.permanentSubscriptionButton.isUserInteractionEnabled = false
            
        case .oneYear:
            self.selectedPurchaseType = userPurchasedType
            self.selectedSubscriptionButton = self.yearSubscriptionButton
            self.monthSubscriptionButton.alpha = 0.5
            self.monthSubscriptionButton.isUserInteractionEnabled = false
            self.permanentSubscriptionButton.alpha = 0.5
            self.permanentSubscriptionButton.isUserInteractionEnabled = false
        case .permanent:
            self.selectedPurchaseType = userPurchasedType
            self.selectedSubscriptionButton = self.permanentSubscriptionButton
            self.monthSubscriptionButton.alpha = 0.5
            self.monthSubscriptionButton.isUserInteractionEnabled = false
            self.yearSubscriptionButton.alpha = 0.5
            self.yearSubscriptionButton.isUserInteractionEnabled = false
        default:
            self.selectedSubscriptionButton = monthSubscriptionButton
        }
        
    }
    
    func updateInstructionView() {
        
        
        switch self.purchasedType {
        case .oneMonth, .oneYear:
            let instructionText = NSMutableAttributedString(string: "购买须知：您已经订阅，如想购买永久方案，请先在系统的订阅管理中取消现在订阅，了解如何取消订阅")
            instructionText.addAttribute(NSAttributedString.Key.foregroundColor, value: SystemSetting.shared.smartLabelGrayColor, range: NSRange(location: 0, length: 38))
            instructionText.addAttribute(.link, value: "https://support.apple.com/zh-cn/HT202039", range: NSRange(location: 38, length: 8))
            
            textView.attributedText = instructionText
            textView.linkTextAttributes = [
                .foregroundColor: AppEngine.shared.userSetting.smartVisibleThemeColor.withAlphaComponent(0.7)
            ]
            
        case .permanent:
            let instructionText = NSMutableAttributedString(string: "购买须知：您是已经是永久会员")
            instructionText.addAttribute(NSAttributedString.Key.foregroundColor, value: SystemSetting.shared.smartLabelGrayColor, range: NSRange(location: 0, length: 14))
            
            textView.attributedText = instructionText
            textView.linkTextAttributes = [
                .foregroundColor: AppEngine.shared.userSetting.smartVisibleThemeColor.withAlphaComponent(0.7)
            ]
        default:
            let instructionText = NSMutableAttributedString(string: "购买须知：一月期和一年期会员属于订阅型会员，订阅到期后会自动续费，您可以随时在系统的订阅管理中取消，了解如何取消订阅")
            instructionText.addAttribute(NSAttributedString.Key.foregroundColor, value: SystemSetting.shared.smartLabelGrayColor, range: NSRange(location: 0, length: 50))
            instructionText.addAttribute(.link, value: "https://support.apple.com/zh-cn/HT202039", range: NSRange(location: 50, length: 8))
            
            textView.attributedText = instructionText
            textView.linkTextAttributes = [
                .foregroundColor: AppEngine.shared.userSetting.smartVisibleThemeColor.withAlphaComponent(0.7)
            ]
        }

       
        
    }
    
    
    func updateSubscriptionButtons() {
        
        for button in self.subscriptionButtons {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 2
           
            button.setBackgroundColor(self.engine.userSetting.whiteAndBlackContent, for: .normal)
            button.setTitleColor(self.engine.userSetting.smartVisibleThemeColor, for: .normal)
            button.tintColor = .clear

            if button == self.selectedSubscriptionButton {
                button.isSelected = true
                button.layer.borderColor = self.engine.userSetting.themeColor.uiColor.cgColor
            } else {
                button.isSelected = false
                button.layer.borderColor = self.engine.userSetting.themeColor.uiColor.withAlphaComponent(0.1).cgColor
            }
        }
        
        
        
    }
    
    func updateVIPFouctionViews() {
        
        for view in functionViews {
            for subview in view.subviews {
                if let button = subview as? UIButton {
                    button.proportionallySetSizeWithScreen()
                    button.setCornerRadius()
                }
            
            }
        }
    }

    func updateUserAvatar() {
        avatarView.image = engine.currentUser.getAvatarImage()
    }
    
    func updateAllButtons() {
        for button in functionNumberButtons {
            button.setSmartColor()
        }
        
        
    }
    
    func updatePurchaseButton() {
        purchaseButton.setSmartColor()
//        
//        if purchasedType != .none {
//            purchaseButton.isUserInteractionEnabled = false
//            UIView.animate(withDuration: 0.3, animations: {
//                self.purchaseButton.alpha = 0
//            })
//        } else {
//            purchaseButton.isUserInteractionEnabled = true
//            UIView.animate(withDuration: 0.3, animations: {
//                self.purchaseButton.alpha = 1
//            })
//        }
    }
   
    func updatePrice() {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol ?? ""
        //let currencySymbol = InAppPurchaseManager.shared.getLocalCurrencySymbolOf(.permanent) ?? locale.currencySymbol ?? ""
        let oneMonthPrice = InAppPurchaseManager.shared.getPriceOf(.oneMonth)
        let oneYearPrice = InAppPurchaseManager.shared.getPriceOf(.oneYear)
        let permanentPrice = InAppPurchaseManager.shared.getPriceOf(.permanent)
        let defaultString = currencySymbol + " ?"

        self.oneMonthPrice.text = oneMonthPrice != nil ? "\(currencySymbol) \(oneMonthPrice!.round(toPlaces: 1))" : defaultString
        self.oneYearPrice.text = oneYearPrice != nil ? "\(currencySymbol) \(oneYearPrice!.round(toPlaces: 1))" : defaultString
        self.permanentPrice.text = permanentPrice != nil ? "\(currencySymbol) \(permanentPrice!.round(toPlaces: 1))" : defaultString
        self.oneDayOfOneMonthPrice.text = oneMonthPrice != nil ? "\(currencySymbol)\((oneMonthPrice! / 30).round(toPlaces: 2)) / 天" : defaultString + " / 天"
        self.oneDayOfOneYearPrice.text = oneYearPrice != nil ? "\(currencySymbol) \((oneYearPrice! / 365).round(toPlaces: 2)) / 天" : defaultString + " / 天"


        if oneMonthPrice == nil && oneYearPrice == nil && permanentPrice == nil {
            self.loadingFailed = true
        }

    }

}

extension PurchaseViewController: UIObserver {
    func updateUI() {
        updatePrice()
        updateSubscriptionButtons()
        updatePurchaseButton()
        updateInstructionView()
        updateVIPFouctionViews()
        updateUserAvatar()
        updateAllButtons()
        
    }
}

extension PurchaseViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            UIApplication.shared.open(URL)
            return false
    }
}

extension PurchaseViewController: InAppPurchaseObserver {
    func puchaseSuccessed() {
        
        LoadingAnimation.remove()
        self.dismiss(animated: true) {
            
            let userCenter = self.lastViewController as? UserCenterViewController
            userCenter?.showVipIcon()
            let currentVC = UIApplication.shared.getCurrentViewController()
            currentVC != nil ? SystemAlert.present("购买成功", and: "所有内容已解锁", from: currentVC!) : ()
            
        }
        
    }
    
    func puchaseFailed() {
        SystemAlert.present("购买失败", and: "请重新尝试，如有疑问请在个人中心发送反馈邮件", from: self)
        LoadingAnimation.remove()
    }
    
    
}

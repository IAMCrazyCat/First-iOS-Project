//
//  AppViewController.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var horizentalScrollView: UIScrollView!
    @IBOutlet weak var overallProgressView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var itemsTitleLabel: UILabel!
    @IBOutlet weak var persistingItemsViewPromptLabel: UILabel!
    @IBOutlet weak var quittingItemsViewPromptLabel: UILabel!
    @IBOutlet weak var horizentalContentLeftView: UIView!
    @IBOutlet weak var horizentalContentRightView: UIView!
    @IBOutlet var addNewItemButton: UIButton!
    @IBOutlet var customNavigationBar: UIView!
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var spaceViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var todayProgressLabel: UILabel!
    
    static var view: UIView!
    
    var setting = SystemSetting.shared
    
    var scrollViewTopOffset: CGFloat = 0
    var scrollViewLastOffsetY: CGFloat = 0
    let date = Date()
    let dateFormatter = DateFormatter()
    let engine = AppEngine.shared
    var keyboardFrame: CGRect? = nil
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        engine.notifyAllObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        engine.register(observer: self)
        persistingItemsViewPromptLabel.sizeToFit()
        quittingItemsViewPromptLabel.sizeToFit()

        horizentalContentLeftView.layoutIfNeeded()
        horizentalContentRightView.layoutIfNeeded()
        
        customNavigationBar.layer.cornerRadius = setting.customNavigationBarCornerRadius
        customNavigationBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        overallProgressView.layer.cornerRadius = customNavigationBar.layer.cornerRadius
        overallProgressView.layer.maskedCorners = customNavigationBar.layer.maskedCorners
        overallProgressView.layer.masksToBounds = true
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.black
        
        scrollViewTopOffset = overallProgressView.frame.maxY// +
        //verticalScrollView.setContentOffset(CGPoint(x: 0, y: self.customNavigationBar.frame.height), animated: false)
        verticalScrollView.delegate = self // activate delegate
        verticalScrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        verticalScrollView.tag = setting.homeViewVerticalScrollViewTag

        horizentalScrollView.delegate = self
        horizentalScrollView.tag = setting.homeViewHorizentalScrollViewTag
        
        dateFormatter.locale = Locale(identifier: "zh")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM EEEE")
        updateUI()
        
        
        
        //sendNotification()
    }
    
    func sendNotification() {
        let userNotificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        // Add the content to the notification content
        notificationContent.title = "我爱你"
        notificationContent.body = "快回来吧"
        notificationContent.badge = NSNumber(value: 3)

        // Add an attachment to the notification content
        if let url = Bundle.main.url(forResource: "dune",
                                        withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                                url: url,
                                                                options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification", content: notificationContent, trigger: trigger)
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
  
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        // make sure that the overall progress is not coverd by custom navigation bar
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        self.spaceViewHeightConstraint.constant = self.customNavigationBar.frame.height - statusBarHeight
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
   
    var timer: Timer?
    var currentTransitionValue = 0.0
   
    @IBAction func addNewItemButtonPressed(_ sender: UIButton) {
        
        self.engine.register(observer: self)
        self.performSegue(withIdentifier: "GoToNewItemView", sender: self)
    }
    

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        if let destinationViewController = segue.destination as? ItemDetailViewController, segue.identifier == "GoToItemDetailView" {
            
            print("GoToItemDetailView Segue performed in HomeViewController")
            let item = self.engine.currentUser.items[(sender as? UIButton)?.tag ?? 0]
            destinationViewController.item = item
            destinationViewController.lastViewController = self
            self.engine.register(observer: destinationViewController)
            
        } else if let destinationViewController = segue.destination as? CalendarViewController, segue.identifier == "EmbeddedCalendarContainer" {
            
            let item = self.engine.currentUser.items[(sender as? UIButton)?.tag ?? 0]
            destinationViewController.item = item
            
        } else if let destinationViewController = segue.destination as? NewItemViewController, segue.identifier == "GoToNewItemView" {
            
            destinationViewController.lastViewController = self
            destinationViewController.strategy = AddingItemStrategy(newItemViewController: destinationViewController)
        }
        
    }
    
   
    
    func removeAllItemCards() {
        
        for subView in horizentalContentLeftView.subviews {
            if subView.accessibilityIdentifier == setting.itemCardIdentifier {

                subView.removeFromSuperview()
            }
            
        }
        
        for subView in horizentalContentRightView.subviews {
            if subView.accessibilityIdentifier == setting.itemCardIdentifier {
                subView.removeFromSuperview()
            }
        }
        
    }
    

    
    func firstAccessIntialize() {
        verticalScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        verticalScrollView.setContentOffset(CGPoint(x: 0, y: scrollViewTopOffset), animated: true)
        self.horizentalScrollView.setContentOffset(CGPoint(x: self.overallProgressView.frame.width, y: 0), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
            self.horizentalScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    

    func updateItemCards() {

        removeAllItemCards()
        var persistingCordinateY: CGFloat = 0
        var quittingCordinateY: CGFloat = 0
        
        
        let items = self.engine.currentUser.items
            var tag: Int = self.engine.currentUser.items.count - 1
            if items.count > 0 {
                
                
            for itemIndex in (0...items.count - 1).reversed() {
                
                let item = items[itemIndex]
                
              
                if item.type == .persisting {
        
                    self.persistingItemsViewPromptLabel.isHidden = true
                    let builder = ItemCardViewBuilder(item: item, frame: CGRect(x: 0, y: persistingCordinateY, width: self.horizentalContentLeftView.frame.width, height: self.setting.itemCardHeight), punchInButtonTag: tag, isInteractable: true)
                    let newItemCard = builder.buildView()
                    
                    let heightConstraintIndex = self.contentView.constraints.count - 1
                    let tabBarHeight: CGFloat = 200
                    self.horizentalContentLeftView.addSubview(newItemCard)
                    
                    let newConstraint = self.itemsTitleLabel.frame.origin.y + tabBarHeight + persistingCordinateY
                    if newConstraint > self.contentView.constraints[heightConstraintIndex].constant {
                        self.contentView.constraints[heightConstraintIndex].constant = newConstraint // update height constraint (height is at the last index of constraints array)
                    }
             
                    self.horizentalContentLeftView.layoutIfNeeded()
                    persistingCordinateY += setting.itemCardHeight + setting.itemCardGap
                    
                } else if item.type == .quitting {
                    
                    self.quittingItemsViewPromptLabel.isHidden = true
            
                    let builder = ItemCardViewBuilder(item: item, frame: CGRect(x: 0, y: quittingCordinateY, width: self.horizentalContentRightView.frame.width, height: self.setting.itemCardHeight), punchInButtonTag: tag, isInteractable: true)
                    let newItemCard = builder.buildView()
                    
                    let heightConstraintIndex = self.contentView.constraints.count - 1
                    let tabBarHeight: CGFloat = 200
                    self.horizentalContentRightView.addSubview(newItemCard)
                    
                    let newConstraint = self.itemsTitleLabel.frame.origin.y + tabBarHeight + quittingCordinateY
                    if newConstraint > self.contentView.constraints[heightConstraintIndex].constant {
                        self.contentView.constraints[heightConstraintIndex].constant = newConstraint // update height constraint (height is at the last index of constraints array)
                    }
             
                    self.horizentalContentLeftView.layoutIfNeeded()
                    quittingCordinateY += setting.itemCardHeight + setting.itemCardGap
                }
                
                
                
                tag -= 1
      
            }
            
        } else {
            
            self.persistingItemsViewPromptLabel.isHidden = false
            self.quittingItemsViewPromptLabel.isHidden = false
        }
        
    }
    
    func updateNavigationView() {
        
        self.customNavigationBar.backgroundColor = engine.userSetting.themeColorAndBlack
        self.spaceView.backgroundColor = engine.userSetting.themeColorAndBlack
        self.todayProgressLabel.text = "今日打卡: \(self.engine.getTodayProgress())"
        self.todayProgressLabel.layer.zPosition = 3
        
        let circleRadius: CGFloat = 40
        var builder = OverAllProgressViewBuilder(avatarImage: self.engine.currentUser.getAvatarImage(), progress: self.engine.getOverAllProgress(), frame: CGRect(x: 15, y: 0, width: circleRadius, height: circleRadius))
        let circleView = builder.buildView()
        
        circleView.center.y = self.addNewItemButton.center.y
        circleView.accessibilityIdentifier = "SmallProgressCircle"
        self.customNavigationBar.addSubview(circleView)
        self.overallProgressView.removeAllSubviews()
        
        self.overallProgressView.layoutIfNeeded()
        builder = OverAllProgressViewBuilder(avatarImage: self.engine.currentUser.getAvatarImage(), progress: self.engine.getOverAllProgress(), frame: self.overallProgressView.bounds)
        let overAllProgressView = builder.buildView()
        overAllProgressView.accessibilityIdentifier = "OverAllProgressView"
        self.overallProgressView.addSubview(overAllProgressView)
        updateOverAllProgressView(scrollView: self.verticalScrollView, animated: false)
        
    
    }
    
    
        
    func updateOverAllProgressView(scrollView: UIScrollView, animated: Bool) {
        
        let animationSpeed: TimeInterval = animated ? 0.3 : 0
        
        if scrollView.contentOffset.y <= 0 { // make sure that view background color will change when scrolling
            self.view.backgroundColor = AppEngine.shared.userSetting.themeColorAndBlack
        } else {
            self.view.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
        }

        guard let overallProgressInsideView = self.overallProgressView.subviews.first else { return }

        for subview in overallProgressInsideView.subviews {

            if subview.accessibilityIdentifier == "ProgressCircleView" { // for only progress circleview

                if scrollView.contentOffset.y > subview.frame.origin.y + subview.frame.height / 1.5  {

                    UIView.animate(withDuration: animationSpeed, animations: {
                        subview.alpha = 0
                        self.todayProgressLabel.alpha = 0
                        let smallCircleView = self.customNavigationBar.getSubviewByIdentifier(idenifier: "SmallProgressCircle")?.subviews.first
                        smallCircleView?.alpha = 1
                    })

                } else {
                    UIView.animate(withDuration: animationSpeed, animations: {
                        subview.alpha = 1
                        self.todayProgressLabel.alpha = 1
                        let smallCircleView = self.customNavigationBar.getSubviewByIdentifier(idenifier: "SmallProgressCircle")?.subviews.first
                        smallCircleView?.alpha = 0
                    })
                }

            } else {


                if scrollView.contentOffset.y > subview.frame.origin.y + subview.frame.height / 2  { // for other subviews

                    UIView.animate(withDuration: animationSpeed, animations: { // hide subview
                        subview.alpha = 0
                    })

                } else {
                    UIView.animate(withDuration: animationSpeed, animations: { // show subview
                        subview.alpha = 1
                    })
                }

            }


        }


    }

}

extension HomeViewController: Observer {
    func updateUI() {
        
        updateNavigationView()
        updateItemCards()
        
    }
}

extension HomeViewController: PopUpViewDelegate {
    // Delegate extension
    func willDismissView() {
//        if let topView = UIApplication.getTopViewController(), let itemCardFromAddItemCardView = self.engine.itemCardOnTransitionBetweenHomeViewAndAddItemCardView {
//            print(topView)
//
//            topView.view.addSubview(itemCardFromAddItemCardView)
//        }
        
    }
    
    func didDismissPopUpViewWithoutSave() {
        print("AddItemViewDidDismiss")
        self.updateUI()
        
        if self.engine.itemFromController?.type == .persisting {
            self.horizentalScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true) // scroll to left after item added
        } else if self.engine.itemFromController?.type == .quitting {
            self.horizentalScrollView.setContentOffset(CGPoint(x: self.horizentalContentLeftView.frame.width, y: 0), animated: true) // scroll to right after item added
        }
        
    }
    
    func didSaveAndDismissPopUpView(type: PopUpType) {
        
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
     //scrollview delegate functions
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == self.setting.homeViewVerticalScrollViewTag {
            
            

        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == self.setting.homeViewVerticalScrollViewTag {
            print("YES")
            updateOverAllProgressView(scrollView: scrollView, animated: true)

        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

      
    }
    

   
    
    
}

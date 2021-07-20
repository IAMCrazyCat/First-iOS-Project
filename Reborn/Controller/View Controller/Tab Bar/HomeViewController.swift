//
//  AppViewController.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var verticalScrollView: UIScrollView!

    @IBOutlet weak var overallProgressView: UIView!
    @IBOutlet weak var verticalContentView: UIView!
    @IBOutlet weak var itemsTitleLabel: UILabel!

    @IBOutlet weak var itemCardsView: UIView!
    
    @IBOutlet weak var verticalContentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addNewItemButton: UIButton!
    @IBOutlet weak var customNavigationBar: UIView!
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var spaceViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var todayProgressLabel: UILabel!
    
    
    var setting = SystemSetting.shared
    
    var scrollViewTopOffset: CGFloat = 0
    var scrollViewLastOffsetY: CGFloat = 0
    let date = Date()
    let dateFormatter = DateFormatter()
    let engine = AppEngine.shared
    var keyboardFrame: CGRect? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if engine.appLaunchedBefore() {
            DispatchQueue.main.async {
                NewFeaturesManager.shared.presentNewFeaturePopUpIfNeeded()
            }
            
        } else {
            UserDefaults.standard.set(true, forKey: "LaunchedBefore")
            self.engine.loadApp()
        }
        
        
        engine.add(observer: self)
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
        
        
        dateFormatter.locale = Locale(identifier: "zh")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM EEEE")
        AdStrategy().addBottomBannerAd(to: self)
        updateUI()

    }
    
    override func viewDidLayoutSubviews() {
  
        
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 14.0, *) {
            self.updateUI()
        }
    }
    
    
   
    var timer: Timer?
    var currentTransitionValue = 0.0
   
    @IBAction func addNewItemButtonPressed(_ sender: UIButton) {
        
        self.engine.add(observer: self)
        self.performSegue(withIdentifier: "GoToNewItemView", sender: self)
    }
    

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        if let destinationViewController = segue.destination as? ItemDetailViewController, segue.identifier == "GoToItemDetailView" {
            
            print("GoToItemDetailView Segue performed in HomeViewController")
            let item = self.engine.currentUser.items[(sender as? UIButton)?.tag ?? 0]
            destinationViewController.item = item
            destinationViewController.lastViewController = self
            self.engine.add(observer: destinationViewController)
            
        } else if let destinationViewController = segue.destination as? CalendarViewController, segue.identifier == "EmbeddedCalendarContainer" {
            
            let item = self.engine.currentUser.items[(sender as? UIButton)?.tag ?? 0]
            destinationViewController.item = item
            
        } else if let destinationViewController = segue.destination as? NewItemViewController, segue.identifier == "GoToNewItemView" {
            
            destinationViewController.lastViewController = self
            destinationViewController.strategy = AddingItemStrategy(newItemViewController: destinationViewController)
        }
        
    }
    

    func updateItemCardsView() {
        
        if ThreadsManager.shared.userIsLoading {
            TemporaryCircleLoadingAnimation.add(to: self.itemCardsView, withRespondingTime: 10)
        } else {
            self.view.layoutIfNeeded()
            self.itemCardsView.renderItemCards(withCondition: .inProgress, animated: false)
        }
        
    }
    
    func updateNavigationView() {
        
        self.overallProgressView.removeAllSubviews()
        self.customNavigationBar.removeSubviewBy(idenifier: "SmallProgressCircle")
        self.customNavigationBar.backgroundColor = self.engine.userSetting.themeColorAndBlackContent//.withAlphaComponent(0)
        
        self.addNewItemButton.tintColor = self.engine.userSetting.smartLabelColorAndWhite
        
        self.spaceView.backgroundColor = engine.userSetting.themeColorAndBlackContent
        self.todayProgressLabel.textColor = self.engine.userSetting.smartLabelColorAndWhiteAndThemeColor.brightColor
        self.todayProgressLabel.text = "今日打卡: \(self.engine.currentUser.getNumberOfTodayPunchedInItems())/\(self.engine.currentUser.getNumberOfTodayInProgresItems())"
        self.todayProgressLabel.layer.zPosition = 3
        
        let circleRadius: CGFloat = 40
        var builder = OverAllProgressViewBuilder(avatarImage: self.engine.currentUser.getAvatarImage(), progress: self.engine.currentUser.getOverAllProgress(), frame: CGRect(x: 15, y: 0, width: circleRadius, height: circleRadius))
        let circleView = builder.buildView()
        
        circleView.center.y = self.addNewItemButton.center.y
        circleView.accessibilityIdentifier = "SmallProgressCircle"
        self.customNavigationBar.addSubview(circleView)
        
        self.overallProgressView.layoutIfNeeded()
        builder = OverAllProgressViewBuilder(avatarImage: self.engine.currentUser.getAvatarImage(), progress: self.engine.currentUser.getOverAllProgress(), frame: self.overallProgressView.bounds)
        
        let overAllProgressView = builder.buildView()
        overAllProgressView.accessibilityIdentifier = "OverAllProgressView"
        self.overallProgressView.addSubview(overAllProgressView)
        updateOverAllProgressView(scrollView: self.verticalScrollView, animated: false)
        
    
    }
    
    
        
    func updateOverAllProgressView(scrollView: UIScrollView, animated: Bool) {
        
        let animationSpeed: TimeInterval = animated ? 0.3 : 0
        
        if scrollView.contentOffset.y <= 0 { // make sure that view background color will change when scrolling
            self.view.backgroundColor = AppEngine.shared.userSetting.themeColorAndBlackContent
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
                        let smallCircleView = self.customNavigationBar.getSubviewBy(idenifier: "SmallProgressCircle")?.subviews.first
                        smallCircleView?.alpha = 1
                    })

                } else {
                    UIView.animate(withDuration: animationSpeed, animations: {
                        subview.alpha = 1
                        self.todayProgressLabel.alpha = 1
                        let smallCircleView = self.customNavigationBar.getSubviewBy(idenifier: "SmallProgressCircle")?.subviews.first
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
    
    func updateVerticalContentViewHeight() {
        
        self.view.layoutIfNeeded()
        let defaultHeight = self.view.frame.height + overallProgressView.frame.maxY
        if let lastCardMaxY = self.itemCardsView.subviews.last?.frame.maxY {

            let newHeight = self.itemCardsView.frame.minY + lastCardMaxY + self.setting.contentToScrollViewBottomDistance
            if newHeight > defaultHeight {
                self.verticalContentViewHeightConstraint.constant = newHeight

            } else {
                self.verticalContentViewHeightConstraint.constant = defaultHeight
            }

        } else {
            self.verticalContentViewHeightConstraint.constant = defaultHeight
        }
        

    
    }
    
    func updateAppearance() {
        if AppEngine.shared.userSetting.appAppearanceMode == .lightMode {
            view.window?.overrideUserInterfaceStyle = .light
        } else if AppEngine.shared.userSetting.appAppearanceMode == .darkMode {
            view.window?.overrideUserInterfaceStyle = .dark
        } else {
            view.window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
//    func updateItemCard(for item: Item) {
//        for subview in 
//    }

}

extension HomeViewController: UIObserver {
    func updateUI() {
        
        updateNavigationView()
        updateItemCardsView()
        updateVerticalContentViewHeight()
        updateOverAllProgressView(scrollView: verticalScrollView, animated: true)
        AdStrategy().removeBottomBannerAd(from: self)
        

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
    
    func didDismissPopUpViewWithoutSave(_ type: PopUpType) {
        print("AddItemViewDidDismiss")
        self.updateUI()
        
    
        
    }
    
    func didSaveAndDismiss(_ type: PopUpType) {
        
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
           
            updateOverAllProgressView(scrollView: scrollView, animated: true)

        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

      
    }
    
}

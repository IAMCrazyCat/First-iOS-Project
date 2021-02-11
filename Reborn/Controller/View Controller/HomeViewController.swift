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
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var overallProgressLabel: UILabel!
    @IBOutlet weak var itemsTitleLabel: UILabel!
   
    @IBOutlet weak var persistingItemsViewPromptLabel: UILabel!
    @IBOutlet weak var quittingItemsViewPromptLabel: UILabel!
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var overAllProgressTitleLabel: UILabel!
    @IBOutlet weak var persistingItemsView: UIView!
    @IBOutlet weak var quittingItemsView: UIView!
    

    static var view: UIView!
    
    var setting = SystemStyleSetting.shared
    
    var scrollViewTopOffset: CGFloat = 0
    var scrollViewLastOffsetY: CGFloat = 0
    let date = Date()
    let dateFormatter = DateFormatter()
    let engine = AppEngine.shared
    var keyboardFrame: CGRect? = nil
    var navigationBar: UIView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

       
        persistingItemsViewPromptLabel.sizeToFit()
        quittingItemsViewPromptLabel.sizeToFit()
        
//        persistingItemsView.frame.size.height -= 200
//        quittingItemsView.frame.size.height -= 200
        
        persistingItemsView.layoutIfNeeded()
        quittingItemsView.layoutIfNeeded()
        
        
        overallProgressView.layer.cornerRadius = setting.itemCardCornerRadius
        overallProgressView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        overallProgressView.layoutIfNeeded()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.black
        
        scrollViewTopOffset = overallProgressView.frame.maxY// + (navigationBar?.frame.height ?? 0) + (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        //verticalScrollView.setContentOffset(CGPoint(x: 0, y: scrollViewTopOffset), animated: false)
        
        verticalScrollView.delegate = self // activate delegate
        verticalScrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        verticalScrollView.tag = setting.homeViewVerticalScrollViewTag

        horizentalScrollView.delegate = self
        horizentalScrollView.tag = setting.homeViewHorizentalScrollViewTag
        
        dateFormatter.locale = Locale(identifier: "zh")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM EEEE")
        
        navigationBar = navigationController?.navigationBar
        navigationBar?.frame = CGRect(x: 0, y: 0, width: navigationController!.navigationBar.bounds.width, height: 200)
        if navigationBar != nil {
            navigationBar!.frame.size.height = 200

        }
        engine.loadUser()
        updateUI()
        
        
    }
   
    

    
   
    
    var timer: Timer?
    var currentTransitionValue = 0.0
    
//    func excuteProgressLabelAnimation() {
//
//        let animation:CATransition = CATransition()
//        animation.timingFunction = CAMediaTimingFunction(name:
//            CAMediaTimingFunctionName.easeInEaseOut)
//        animation.type = CATransitionType.fade
//        animation.subtype = CATransitionSubtype.fromTop
//        currentTransitionValue = (circleShapeLayer.presentation()?.value(forKeyPath: "strokeEnd") ?? 0.0) as! Double
//        self.overallProgressLabel.text = "已完成: \(String(format: "%.1f", (self.engine.getOverAllProgress() ?? 0) * 100))%"
//        animation.duration = 0.5
//        self.overallProgressLabel.layer.add(animation, forKey: CATransitionType.fade.rawValue)
//
//    }
//
//    @objc func updateProgressLabel() {
//
//        if currentTransitionValue >= 1 {
//            print("timer Ivalidated")
//            timer?.invalidate()
//            currentTransitionValue = 0
//        }
//
//        currentTransitionValue = (circleShapeLayer.presentation()?.value(forKeyPath: "strokeEnd") ?? 0.0) as! Double
//        print(currentTransitionValue)
//        self.overallProgressLabel.text = "已完成: \(String(format: "%.1f", self.currentTransitionValue * (self.engine.getOverAllProgress() ) * 100))%"
//    }
    
    @objc func itemPunchInButtonPressed(_ sender: UIButton!) {
        
        self.engine.punchInItem(tag: sender.tag)
        self.updateUI()
    }
    
    @objc func itemDetailsButtonPressed(_ sender: UIButton!) {
        print("willGoDetailsView")
        
    
        self.engine.registerObserver(observer: self)

        self.performSegue(withIdentifier: "GoToItemDetailView", sender: sender)
    }
    

    @IBAction func addItemViewController(_ sender: UIBarButtonItem) {
        
        self.engine.registerObserver(observer: self)
        self.performSegue(withIdentifier: "GoToNewItemView", sender: self)
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        if let destinationViewController = segue.destination as? ItemDetailViewController, segue.identifier == "GoToItemDetailView" {
            let item = self.engine.currentUser.items[(sender as? UIButton)?.tag ?? 0]
            destinationViewController.item = item
            self.engine.registerObserver(observer: destinationViewController)
            
        } else if let destinationViewController = segue.destination as? CalendarViewController, segue.identifier == "EmbeddedCalendarContainer" {
            let item = self.engine.currentUser.items[(sender as? UIButton)?.tag ?? 0]
            destinationViewController.item = item
        } else if let destinationViewController = segue.destination as? NewItemViewController, segue.identifier == "GoToNewItemView" {
            
            destinationViewController.UIStrategy = AddingItemStrategy(newItemViewController: destinationViewController)
        }
        
    }
    
   
    
    func removeAllItemCards() {
        
        for subView in persistingItemsView.subviews {
            if subView.accessibilityIdentifier == setting.itemCardIdentifier {

                subView.removeFromSuperview()
            }
            
        }
        
        for subView in quittingItemsView.subviews {
            if subView.accessibilityIdentifier == setting.itemCardIdentifier {
                subView.removeFromSuperview()
            }
        }
        
    }
    
//    func removeOriginalCircle() {
//        for subLayer in overallProgressView.layer.sublayers! {
//            if subLayer is CAShapeLayer {
//                subLayer.removeFromSuperlayer()
//            }
//        }
//    }
    
    func firstAccessIntialize() {
        verticalScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        verticalScrollView.setContentOffset(CGPoint(x: 0, y: scrollViewTopOffset), animated: true)
        self.horizentalScrollView.setContentOffset(CGPoint(x: self.overallProgressView.frame.width, y: 0), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
            self.horizentalScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    
    
    func loadItemCards() {

            
        var persistingCordinateY: CGFloat = 0
        var quittingCordinateY: CGFloat = 0
        
        
        let items = self.engine.currentUser.items
            var tag: Int = self.engine.currentUser.items.count - 1
            if items.count > 0 {
                
                
            for itemIndex in (0...items.count - 1).reversed() {
                
                let item = items[itemIndex]
                
              
                if item.type == .persisting {
                    
                    self.persistingItemsViewPromptLabel.isHidden = true
                    let builder = ItemCardViewBuilder(item: item, width: self.persistingItemsView.frame.width, height: self.setting.itemCardHeight, corninateX: 0, cordinateY: persistingCordinateY, punchInButtonTag: tag, punchInButtonAction: #selector(self.itemPunchInButtonPressed(_:)), detailsButtonAction: #selector(self.itemDetailsButtonPressed(_:)))
                    let newItemCard = builder.buildView()
                    
                    let heightConstraintIndex = self.contentView.constraints.count - 1
                    let tabBarHeight: CGFloat = 200
                    self.persistingItemsView.addSubview(newItemCard)
                    
                    let newConstraint = self.itemsTitleLabel.frame.origin.y + tabBarHeight + persistingCordinateY
                    if newConstraint > self.contentView.constraints[heightConstraintIndex].constant {
                        self.contentView.constraints[heightConstraintIndex].constant = newConstraint // update height constraint (height is at the last index of constraints array)
                    }
             
                    self.persistingItemsView.layoutIfNeeded()
                    persistingCordinateY += setting.itemCardHeight + setting.itemCardGap
                    
                } else if item.type == .quitting {
                    
                    self.quittingItemsViewPromptLabel.isHidden = true
                    let builder = ItemCardViewBuilder(item: item, width: self.quittingItemsView.frame.width, height: self.setting.itemCardHeight, corninateX: 0, cordinateY: quittingCordinateY, punchInButtonTag: tag, punchInButtonAction: #selector(self.itemPunchInButtonPressed(_:)), detailsButtonAction: #selector(self.itemDetailsButtonPressed(_:)))
                    let newItemCard = builder.buildView()
                    
                    let heightConstraintIndex = self.contentView.constraints.count - 1
                    let tabBarHeight: CGFloat = 200
                    self.quittingItemsView.addSubview(newItemCard)
                    
                    let newConstraint = self.itemsTitleLabel.frame.origin.y + tabBarHeight + quittingCordinateY
                    if newConstraint > self.contentView.constraints[heightConstraintIndex].constant {
                        self.contentView.constraints[heightConstraintIndex].constant = newConstraint // update height constraint (height is at the last index of constraints array)
                    }
             
                    self.persistingItemsView.layoutIfNeeded()
                    quittingCordinateY += setting.itemCardHeight + setting.itemCardGap
                }
                
                
                
                tag -= 1
      
            }
            
        } else {
            
            self.persistingItemsViewPromptLabel.isHidden = false
            self.quittingItemsViewPromptLabel.isHidden = false
        }
        
    }
    
    func updateNavigationBar() {
        
        var builder = NavigationViewBuilder(avatarImage: self.engine.currentUser.getAvatarImage(), progress: self.engine.getOverAllProgress(), frame: CGRect(x: 15, y: 0, width: 15, height: 15))
        let circleView = builder.buildView()
        self.navigationBar?.addSubview(circleView)
        
        for subview in overallProgressView.subviews {
            subview.removeFromSuperview()
        }
        
        builder = NavigationViewBuilder(avatarImage: self.engine.currentUser.getAvatarImage(), progress: self.engine.getOverAllProgress(), frame: self.overallProgressView.bounds)
        let navigationView = builder.buildView()
        self.overallProgressView.addSubview(navigationView)
    }
    func updateUI() {
        
        updateNavigationBar()
        removeAllItemCards()
        loadItemCards()
        
    }
    

}

extension HomeViewController: Observer {
    
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
            self.horizentalScrollView.setContentOffset(CGPoint(x: self.persistingItemsView.frame.width, y: 0), animated: true) // scroll to right after item added
        }
        
    }
    
    func didSaveAndDismissPopUpView(type: PopUpType) {
        
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    // scrollview delegate functions
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView.tag == self.setting.homeViewVerticalScrollViewTag {
//            if scrollView.contentOffset.y < self.scrollViewTopOffset / 2 && scrollView.contentOffset.y > 0 { // [0, crollViewTopOffset / 2]
//
//                if scrollView.contentOffset.y > scrollViewLastOffsetY { // scroll up
//                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//                        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
//                    }, completion: nil)
//
//                }
//
//            } else if scrollView.contentOffset.y > self.scrollViewTopOffset / 2 && scrollView.contentOffset.y < self.scrollViewTopOffset { // [crollViewTopOffset / 2, offset]
//
//                if scrollView.contentOffset.y > scrollViewLastOffsetY  { // scroll up
//                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//                        scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollViewTopOffset), animated: false)
//                    }, completion: nil)
//                } else { // scroll down
//                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//                        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
//                    }, completion: nil)
//                }
//            }
//
//            self.scrollViewLastOffsetY = scrollView.contentOffset.y
//
//        }
//    }
//
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == self.setting.homeViewVerticalScrollViewTag {
          
            
            guard let navigationView = self.overallProgressView.subviews.first else { return }

            for subview in navigationView.subviews {
               
                if scrollView.contentOffset.y > subview.frame.origin.y + subview.frame.height / 2  { // 
                    UIView.animate(withDuration: 0.3, animations: {
                        subview.alpha = 0
                    })
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        subview.alpha = 1
                    })
                }
            }
            
            
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

      
    }
    

   
    
    
}

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
    @IBOutlet weak var navigationBarTitleLabel: UILabel!
    @IBOutlet weak var persistingItemsViewPromptLabel: UILabel!
    @IBOutlet weak var quittingItemsViewPromptLabel: UILabel!
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var overAllProgressTitleLabel: UILabel!
    @IBOutlet weak var persistingItemsView: UIView!
    @IBOutlet weak var quittingItemsView: UIView!
    
    public static var shared = HomeViewController()
    static var view: UIView!
    
    var setting = SystemStyleSetting.shared
 
    var overallProgress = 0.0
    
    let circleTrackLayer = CAShapeLayer()
    let circleShapeLayer = CAShapeLayer()
    
    
    
    var scrollViewTopOffset: CGFloat = 0
    var scrollViewLastOffsetY: CGFloat = 0
    let date = Date()
    let dateFormatter = DateFormatter()
    let engine = AppEngine.shared
    var keyboardFrame: CGRect? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        persistingItemsViewPromptLabel.sizeToFit()
        quittingItemsViewPromptLabel.sizeToFit()
        
//        persistingItemsView.frame.size.height -= 200
//        quittingItemsView.frame.size.height -= 200
        
        persistingItemsView.layoutIfNeeded()
        quittingItemsView.layoutIfNeeded()

        overallProgressView.layer.cornerRadius = setting.itemCardCornerRadius
        overallProgressView.setViewShadow()
        overallProgressView.layoutIfNeeded()
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
       
        scrollViewTopOffset = overAllProgressTitleLabel.frame.origin.y - 8
        verticalScrollView.setContentOffset(CGPoint(x: 0, y: scrollViewTopOffset), animated: false)
        
        verticalScrollView.delegate = self // activate delegate
        verticalScrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        verticalScrollView.tag = setting.homeViewVerticalScrollViewTag

        horizentalScrollView.delegate = self
        horizentalScrollView.tag = setting.homeViewHorizentalScrollViewTag
        
        dateFormatter.locale = Locale(identifier: "zh")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM EEEE")
        
        dataLabel.text = dateFormatter.string(from: date)
        
        navigationBarTitleLabel.text = self.navigationItem.title
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.black
        
        engine.loadUser()
        updateUI()
        
        
    }
   
    

    
    func updateProgressCircle() { // Circle progress bar
       
        self.overallProgress = self.engine.getOverAllProgress() ?? 0

        let center = CGPoint(x: overallProgressView.frame.width / 2 , y: overallProgressView.frame.height / 2)
        let circleTrackPath = UIBezierPath(arcCenter: center, radius: 60, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)

        let shapeColor = UserStyleSetting.themeColor?.cgColor
        let trackColor = UserStyleSetting.themeColor?.withAlphaComponent(0.3).cgColor
        let progressWidth: CGFloat = 8

        circleTrackLayer.path = circleTrackPath.cgPath
        circleTrackLayer.strokeColor = trackColor
        circleTrackLayer.lineWidth = progressWidth
        circleTrackLayer.fillColor = UIColor.clear.cgColor
        circleTrackLayer.lineCap = CAShapeLayerLineCap.round
        overallProgressView.layer.addSublayer(circleTrackLayer)
   

        let circleShapePath = UIBezierPath(arcCenter: center, radius: 60, startAngle: -CGFloat.pi / 2, endAngle: CGFloat(self.overallProgress) * 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        
        circleShapeLayer.path = circleShapePath.cgPath
        circleShapeLayer.strokeColor = shapeColor
        circleShapeLayer.lineWidth = progressWidth
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        circleShapeLayer.strokeEnd = 0
        overallProgressView.layer.addSublayer(circleShapeLayer)
        
       
    }
    
    func excuteCircleAnimation() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
        basicAnimation.isRemovedOnCompletion = false
        circleShapeLayer.add(basicAnimation, forKey: "basicAnimation")
     
        
    }
    
    var timer: Timer?
    var currentTransitionValue = 0.0
    
    func excuteProgressLabelAnimation() {

        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgressLabel() {

        if currentTransitionValue >= 1 {
            print("timer Ivalidated")
            timer?.invalidate()
        }
        self.overallProgress = self.engine.getOverAllProgress() ?? 0
        currentTransitionValue = (circleShapeLayer.presentation()?.value(forKeyPath: "strokeEnd") ?? 0.0) as! Double
        self.overallProgressLabel.text = "已完成: \(String(format: "%.1f", self.currentTransitionValue * self.overallProgress * 100))%"
    }

    @IBAction func addItemViewController(_ sender: UIBarButtonItem) {
        self.engine.showAddItemView(controller: self)
    }
    
  
    
    @objc func itemPunchInButtonPressed(_ sender: UIButton!) {

        self.engine.punchInItem(tag: sender.tag)
        updateUI()
    }
    
    @objc func itemDetailButtonPressed(_ sender: UIButton!) {
        self.performSegue(withIdentifier: "goItemDetailView", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        
            
        if let destinationViewController = segue.destination as? ItemDetailViewController, segue.identifier == "goItemDetailView" {
            if let item = self.engine.user?.items[(sender as? UIButton)?.tag ?? 0] {
                destinationViewController.item = item
            }
            
            
        } else if let destinationViewController = segue.destination as? CalendarViewController, segue.identifier == "embeddedCalendarContainer" {
            if let item = self.engine.user?.items[(sender as? UIButton)?.tag ?? 0] {
                destinationViewController.item = item
            }
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
    
    func removeOriginalCircle() {
        for subLayer in overallProgressView.layer.sublayers! {
            if subLayer is CAShapeLayer {
                subLayer.removeFromSuperlayer()
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
    
    func loadUserAvatar() {
        avatarImageView.image = engine.user?.getAvatarImage()
    }
    
    func loadItemCards() {

            
        var persistingCordinateY: CGFloat = 0
        var quittingCordinateY: CGFloat = 0
        
        
        if let items = self.engine.user?.items, self.engine.user != nil {
            var tag: Int = self.engine.user!.items.count - 1
            if items.count > 0 {
                
                
                for itemIndex in (0...items.count - 1).reversed() {
                    
                    let item = items[itemIndex]
                    
                  
                    if item.type == .persisting {
                        
                        self.persistingItemsViewPromptLabel.isHidden = true
                        let builder = ItemCardBuilder(item: item, width: self.persistingItemsView.frame.width, height: self.setting.itemCardHeight, corninateX: 0, cordinateY: persistingCordinateY, punchInButtonTag: tag)
                        let newItemCard = builder.buildItemCardView()
                        
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
                        let builder = ItemCardBuilder(item: item, width: self.quittingItemsView.frame.width, height: self.setting.itemCardHeight, corninateX: 0, cordinateY: quittingCordinateY, punchInButtonTag: tag)
                        let newItemCard = builder.buildItemCardView()
                        
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

    }
    
    func updateUI() {
        
        loadUserAvatar()
        removeOriginalCircle()
        updateProgressCircle()
        excuteCircleAnimation()
        excuteProgressLabelAnimation()
        removeAllItemCards()
        loadItemCards()
        
    }
    

}

extension HomeViewController: AppEngineDelegate, UIScrollViewDelegate {
    // Delegate extension
    func willDismissView() {
//        if let topView = UIApplication.getTopViewController(), let itemCardFromAddItemCardView = self.engine.itemCardOnTransitionBetweenHomeViewAndAddItemCardView {
//            print(topView)
//
//            topView.view.addSubview(itemCardFromAddItemCardView)
//        }
        
    }
    
    func didDismissView() {
        
        if self.engine.itemOnTransitionBetweenHomeViewAndAddItemCardView!.type == .persisting {
            self.updateUI()
            self.horizentalScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true) // scroll to left after item added
        } else if self.engine.itemOnTransitionBetweenHomeViewAndAddItemCardView!.type == .quitting {
            self.updateUI()
            
            self.horizentalScrollView.setContentOffset(CGPoint(x: self.persistingItemsView.frame.width, y: 0), animated: true) // scroll to right after item added
        }
        
    }
    
    func didSaveAndDismissPopUpView(type: PopUpType) {
        
    }
    
    // scrollview delegate functions
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == self.setting.homeViewVerticalScrollViewTag {
            if scrollView.contentOffset.y < self.scrollViewTopOffset / 2 && scrollView.contentOffset.y > 0 { // [0, crollViewTopOffset / 2]
                
                if scrollView.contentOffset.y > scrollViewLastOffsetY { // scroll up
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                    }, completion: nil)
                    
                }
                
            } else if scrollView.contentOffset.y > self.scrollViewTopOffset / 2 && scrollView.contentOffset.y < self.scrollViewTopOffset { // [crollViewTopOffset / 2, offset]
                
                if scrollView.contentOffset.y > scrollViewLastOffsetY  { // scroll up
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                        scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollViewTopOffset), animated: false)
                    }, completion: nil)
                } else { // scroll down
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                    }, completion: nil)
                }
            }
       
            self.scrollViewLastOffsetY = scrollView.contentOffset.y
            
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == self.setting.homeViewVerticalScrollViewTag {
            
            let navigationBar = self.navigationController?.navigationBar
            if scrollView.contentOffset.y < self.scrollViewTopOffset - 10 {

                UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
                    navigationBar!.barTintColor = UIColor.white
                    navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationBar!.tintColor.withAlphaComponent(0)]
                    navigationBar!.layoutIfNeeded()
                })

            } else {

                UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
                    navigationBar!.barTintColor = UserStyleSetting.themeColor
                    navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationBar!.tintColor.withAlphaComponent(1)]
                    navigationBar!.layoutIfNeeded()
                })

            }
        }
       
//        let ratio: CGFloat = scrollView.contentOffset.y / scrollViewTopOffset
//        let r: CGFloat = 255 - (255 - UserStyleSetting.themeColor!.value.red) * ratio
//        let g: CGFloat = 255 - (255 - UserStyleSetting.themeColor!.value.red) * ratio
//        let b: CGFloat = 255 - (255 - UserStyleSetting.themeColor!.value.blue) * ratio
//        let a: CGFloat = UserStyleSetting.themeColor!.value.alpha
//
//        print(UIColor(red: r, green: g, blue: b, alpha: a).value)
//        navigationBar!.barTintColor = UIColor(red: r, green: g, blue: b, alpha: a)
//        navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationBar!.tintColor.withAlphaComponent(ratio)]
//        navigationBar!.layoutIfNeeded()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
//        if scrollView.tag == self.setting.homeViewHorizentalScrollViewTag {
//            self.horizentalScrollView.setContentOffset(CGPoint(x: 0, y: self.horizentalScrollView.frame.width), animated: true)
//        }
      
    }
    

   
    
    
}

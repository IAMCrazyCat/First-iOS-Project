//
//  AppViewController.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var overallProgressView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var overallProgressLabel: UILabel!
    @IBOutlet weak var itemsTitleLabel: UILabel!
    @IBOutlet weak var navigationBarTitleLabel: UILabel!
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var overAllProgressTitleLabel: UILabel!
    @IBOutlet weak var itemCardsView: UIView!
    
    static var view: UIView!
    
    var setting = SystemStyleSetting.shared
 
    var overallProgress = 0.0
    
    let circleTrackLayer = CAShapeLayer()
    let circleShapeLayer = CAShapeLayer()
    
    
    
    var scrollViewTopOffset: CGFloat = 0
    var scrollViewLastOffset: CGFloat = 0
    let date = Date()
    let dateFormatter = DateFormatter()
    let engine = AppEngine.shared
    var keyboardFrame: CGRect? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checkButton.layer.cornerRadius = setting.checkButtonCornerRadius
        verticalScrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        overallProgressView.layer.contents = setting.itemCardBGImage.cgImage
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        
    
        overallProgressView.layoutIfNeeded()
       
        excuteProgressLabelAnimation()
        updateUI()
        
        scrollViewTopOffset = overAllProgressTitleLabel.frame.origin.y - 8
        verticalScrollView.setContentOffset(CGPoint(x: 0, y: scrollViewTopOffset), animated: false)
        verticalScrollView.delegate = self // activate delegate
        
        dateFormatter.locale = Locale(identifier: "zh")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM EEEE")
        dataLabel.text = dateFormatter.string(from: date)
        navigationBarTitleLabel.text = self.navigationItem.title
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.black
        
        print(itemsTitleLabel.frame)
        
        
    }
   
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
        
        let navigationBar = self.navigationController?.navigationBar
        if scrollView.contentOffset.y < self.scrollViewTopOffset - 10 {
            
            UIView.animate(withDuration: 0.2, animations: {
                navigationBar!.barTintColor = UIColor.white
                navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationBar!.tintColor.withAlphaComponent(0)]
                navigationBar!.layoutIfNeeded()
            })
            
        } else {
            
            UIView.animate(withDuration: 0.2, animations: {
                navigationBar!.barTintColor = UserStyleSetting.themeColor
                navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationBar!.tintColor.withAlphaComponent(1)]
                navigationBar!.layoutIfNeeded()
            })
            
        }
    }

    
    func addProgressCircle() { // Circle progress bar
       
        self.overallProgress = self.engine.getOverAllProgress()
        let center = CGPoint(x: overallProgressView.frame.width / 2 , y: overallProgressView.frame.height / 2)
        print(overallProgressView.frame.width)
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

        if currentTransitionValue >= 1 {
            timer?.invalidate()
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)
        }

    }
    
    @objc func timerEvent() {
        self.overallProgress = self.engine.getOverAllProgress()
        currentTransitionValue = (circleShapeLayer.presentation()?.value(forKeyPath: "strokeEnd") ?? 0.0) as! Double
        
        self.overallProgressLabel.text = "已完成: \(String(format: "%.1f", self.currentTransitionValue * self.overallProgress * 100))%"
    }

    @IBAction func addItemViewController(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToAddItemView", sender: self)
    }
    
    func updateVerticalScrollView(newItemCard: UIView, updatedHeight: CGFloat) {
        
        let heightConstraintIndex = self.contentView.constraints.count - 1
        let tabBarHeight: CGFloat = 200
        self.itemCardsView.addSubview(newItemCard)
        
        let newConstraint = self.itemsTitleLabel.frame.origin.y + tabBarHeight +  updatedHeight
        if newConstraint > self.contentView.constraints[heightConstraintIndex].constant {
            self.contentView.constraints[heightConstraintIndex].constant = newConstraint // update height constraint (height is at the last index of constraints array)
        }
 
        self.itemCardsView.layoutIfNeeded()

    }
    
    @objc func punchInButtonPressed(_ sender: UIButton!) {
        
        self.engine.punchInItem(tag: sender.tag)
        updateUI()
    }
    
    func removeAllItemCards() {
        
        for subView in itemCardsView.subviews {
            subView.removeFromSuperview()
        }
    }
    
    func removeOriginalCircle() {
        for subLayer in overallProgressView.layer.sublayers! {
            if subLayer is CAShapeLayer {
                subLayer.removeFromSuperlayer()
            }
        }
    }
    
    func updateUI() {
        
        removeOriginalCircle()
        addProgressCircle()
        excuteCircleAnimation()
        excuteProgressLabelAnimation()
        
        removeAllItemCards()
        engine.addItemCardsToHomeView(controller: self)
       
    }
    

}

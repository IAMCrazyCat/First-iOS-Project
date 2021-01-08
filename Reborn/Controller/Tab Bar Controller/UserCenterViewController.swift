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
    @IBOutlet weak var punchInView: UIView!
    @IBOutlet weak var timeMachineView: UIView!
    @IBOutlet weak var appSettingView: UIView!
    
    @IBOutlet weak var appVersionLabelButton: UIButton!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    
    
    var scrollViewTopOffset: CGFloat = 0
    var scrollViewLastOffset: CGFloat = 0
    var setting: SystemStyleSetting = SystemStyleSetting.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        purchaseView.layer.cornerRadius = setting.itemCardCornerRadius - 5
        punchInView.layer.cornerRadius = setting.itemCardCornerRadius - 5
        timeMachineView.layer.cornerRadius = setting.itemCardCornerRadius - 5
        appSettingView.layer.cornerRadius = setting.itemCardCornerRadius
        
        purchaseView.setViewShadow()
        punchInView.setViewShadow()
        timeMachineView.setViewShadow()
        appSettingView.setViewShadow()
        
        verticalScrollView.delegate = self
        scrollViewTopOffset = avaterView.frame.origin.y - 10
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Error"
        appVersionLabelButton.setTitle("  v\(appVersion)", for: .normal)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserCenterViewController: AppEngineDelegate, UIScrollViewDelegate {
    // Delegate extension
    func willDismissView() {
        
    }

    func didDismissView() {

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
    
}

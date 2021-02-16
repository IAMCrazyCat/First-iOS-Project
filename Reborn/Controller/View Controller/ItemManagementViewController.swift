//
//  ItemManagementViewController.swift
//  Reborn
//
//  Created by Christian Liu on 16/2/21.
//

import UIKit

class ItemManagementViewController: UIViewController {
    
    @IBOutlet weak var optionBar: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var horizentalScrollView: UIScrollView!
    
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let engine: AppEngine = AppEngine.shared
    var selectedButton: UIButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionBar.layer.cornerRadius = setting.itemCardCornerRadius
        optionBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        optionBar.layer.zPosition = -2
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UserStyleSetting.themeColor], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        //segmentedControl.setSegmentStyle(normalColor: UIColor.white, selectedColor: UserStyleSetting.themeColor, dividerColor: UIColor.clear)
    }

    @IBAction func optionButtonPressed(_ sender: AnyObject) {
        
        horizentalScrollView.setContentOffset(CGPoint(x: CGFloat(horizentalScrollView.frame.width) * CGFloat(self.segmentedControl.selectedSegmentIndex), y: 0), animated: true)
        updateUI()
    }
    
    func updateSliderPosition() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
        
            //self.optionBarSlider.frame = self.selectedButton.frame
        }) { _ in
//            self.selectedButton.setTitleColor(.black, for: .normal)
        }
    }
    
}

extension ItemManagementViewController: Observer {
    func updateUI() {
        
        
        
        updateSliderPosition()
        
    }
    
}

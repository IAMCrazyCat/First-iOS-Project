//
//  ItemManagementViewController.swift
//  Reborn
//
//  Created by Christian Liu on 16/2/21.
//

import UIKit

class ItemManagementViewController: UIViewController {
    
    @IBOutlet weak var optionBar: UIView!
    @IBOutlet weak var allItemsButton: UIButton!
    @IBOutlet weak var todayItemsButton: UIButton!
    @IBOutlet weak var finishedItemsButton: UIButton!
    @IBOutlet weak var optionBarSlider: UIView!
    @IBOutlet weak var horizentalScrollView: UIScrollView!
    
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let engine: AppEngine = AppEngine.shared
    var selectedButton: UIButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionBar.layer.cornerRadius = setting.itemCardCornerRadius
        optionBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        optionBarSlider.setCornerRadius()
        optionBar.layer.zPosition = -2
        optionBarSlider.layer.zPosition = -1
    }

    @IBAction func optionButtonPressed(_ sender: UIButton) {
        self.selectedButton = sender
        horizentalScrollView.setContentOffset(CGPoint(x: CGFloat(horizentalScrollView.frame.width) * CGFloat(sender.tag - 1), y: 0), animated: true)
        updateUI()
    }
    
    func updateSliderPosition() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
        
            self.optionBarSlider.frame = self.selectedButton.frame
        }) { _ in
            self.selectedButton.setTitleColor(.black, for: .normal)
        }
    }
    
}

extension ItemManagementViewController: Observer {
    func updateUI() {
        updateSliderPosition()
        
    }
    
}

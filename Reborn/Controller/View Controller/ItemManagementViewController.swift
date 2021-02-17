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
    @IBOutlet weak var firstVerticalContentView: UIView!
    @IBOutlet weak var secondVerticalContentView: UIView!
    @IBOutlet weak var thirdVerticalContentView: UIView!
    
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
        
        engine.registerObserver(observer: self)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }

    @IBAction func optionButtonPressed(_ sender: AnyObject) {
        
        horizentalScrollView.setContentOffset(CGPoint(x: CGFloat(horizentalScrollView.frame.width) * CGFloat(self.segmentedControl.selectedSegmentIndex), y: 0), animated: true)
        updateUI()
    }
    
    func updateFirstVerticalContentView() {
        firstVerticalContentView.removeAllSubviews()
        firstVerticalContentView.renderItemCards(for: .allItems)
    }
    
    func updateSecondVerticalContentView() {
        secondVerticalContentView.removeAllSubviews()
        secondVerticalContentView.renderItemCards(for: .todayItems)
    }
    
    func updateThirdVerticalContentView() {
        thirdVerticalContentView.removeAllSubviews()
        thirdVerticalContentView.renderItemCards(for: .finishedItems)
    }
    
  
    
}

extension ItemManagementViewController: Observer {
    func updateUI() {
        
        updateFirstVerticalContentView()
        updateSecondVerticalContentView()
        updateThirdVerticalContentView()
    }
    
}

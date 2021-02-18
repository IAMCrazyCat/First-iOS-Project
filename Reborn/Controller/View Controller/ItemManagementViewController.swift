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
    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var verticalContentView: UIView!
    @IBOutlet weak var verticalContentHeightConstraint: NSLayoutConstraint!
    var selectedSegment: ItemState? = nil
    
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

    @IBAction func optionButtonPressed(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.selectedSegment = nil
        case 1:
            self.selectedSegment = .inProgress
        case 2:
            self.selectedSegment = .duringBreak
        case 3:
            self.selectedSegment = .finished
            
        default:
            print("Segement Tag not found")
        }
        print(self.selectedSegment)
        updateUI()
    }
    
    func updateVerticalContentView() {
        verticalContentView.removeAllSubviews()
        verticalContentView.renderItemCards(withConstraint: self.selectedSegment)
      
        if let lastItemCard = verticalContentView.subviews.last, lastItemCard.frame.maxY > self.verticalScrollView.frame.height {
            verticalContentHeightConstraint.constant = lastItemCard.frame.maxY + setting.mainPadding
        } else {
            verticalContentHeightConstraint.constant = verticalScrollView.frame.height + 1
        }
        
        verticalContentView.layoutIfNeeded()
    }
  
    
}

extension ItemManagementViewController: Observer {
    func updateUI() {

        updateVerticalContentView()
    }
    
}

//
//  ItemManagementViewController.swift
//  Reborn
//
//  Created by Christian Liu on 16/2/21.
//

import UIKit
import BetterSegmentedControl
class ItemManagementViewController: UIViewController {
    
    @IBOutlet weak var optionBar: UIView!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var verticalContentView: UIView!
    @IBOutlet weak var verticalContentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionBarContentView: UIView!
    
    var selectedSegment: ItemState? = nil
    var selectedSegmentIndex: Int = 0
    let setting: SystemSetting = SystemSetting.shared
    let engine: AppEngine = AppEngine.shared
    var selectedButton: UIButton = UIButton()
    let segmentTitles: Array<String> = ["全部项目", "今日计划", "今日休息", "已完成"]
    var segmentedControl: BetterSegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine.add(observer: self)
        optionBarContentView.layoutIfNeeded()
    

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        updateUI()
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    @objc func optionButtonPressed(_ sender: BetterSegmentedControl) {
        
        self.selectedSegmentIndex = sender.index
        switch sender.index {
        case 0:
            self.selectedSegment = nil
        case 1:
            self.selectedSegment = .inProgress
        case 2:
            self.selectedSegment = .duringBreak
        case 3:
            self.selectedSegment = .completed

        default:
            print("Segement Tag not found")
        }

        verticalContentView.removeAllSubviews()
        verticalContentView.renderItemCards(withCondition: self.selectedSegment, animated: true)
    }
    
    @IBAction func addNewItemsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToNewItemView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? NewItemViewController, segue.identifier == "GoToNewItemView" {
            
            destinationViewController.lastViewController = self
            destinationViewController.strategy = AddingItemStrategy(newItemViewController: destinationViewController)
        }
    }
    
    func addSegmentedControl() {
        
    }
    
    func updateNavigationBar() {
        navigationController?.navigationBar.removeBorder()
        navigationController?.navigationBar.barTintColor = engine.userSetting.themeColorAndBlack
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: engine.userSetting.smartLabelColorAndThemeColor.brightColor]
        navigationItem.rightBarButtonItem?.tintColor = engine.userSetting.smartLabelColor.brightColor
        navigationItem.leftBarButtonItem?.tintColor = engine.userSetting.smartLabelColorAndThemeColor
    }
    
    func updateOptionBar() {
        self.optionBarContentView.removeAllSubviews()
        self.optionBar.backgroundColor = self.engine.userSetting.themeColorAndBlack
        self.optionBarContentView.backgroundColor = self.optionBar.backgroundColor
        
        var segments: [LabelSegment] = []
        for title in self.segmentTitles {
            let labelSegment = LabelSegment(text: title, normalFont: self.engine.userSetting.smallFont, normalTextColor: self.engine.userSetting.smartLabelColor, selectedFont: self.engine.userSetting.smallFont, selectedTextColor: self.engine.userSetting.themeColorAndSmartLabelColor)
            segments.append(labelSegment)
    
        }
        
        self.segmentedControl = BetterSegmentedControl(frame: optionBarContentView.bounds, segments: segments, options: nil)
        self.segmentedControl.cornerRadius = self.segmentedControl.frame.height / 2
        self.segmentedControl.backgroundColor = .clear
        self.segmentedControl.indicatorViewBackgroundColor = self.engine.userSetting.whiteAndThemColor
        self.segmentedControl.addTarget(self, action: #selector(self.optionButtonPressed(_:)), for: .valueChanged)
       
        self.segmentedControl.setIndex(self.selectedSegmentIndex)

        
        
        optionBarContentView.addSubview(self.segmentedControl)
        self.segmentedControl.cornerRadius = self.segmentedControl.frame.height / 2
        self.segmentedControl.backgroundColor = .clear
        self.segmentedControl.indicatorViewBackgroundColor = self.engine.userSetting.whiteAndThemColor
    }
    
    
    func updateVerticalContentView() {
        verticalContentView.removeAllSubviews()
        verticalContentView.renderItemCards(withCondition: self.selectedSegment, animated: false)
      
        if let lastItemCard = verticalContentView.subviews.last, lastItemCard.frame.maxY > self.verticalScrollView.frame.height {
            verticalContentHeightConstraint.constant = lastItemCard.frame.maxY + setting.contentToScrollViewBottomDistance
        } else {
            verticalContentHeightConstraint.constant = verticalScrollView.frame.height + setting.contentToScrollViewBottomDistance
        }
        
        verticalContentView.layoutIfNeeded()
    }
  
    
}

extension ItemManagementViewController: UIObserver {
    func updateUI() {
        updateNavigationBar()
        updateOptionBar()
        updateVerticalContentView()
    }
    
}

//
//  ItemDetailViewController.swift
//  Reborn
//
//  Created by Christian Liu on 8/1/21.
//

import UIKit

class ItemDetailViewController: UIViewController {


    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var mediumView: UIView!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var verticalContentView: UIView!
    @IBOutlet weak var verticalContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var bottomEditButton: UIButton!
    @IBOutlet weak var bottomShareButton: UIButton!
    
    @IBOutlet weak var finishedDaysLabel: UILabel!
    @IBOutlet weak var targetDaysLabel: UILabel!
    @IBOutlet weak var bestConsecutiveDaysLabel: UILabel!
    @IBOutlet weak var energyProgressLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var nextPunchInDateLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var goBackButton: UINavigationItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var startDateLabel: UILabel!
    
    let setting: SystemSetting = SystemSetting.shared
    let engine: AppEngine = AppEngine.shared
    var item: Item!
    var embeddedCalendarViewController: CalendarViewController? = nil
    var lastViewController: UIViewController? = nil
    var dayCellFrame: CGRect? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine.add(observer: self)
        //topView.layer.cornerRadius = setting.itemCardCornerRadius
        topView.setShadow()
        
        title = "项目详情"
        
        //mediumView.layer.cornerRadius = setting.itemCardCornerRadius
        mediumView.setShadow()

        calendarView.layer.cornerRadius = setting.itemCardCornerRadius
        
        bottomShareButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 40)
        bottomShareButton.proportionallySetSizeWithScreen()
        bottomShareButton.setCornerRadius()
        bottomShareButton.setShadow()
        
        
        bottomEditButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 30, bottom: 12, right: 40)
        bottomEditButton.proportionallySetSizeWithScreen()
        bottomEditButton.setCornerRadius()
        bottomEditButton.setShadow()
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        self.verticalContentViewHeightConstraint.constant = self.bottomEditButton.frame.maxY + self.setting.contentToScrollViewBottomDistance
        self.verticalScrollView.layoutIfNeeded()
        

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    

    
    @IBAction func bottomEidtItemButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToEditItemView", sender: nil)
    }
    
    @IBAction func bottomShareButtonPressed(_ sender: UIButton) {
        Vibrator.vibrate(withImpactLevel: .medium)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "EmbeddedCalendarContainer", let destinationViewController = segue.destination as? CalendarViewController  {
    
            destinationViewController.item = item
            destinationViewController.lastViewController = self
            embeddedCalendarViewController = destinationViewController
  
        } else if segue.identifier == "GoToEditItemView", let destinationViewController = segue.destination as? NewItemViewController {
            
            destinationViewController.originalItemForRecovery = Item(ID: self.item!.ID, name: self.item!.name, days: self.item!.targetDays, frequency: self.item!.frequency, creationDate: self.item!.creationDate, type: self.item!.type, icon: self.item!.icon)
            destinationViewController.item = self.item!
            destinationViewController.lastViewController = self
            destinationViewController.strategy = EditingItemStrategy(newItemViewController: destinationViewController)
            
        } else if segue.identifier == "GoToShareView", let destinationViewController = segue.destination as? ShareViewController {
            destinationViewController.item = self.item!
        }
        
        
    }
    
    func goBackToParentView() {
        navigationController?.popViewController(animated: true)
    }
    
    func updateNavigationBar() {
        navigationController?.navigationBar.barTintColor = engine.userSetting.themeColorAndBlackContent
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: engine.userSetting.smartLabelColorAndWhiteAndThemeColor]
        

        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = engine.userSetting.smartLabelColorAndWhite
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        navigationItem.rightBarButtonItem?.tintColor = engine.userSetting.smartLabelColorAndWhite
        
       
        
       
    }
    
    

    func updateFinishedDaysLabel() {
        self.finishedDaysLabel.text = "\(String(self.item.finishedDays)) 天"
    }
    
    func updateTargetDaysLabel() {
        self.targetDaysLabel.text = "\(String(self.item.targetDays)) 天"
    }
    
    func updateBestConsecutiveDaysLabel() {
        self.bestConsecutiveDaysLabel.text = "\(String(self.item.bestConsecutiveDays)) 天"
    }
    
    func updateEnergyProgressLabel() {
        if item.todayIsAddedEnergy {
            self.energyProgressLabel.textColor = ThemeColor.green.uiColor
            self.energyProgressLabel.text = "新能量+1"
        } else {
            self.energyProgressLabel.text = "\(item.lastEnergyConsecutiveDays) / \(self.engine.currentUser.energyChargingEfficiencyDays)"
        }
        
    }
    
    func updateFrequencyLabel() {
        self.frequencyLabel.text = "\(String(self.item.frequency.dataModel.title))"
    }
    
    func updateNextPunchInDateLabel() {
        let scheduleDate = self.item.scheduleDates
        var nextPunchInDate: CustomDate?
        var index = 0
        print(scheduleDate)
        for date in scheduleDate {
            
        
            if date >= CustomDate.current {
                
                if self.item.isPunchedIn {
                    if index + 1 <= self.item.scheduleDates.count - 1 {
                        nextPunchInDate = self.item.scheduleDates[index + 1]
                    }
                    
                } else {
                    nextPunchInDate = date
                }
                
                break
            }
            
            index += 1
        }
        
        var labelText = ""
        if nextPunchInDate == CustomDate.current {
            
            labelText = "今天"
            
        } else if nextPunchInDate == DateCalculator.calculateDate(withDayDifference: 1, originalDate: CustomDate.current) {
            
            labelText = "明天"
            
        } else {
            
            if nextPunchInDate != nil {
                labelText = "\(nextPunchInDate!.month)月\(nextPunchInDate!.day)日"
            } else {
                labelText = "暂无计划"
            }
           
        }
        
        self.nextPunchInDateLabel.text = labelText
    }
    
    func updateTodayLabel() {
        
        if self.item.punchInDates.contains(CustomDate.current) && self.item.state != .completed  {
            self.todayLabel.textColor = ThemeColor.green.uiColor
            self.todayLabel.text = "已打卡"
        } else if item.state == .completed {
            self.todayLabel.textColor = ThemeColor.green.uiColor
            self.todayLabel.text = "已完成"
        } else if item.state == .duringBreak {
            self.todayLabel.textColor = ThemeColor.green.uiColor
            self.todayLabel.text = "休息中"
        } else {
            self.todayLabel.textColor = ThemeColor.red.uiColor
            self.todayLabel.text = "未打卡"
        }
    }
    
    func updateProgressView() {
        if item != nil {
            self.verticalContentView.layoutIfNeeded()
            let builder = ItemProgressViewBuilder(item: item!, frame: self.progressView.bounds)
            let detailsView = builder.buildView()
            self.progressView.addSubview(detailsView)
            
        }
    }
    
    
    func updateStartDateLabel() {
        if let item = item {
            
            let daysAgo: Int = DateCalculator.calculateDayDifferenceBetween(item.creationDate, and: CustomDate.current)
            
            switch daysAgo {
            case 0: startDateLabel.text = "开始日期: \(item.creationDate.year)年 \(item.creationDate.month)月\(item.creationDate.day)日 (今天)"
            case 1: startDateLabel.text = "开始日期: \(item.creationDate.year)年 \(item.creationDate.month)月\(item.creationDate.day)日 (昨天)"
            default: startDateLabel.text = "开始日期: \(item.creationDate.year)年 \(item.creationDate.month)月\(item.creationDate.day)日 (\(daysAgo)天前)"
             
            }
            
        }
    }
    
    func updateItemIconAndName() {
        iconImageView.image = item.icon.image
        itemNameLabel.text = item.getFullName()
    }
    
    func updateItemData() {
        updateItemIconAndName()
        updateFinishedDaysLabel()
        updateTargetDaysLabel()
        updateBestConsecutiveDaysLabel()
        updateEnergyProgressLabel()
        updateFrequencyLabel()
        updateTodayLabel()
        updateProgressView()
        updateNextPunchInDateLabel()
        updateStartDateLabel()

    }
    
   
  
}

extension ItemDetailViewController: UIObserver {
    
    func updateUI() {
        updateNavigationBar()
        updateItemData()

    }
}

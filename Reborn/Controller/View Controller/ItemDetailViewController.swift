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
    
    @IBOutlet weak var notificationTimeLabel: UILabel!
    @IBOutlet weak var finishedDaysLabel: UILabel!
    @IBOutlet weak var targetDaysLabel: UILabel!
    @IBOutlet weak var bestConsecutiveDaysLabel: UILabel!
    @IBOutlet weak var energyProgressLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var nextPunchInDateLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var todayTitleLabel: UILabel!
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
        topView.setShadow(style: .view)
        
        title = "项目详情"
        
        //mediumView.layer.cornerRadius = setting.itemCardCornerRadius
        mediumView.setShadow(style: .view)

        calendarView.layer.cornerRadius = setting.itemCardCornerRadius
        bottomShareButton.proportionallySetSizeWithScreen()
        bottomShareButton.setCornerRadius()
        bottomShareButton.setShadow(style: .button)
        bottomEditButton.proportionallySetSizeWithScreen()
        bottomEditButton.setCornerRadius()
        bottomEditButton.setShadow(style: .button)
        
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
        if #available(iOS 14.0, *) {
            self.updateUI()
        }
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
            
            
            //destinationViewController.originalItemForRecovery = 
            destinationViewController.item = self.item
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
        self.finishedDaysLabel.text = "\(String(self.item.getFinishedDays())) 天"
    }
    
    func updateTargetDaysLabel() {
        self.targetDaysLabel.text = "\(String(self.item.targetDays)) 天"
    }
    
    
    
    func updateEnergyProgressLabel() {
        if item.todayIsAddedEnergy() {
            self.energyProgressLabel.textColor = ThemeColor.green.uiColor
            self.energyProgressLabel.text = "新能量 +1"
        } else {
            self.energyProgressLabel.text = "\(item.lastEnergyConsecutiveDays) / \(self.engine.currentUser.energyChargingEfficiencyDays)"
        }
        
    }
    
    func updateFrequencyLabel() {
        self.frequencyLabel.text = "\(self.item.newFrequency.getSpecificFreqencyString())"
    }
    
    func updateBestConsecutiveDaysLabel() {
        self.bestConsecutiveDaysLabel.text = ""
        LoadingAnimationManager.shared.add(loadingAnimation: .grayAlpha, to: self.bestConsecutiveDaysLabel, frame: self.bestConsecutiveDaysLabel.bounds, cornerRadius: self.bestConsecutiveDaysLabel.frame.height / 4, identifier: "BestConsecutiveDaysLabelAnimation")
        
        self.item.getBestConsecutiveDays { result in
            self.bestConsecutiveDaysLabel.text = "\(String(result)) 天"
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "BestConsecutiveDaysLabelAnimation")
        }
    }
    
    func updateNextPunchInDateLabel() {
        self.nextPunchInDateLabel.text = ""
        LoadingAnimationManager.shared.add(loadingAnimation: .grayAlpha, to: self.nextPunchInDateLabel, frame: self.nextPunchInDateLabel.bounds, cornerRadius: self.nextPunchInDateLabel.frame.height / 4, identifier: "NextPunchInDateLabelAnimation")
        self.item.getNextPunchInDateInString { result in
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "NextPunchInDateLabelAnimation")
            self.nextPunchInDateLabel.text = result
            
        }
    }
    
    func updateTodayLabel() {
        self.todayTitleLabel.text = self.item.getPeriodicalCompletionTitile()
        self.todayLabel.text = ""
        LoadingAnimationManager.shared.add(loadingAnimation: .grayAlpha, to: self.todayLabel, frame: CGRect(origin: CGPoint(x: -self.nextPunchInDateLabel.frame.size.width, y: 0), size: self.nextPunchInDateLabel.frame.size), cornerRadius: self.nextPunchInDateLabel.frame.height / 4, identifier: "TodayLabelAnimation")
        self.item.getPeriodicalCompletionInAttributedString(font: self.todayLabel.font, normalColor: .label, redColor: ThemeColor.red.uiColor, greenColor: ThemeColor.green.uiColor, grayColor: self.setting.grayColor.withAlphaComponent(0.5)) { result in
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "TodayLabelAnimation")
            self.todayLabel.attributedText = result
            
        }
        
       
    }
    
    func updateProgressView() {
        self.progressView.removeAllSubviews()
        if item != nil {
            self.verticalContentView.layoutIfNeeded()
            let builder = ItemProgressViewBuilder(item: item!, frame: self.progressView.bounds)
            let detailsView = builder.buildView()
            self.progressView.addSubview(detailsView)
            
        }
    }
    
    
    func updateStartDateLabel() {
        if let item = item {
            
            let daysAgo: Int = DateCalculator.calculateDayDifferenceBetween(item.creationDate, to: CustomDate.current)
            
            switch daysAgo {
            case 0: startDateLabel.text = "开始日期: \(item.creationDate.year)年 \(item.creationDate.month)月\(item.creationDate.day)日 (今天)"
            case 1: startDateLabel.text = "开始日期: \(item.creationDate.year)年 \(item.creationDate.month)月\(item.creationDate.day)日 (昨天)"
            default: startDateLabel.text = "开始日期: \(item.creationDate.year)年 \(item.creationDate.month)月\(item.creationDate.day)日 (\(daysAgo)天前)"
             
            }
            
        }
    }
    
    func updateNotificationLabel() {
        if let notificationTime = self.item.notificationTimes.first {
            notificationTimeLabel.text = "\(notificationTime.getTimeString())"
        } else {
            notificationTimeLabel.text = "关"
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
        updateNotificationLabel()
        
    }
    
   
  
}

extension ItemDetailViewController: UIObserver {
    
    func updateUI() {
        updateNavigationBar()
        updateItemData()

    }
}

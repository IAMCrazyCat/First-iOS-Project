//
//  ItemDetailViewController.swift
//  Reborn
//
//  Created by Christian Liu on 8/1/21.
//

import UIKit

class ItemDetailViewController: UIViewController {


    @IBOutlet weak var topView: UIView!
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
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var goBackButton: UINavigationItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var startDateLabel: UILabel!
    
    let setting: SystemSetting = SystemSetting.shared
    let engine: AppEngine = AppEngine.shared
    var item: Item? = nil
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
    
    @IBAction func bottomEidtItemButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToEditItemView", sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "EmbeddedCalendarContainer", let destinationViewController = segue.destination as? CalendarViewController  {
    
            destinationViewController.item = item
            destinationViewController.lastViewController = self
            embeddedCalendarViewController = destinationViewController
  
        } else if segue.identifier == "GoToEditItemView", let destinationViewController = segue.destination as? NewItemViewController {

            destinationViewController.item = self.item!
            destinationViewController.lastViewController = self
            destinationViewController.strategy = EditingItemStrategy(newItemViewController: destinationViewController)
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
        
        if let itemType = item?.type.rawValue, let itemName = item?.name {
            self.title = itemType + itemName
        }
       
    }
    
    func updateItemData() {
      
        updateFinishedDaysLabel()
        updateTargetDaysLabel()
        updateBestConsecutiveDaysLabel()
        updateFrequencyLabel()
        updateTodayLabel()
        updateProgressView()
        updateStartDateLabel()
        print("ItemDetailsView Data Updated")
        
    }
    
   
    
    func updateFinishedDaysLabel() {
        self.finishedDaysLabel.text = "\(String(self.item?.finishedDays ?? 0)) 天"
    }
    func updateTargetDaysLabel() {
        self.targetDaysLabel.text = "\(String(self.item?.targetDays ?? 0)) 天"
    }
    func updateBestConsecutiveDaysLabel() {
        self.bestConsecutiveDaysLabel.text = "\(String(self.item?.bestConsecutiveDays ?? 0)) 天"
    }
    func updateFrequencyLabel() {
        self.frequencyLabel.text = "\(String(self.item?.frequency.dataModel.title ?? "加载错误"))"
    }
    func updateTodayLabel() {
        
        if item != nil, self.item!.punchInDates.contains(CustomDate.current)  {
            self.todayLabel.textColor = ThemeColor.green.uiColor
            self.todayLabel.text = "已打卡"
        } else {
            self.todayLabel.textColor = ThemeColor.red.uiColor
            self.todayLabel.text = "未打卡"
        }
    }
    func updateProgressView() {
        if item != nil {
            self.verticalContentView.layoutIfNeeded()
            let builder = ItemDetailViewBuilder(item: item!, frame: self.progressView.bounds)
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

  
}

extension ItemDetailViewController: UIObserver {
    
    func updateUI() {
        updateNavigationBar()
        updateItemData()

    }
}

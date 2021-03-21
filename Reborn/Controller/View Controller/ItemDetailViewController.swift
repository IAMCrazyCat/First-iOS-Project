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
    
    @IBOutlet weak var finishedDayLabel: UILabel!
    @IBOutlet weak var targetDayLabel: UILabel!
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
        navigationController?.navigationBar.barTintColor = engine.userSetting.themeColorAndBlack
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: engine.userSetting.smartLabelColorAndThemeColor]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: engine.userSetting.smartLabelColorAndThemeColor]
//        navigationItem.rightBarButtonItem?.tintColor = engine.userSetting.smartLabelColorAndThemeColor
//        navigationItem.leftBarButtonItem?.tintColor = engine.userSetting.smartLabelColorAndThemeColor
        if let itemType = item?.type.rawValue, let itemName = item?.name {
            self.title = itemType + itemName
        }
       
    }
    
    func updateItemData() {
        print("ItemDetailsView Data Updated")
        if item != nil {
            self.verticalContentView.layoutIfNeeded()
            let builder = ItemDetailViewBuilder(item: item!, frame: self.progressView.bounds)
            let detailsView = builder.buildView()
            self.progressView.addSubview(detailsView)
            
        }
        
        self.finishedDayLabel.text = "\(String(self.item?.finishedDays ?? -1)) 天"
        self.targetDayLabel.text = "\(String(self.item?.targetDays ?? -1)) 天"
        self.frequencyLabel.text = "\(String(self.item?.frequency.dataModel.title ?? "加载错误"))"
        
        if self.item?.punchInDates.last == self.engine.currentDate {
            //self.todayLabel.textColor = .green
            self.todayLabel.text = "已打卡"
        } else {
            //self.todayLabel.textColor = .red
            self.todayLabel.text = "未打卡"
        }
        
        if let item = item {
            startDateLabel.text = "开始日期: \(item.creationDate.year)年 \(item.creationDate.month)月\(item.creationDate.day)日 (\(DateCalculator.calculateDayDifferenceBetween(item.creationDate, and: self.engine.currentDate))天前)"
        }
       
        
    }

  
}

extension ItemDetailViewController: UIObserver {
    
    func updateUI() {
        updateNavigationBar()
        updateItemData()

    }
}

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
    @IBOutlet weak var verticallyScrollContentView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var bottomEditButton: UIButton!
    @IBOutlet weak var bottomShareButton: UIButton!
    
    @IBOutlet weak var finishedDayLabel: UILabel!
    @IBOutlet weak var targetDayLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
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
        
        //topView.layer.cornerRadius = setting.itemCardCornerRadius
        topView.setShadow()
        
        //mediumView.layer.cornerRadius = setting.itemCardCornerRadius
        mediumView.setShadow()
        
        navigationController?.navigationBar.barTintColor = engine.userSetting.themeColorAndBlack
        calendarView.layer.cornerRadius = setting.itemCardCornerRadius
        
        bottomShareButton.setSizeAccrodingToScreen()
        bottomShareButton.setShadow()
        bottomShareButton.setCornerRadius()
        
        bottomEditButton.setSizeAccrodingToScreen()
        bottomEditButton.setShadow()
        bottomEditButton.setCornerRadius()
        
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        self.verticalScrollView.contentSize.height = self.bottomEditButton.frame.maxY + 20
        self.verticalScrollView.layoutIfNeeded()
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

  
}

extension ItemDetailViewController: Observer {
    func updateUI() {
        if item != nil {
            self.verticallyScrollContentView.layoutIfNeeded()
            let builder = ItemDetailViewBuilder(item: item!, frame: self.progressView.bounds)
            let detailsView = builder.buildView()
            self.progressView.addSubview(detailsView)
            
        }
        
        self.finishedDayLabel.text = "\(String(self.item?.finishedDays ?? -1)) 天"
        self.targetDayLabel.text = "\(String(self.item?.targetDays ?? -1)) 天"
        self.frequencyLabel.text = "\(String(self.item?.frequency.title ?? "加载错误"))"
        
        if self.item?.punchInDates.last == self.engine.currentDate {
            //self.todayLabel.textColor = .green
            self.todayLabel.text = "已打卡"
        } else {
            //self.todayLabel.textColor = .red
            self.todayLabel.text = "未打卡"
        }
        
        
    }
}

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
    @IBOutlet weak var verticallyScrollContentView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var bottomEditButton: UIButton!
    @IBOutlet weak var bottomShareButton: UIButton!
    
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let engine: AppEngine = AppEngine.shared
    var item: Item? = nil
    var embeddedCalendarViewController: CalendarViewController? = nil
    
    
    var dayCellFrame: CGRect? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.layer.cornerRadius = setting.itemCardCornerRadius
        topView.setShadow()
        //mediumView.setShadow()
       
        calendarView.layer.cornerRadius = setting.itemCardCornerRadius
        
        bottomShareButton.setSizeAccrodingToScreen()
        bottomShareButton.setShadow()
        bottomShareButton.setCornerRadius()
        
        bottomEditButton.setSizeAccrodingToScreen()
        bottomEditButton.setShadow()
        bottomEditButton.setCornerRadius()
        
        setUpUI()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "embeddedCalendarContainer", let destinationViewController = segue.destination as? CalendarViewController  {
    
            destinationViewController.item = item
            destinationViewController.superViewController = self
            embeddedCalendarViewController = destinationViewController
  
        }
        
        
    }
 
    
    func setUpUI() {
        if item != nil {
            self.verticallyScrollContentView.layoutIfNeeded()
            let builder = ItemViewBuilder(item: item!, width: self.mediumView.frame.width, height: self.setting.itemDetailsViewHeight, corninateX: 0, cordinateY: 0)
            let detailsView = builder.buildDetailsView()
            self.progressView.addSubview(detailsView)
            print(detailsView)
        }
        
    }
    
   
    
  
}

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
        topView.setViewShadow()
        
        calendarView.layer.cornerRadius = setting.itemCardCornerRadius


        setUpUI()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "embeddedCalendarContainer", let destinationViewController = segue.destination as? CalendarViewController  {
            
            destinationViewController.item = item
            destinationViewController.delegate = self // calendar view delegate = self to render instruction labels
            destinationViewController.superViewController = self
            embeddedCalendarViewController = destinationViewController
  
        } else if segue.identifier == "goTimeMachineView", let desitinationViewController = segue.destination as? TimeMachineViewController {
//            
//            if embeddedCalendarViewController != nil {
//                embeddedCalendarViewController!.delegate = desitinationViewController // calendar view delegate switched to TimeMachineViewController
//            }
//            let navBarheight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + (self.navigationController?.navigationBar.frame.height ?? 0.0)
//
//            desitinationViewController.calendarView = self.calendarView
//            desitinationViewController.calendarViewPosition = CGPoint(x: self.topView.frame.origin.x, y:  self.topView.frame.origin.y + navBarheight)
//            desitinationViewController.calendarViewController = embeddedCalendarViewController
//            embeddedCalendarViewController?.state = .timeMachine
        }
        
        
    }
    
    func goTimeMachineView() {
        self.performSegue(withIdentifier: "goTimeMachineView", sender: self)
        
    }
    
 
    
    func setUpUI() {
        if item != nil {
            self.verticallyScrollContentView.layoutIfNeeded()
            let builder = ItemViewBuilder(item: item!, width: self.mediumView.frame.width, height: self.setting.itemDetailsViewHeight, corninateX: 0, cordinateY: 0)
            let detailsView = builder.buildDetailsView()
            self.mediumView.addSubview(detailsView)
            print(detailsView)
        }
        
    }
    
   
    
  
}

extension ItemDetailViewController: CalendarViewDegelagte {
    
    func calendarCellDidLayout(size: CGSize) {
        
    }
    
    func calendarPageDidGoLastMonth() {
        
    }
    
    func calendarPageDidGoNextMonth() {
        
    }
    
    func calendarPageDidGoStartMonth() {
        
    }
    
    func calendarPageDidGoThisMonth() {
        
    }
    
   
    
}

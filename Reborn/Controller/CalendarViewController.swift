//
//  CalendarViewController.swift
//  Reborn
//
//  Created by Christian Liu on 13/1/21.
//

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var previousMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var startDayButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var currentMonthLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var middleStackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var bottomScrollView: UIScrollView!
    
    var item: Item? = nil
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let engine: AppEngine = AppEngine.shared
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomScrollView.delegate = self
        view.layer.cornerRadius = setting.itemCardCornerRadius
        view.setViewShadow()
        
        previousMonthButton.layer.cornerRadius = setting.calendarFunctionButtonCornerRadius
        previousMonthButton.setViewShadow()
        nextMonthButton.layer.cornerRadius = setting.calendarFunctionButtonCornerRadius
        nextMonthButton.setViewShadow()
        startDayButton.layer.cornerRadius = setting.calendarFunctionButtonCornerRadius
        startDayButton.setViewShadow()
        todayButton.layer.cornerRadius = setting.calendarFunctionButtonCornerRadius
        todayButton.setViewShadow()
        print(item)
        
        
        if let calendar = engine.loadCalendar(controller: self) {

            bottomScrollView.addSubview(calendar)
            bottomScrollView.contentSize = CGSize(width: bottomScrollView.frame.width * 3, height: bottomScrollView.frame.height)
            bottomScrollView.setContentOffset(CGPoint(x: bottomScrollView.frame.width, y: 0), animated: false)
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalendarViewController: UIScrollViewDelegate {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

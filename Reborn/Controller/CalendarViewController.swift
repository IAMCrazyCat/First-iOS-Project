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
    var calendarLoaded: Bool = false
    var todayCordinateX: CGFloat = 0
    var startDayCordinateX: CGFloat = 0
    var calendarPages: Array<CalendarPage> = []
    var currentPageIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bottomScrollView.delegate = self
        //bottomScrollView.widthAnchor.constraint(equalToConstant: view.frame.width - 2 * setting.mainPadding).isActive = true
      
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
        
        
       
        
    }
    
    override func viewDidLayoutSubviews() { // this method will be called multiple times
        bottomScrollView.layoutIfNeeded() // layout bottomScrollViewFirst
        if !calendarLoaded { // Ensure that calendar only be called once
            
            DispatchQueue.main.asyncAfter(deadline: .now()) { // 
                self.loadCalendar()
            }

        }
        calendarLoaded = true
        
     
//        if let calendar = engine.loadCalendar(controller: self) {
//
//            bottomScrollView.addSubview(calendar)
//            bottomScrollView.contentSize = CGSize(width: bottomScrollView.frame.width * 3, height: bottomScrollView.frame.height)
//            bottomScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewLayoutMarginsDidChange() {
      
    }
    
    public func loadCalendar() {// -> UIView? {
            
        let currentYear: Int = Calendar.current.component(.year, from: Date())
        var cordinateX: CGFloat = 0
        

        
        for year in currentYear - self.setting.calendarYearsInterval / 2 ... currentYear + self.setting.calendarYearsInterval / 2 {
            
            for month in 1 ... 12 { // 12 months
                
                var punchedInDays: Array<Int> = []
                
                if self.item != nil { // Ensure thgat item is not nil
                    
                    for punchInDate in self.item!.punchInDate { // add all punched in date into punchedInDays array
                        if punchInDate.year == year && punchInDate.month == month {
                            punchedInDays.append(punchInDate.day)
                        }
                    }
                }
              
                let calendarPage = CalendarPage(year: year, month: month, punchedInDays: punchedInDays)

                let builder = CalendarPageBuilder(calendarPage: calendarPage, width: self.bottomScrollView.frame.width, height: self.bottomScrollView.frame.height, cordinateX: cordinateX, cordinateY: 0 )
                
                self.calendarPages.append(calendarPage)
                self.bottomScrollView.addSubview(builder.builCalendarPage())
                
                let date = Date()
                if year == Calendar.current.component(.year, from: date) && month == Calendar.current.component(.month, from: date) {
                    todayCordinateX = cordinateX
                }
                
                cordinateX += self.bottomScrollView.frame.width

            }
            
          
        }
    
        self.bottomScrollView.contentSize = CGSize(width: cordinateX, height: self.bottomScrollView.frame.height)
        self.bottomScrollView.setContentOffset(CGPoint(x: todayCordinateX, y: 0), animated: false)
        
        
        var index = 0
        for calendarPage in calendarPages {
            if calendarPage.year == self.engine.currentDate.year && calendarPage.month == self.engine.currentDate.month {
                self.currentPageIndex = index
            }
            index += 1
        }
        
        self.updateUI()
        
    }
    
    @IBAction func startDayButtonPressed(_ sender: UIButton!) {
        item!.creationDate = CustomDate(year: 2018, month: 12, day: 12)
        let startDay = item!.creationDate
        
        let currentDay = self.engine.currentDate
        let monthInterval = (currentDay.year - startDay.year) * 12 + (currentDay.month - startDay.month)
        self.startDayCordinateX = self.todayCordinateX - CGFloat(monthInterval) * self.bottomScrollView.frame.width
        
        self.bottomScrollView.setContentOffset(CGPoint(x: self.startDayCordinateX, y: 0), animated: true)
        self.updateUI()
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton!) {
        self.bottomScrollView.setContentOffset(CGPoint(x: self.todayCordinateX, y: 0), animated: true)
        self.updateUI()
    }
    
        
    func updateUI() {
        
        currentMonthLabel.text = calendarPages[currentPageIndex].currentYearAndMonthInString
        
        print(Int(Double(bottomScrollView.contentOffset.x / bottomScrollView.contentSize.width) * Double(self.setting.calendarYearsInterval * 12)))
    }
    
    
    var scrollViewLastOffsetX: CGFloat = 0
    var currentPageIndexDidChange: Bool = false
}

extension CalendarViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x > scrollViewLastOffsetX && !currentPageIndexDidChange { // To right
            print("RIGHT")
            currentPageIndex += 1
            currentPageIndexDidChange = true
        } else if scrollView.contentOffset.x < scrollViewLastOffsetX && !currentPageIndexDidChange { // to left
            print("LEFT")
            currentPageIndex -= 1
            currentPageIndexDidChange = true
        }
        
        self.updateUI()
        
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewLastOffsetX = scrollView.contentOffset.x
        currentPageIndexDidChange = false

        print("END")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewLastOffsetX = scrollView.contentOffset.x
        currentPageIndexDidChange = false
        print("??")
    }
}

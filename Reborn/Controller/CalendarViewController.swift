//
//  CalendarViewController.swift
//  Reborn
//
//  Created by Christian Liu on 13/1/21.
//

import UIKit
enum NewCalendarPage {
    case lastMonth
    case currentMonth
    case nextMonth
}
class CalendarViewController: UIViewController {
    
    public static var shared: CalendarViewController = CalendarViewController()
    @IBOutlet weak var lastMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var startDayButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var currentMonthLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var middleStackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    var item: Item? = nil
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let engine: AppEngine = AppEngine.shared
    var calendarLoaded: Bool = false
    var calendarPages: Array<CalendarPage> = []
    var currentPageIndex: Int = 0
    
    var currentCalendarPage: CalendarPage? = nil
    var startDayCellIndex: Int = 0
    var todayCellIndex: Int = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
       
        if let layout = bottomCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        
        //bottomScrollView.widthAnchor.constraint(equalToConstant: view.frame.width - 2 * setting.mainPadding).isActive = true
      
        view.layer.cornerRadius = setting.itemCardCornerRadius
        view.setViewShadow()
        
        lastMonthButton.layer.cornerRadius = setting.calendarFunctionButtonCornerRadius
        lastMonthButton.setViewShadow()
        nextMonthButton.layer.cornerRadius = setting.calendarFunctionButtonCornerRadius
        nextMonthButton.setViewShadow()
        startDayButton.layer.cornerRadius = setting.calendarFunctionButtonCornerRadius
        startDayButton.setViewShadow()
        todayButton.layer.cornerRadius = setting.calendarFunctionButtonCornerRadius
        todayButton.setViewShadow()
        
       
        var days: Array<Int> = []
        if self.item != nil { // Ensure thgat item is not nil
            for punchInDate in self.item!.punchInDate { // add all punched in date into punchedInDays array
                if punchInDate.year == self.engine.currentDate.year && punchInDate.month == self.engine.currentDate.month {
                    days.append(punchInDate.day)
                }
            }
        }
        
        calendarPages.append(CalendarPage(year: self.engine.currentDate.year, month: self.engine.currentDate.month, punchedInDays: days))
    
//        self.addNewCalendarPage(type: .lastMonth)
//        self.addNewCalendarPage(type: .nextMonth)
    
       
        
        updateUI()
    
        
    }
    
    override func viewDidLayoutSubviews() { // this method will be called multiple times
        bottomCollectionView.layoutIfNeeded() // layout bottomScrollViewFirst
        if !calendarLoaded { // Ensure that calendar only be called once
            
            DispatchQueue.main.asyncAfter(deadline: .now()) { // 
                //self.loadCalendar()
            }

        }
        calendarLoaded = true

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewLayoutMarginsDidChange() {
      
    }

    public func getCurrentCalendarPage() -> CalendarPage {
        return self.calendarPages[currentPageIndex]
    }
    
    private func getPunchedInDays(pageYear year: Int, pageMonth month: Int) -> Array<Int> {
        var punchedInDays: Array<Int> = []
        for punchedInDate in self.item!.punchInDate { // add all punched in date into punchedInDays array
            if punchedInDate.year == year && punchedInDate.month == month {
                punchedInDays.append(punchedInDate.day)
            }
        }
        return punchedInDays
    }
    
    
    func addNewCalendarPage(type: NewCalendarPage) {
         
        var lastPageYear: Int {
            if self.calendarPages[currentPageIndex].month - 1 < 1 {
                return self.calendarPages[currentPageIndex].year - 1
            } else {
                return self.calendarPages[currentPageIndex].year
            }
        }
        
        var lastPageMonth: Int {
            if self.calendarPages[currentPageIndex].month - 1 < 1 {
                return 12
            } else {
                return self.calendarPages[currentPageIndex].month - 1
            }
        }
        
        var nextPageYear: Int {
            if self.calendarPages[currentPageIndex].month + 1 > 12 {
                return self.calendarPages[currentPageIndex].year + 1
            } else {
                return self.calendarPages[currentPageIndex].year
            }
        }
        
        
        var nextPageMonth: Int {
            if self.calendarPages[currentPageIndex].month + 1 > 12 {
                return 1
            } else {
                return self.calendarPages[currentPageIndex].month + 1
            }
        }
        
        let newCalendarPage: CalendarPage
        
        let nextPagePunchedInDays: Array<Int> = self.getPunchedInDays(pageYear: nextPageYear, pageMonth: nextPageMonth)
        var lastPagePunchedInDays: Array<Int> = self.getPunchedInDays(pageYear: lastPageYear, pageMonth: lastPageMonth)
        

        
    
        
        if type == .lastMonth {
            newCalendarPage = CalendarPage(year: lastPageYear, month: lastPageMonth, punchedInDays: lastPagePunchedInDays)
            let newIndexPath = IndexPath(item: 0, section: 0)
            calendarPages.insert(newCalendarPage, at: 0)
            bottomCollectionView.insertItems(at: [newIndexPath])
           
        } else if type == .nextMonth {
            newCalendarPage = CalendarPage(year: nextPageYear, month: nextPageMonth, punchedInDays: nextPagePunchedInDays)
            let newIndexPath = IndexPath(item: calendarPages.count, section: 0)
            calendarPages.append(newCalendarPage)
            bottomCollectionView.insertItems(at: [newIndexPath])
        }
            
    }
    
    @IBAction func startDayButtonPressed(_ sender: UIButton!) {
        self.item!.creationDate = CustomDate(year: 2018, month: 12, day: 12)
        
        if item != nil {
            
            let startDate = item!.creationDate
            
            let currentDay = self.engine.currentDate
            //self.calendarPages.append(CalendarPage(year: startDate.year, month: startDate.month, punchedInDays: <#T##Array<Int>#>))
            let monthInterval = (currentDay.year - startDate.year) * 12 + (currentDay.month - startDate.month)
            print("Date interval: \(monthInterval)")

            for _ in 1 ... monthInterval {
                self.addNewCalendarPage(type: .lastMonth)
            }

            self.currentPageIndex = self.startDayCellIndex
            self.todayCellIndex += monthInterval
            self.updateUI()
        }
       
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton!) {
        
        self.currentPageIndex = self.todayCellIndex
        self.updateUI()
    }
    
    @IBAction func lastMonthButtonPressed(_ sender: Any) {

        if currentPageIndex <= 0 {
            self.bottomCollectionView.performBatchUpdates({
                self.addNewCalendarPage(type: .lastMonth)
            }, completion: nil)
            
            self.todayCellIndex += 1
        } else {
            self.currentPageIndex -= 1
        }
    
        self.updateUI()
       
    }
    
    @IBAction func nextMonthButtonPressed(_ sender: Any) {
    
        if currentPageIndex >= self.calendarPages.count - 1 {
            self.bottomCollectionView.performBatchUpdates({
                self.addNewCalendarPage(type: .nextMonth)
            }, completion: nil)

            
        } else {
            
        }
        
        self.currentPageIndex += 1
        updateUI()
    }
    
    func updateUI() {
        print(calendarPages)
        print("current page Index \(currentPageIndex)")
        
        //self.bottomCollectionView.scrollToItem(at: IndexPath(item: self.currentPageIndex, section: 0), at: .centeredVertically, animated: true)
        self.bottomCollectionView.reloadData()
        currentMonthLabel.text = self.calendarPages[currentPageIndex].currentYearAndMonthInString
        
        
    
    }
    
    

}



extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 42
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
       
        // 在这里改 cell
        if indexPath.row < (self.calendarPages[self.currentPageIndex].weekdayOfFirstDay) - 1 { //Before the first day

            cell.dayLabel.backgroundColor = UIColor.clear

        } else if indexPath.row >  self.calendarPages[self.currentPageIndex].weekdayOfFirstDay - 1 && indexPath.row < self.calendarPages[self.currentPageIndex].days + self.calendarPages[self.currentPageIndex].weekdayOfFirstDay { // Between the firstday And Last Day

            let dayNumber = indexPath.row - (self.calendarPages[self.currentPageIndex].weekdayOfFirstDay) + 1

            cell.dayLabel.text = String(dayNumber)
            
            if self.calendarPages[self.currentPageIndex].punchedInDays.contains(dayNumber) {
                cell.dayLabel.backgroundColor = UserStyleSetting.themeColor
            }

        } else { // After lastday
            cell.dayLabel.backgroundColor = UIColor.clear
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 7, height: collectionView.frame.height / 6)
      }
    
    
   
}


//extension CalendarViewController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        if scrollView.contentOffset.x > scrollViewLastOffsetX && !currentPageIndexDidChange { // To right
//            print("RIGHT")
//            currentPageIndex += 1
//            currentPageIndexDidChange = true
//        } else if scrollView.contentOffset.x < scrollViewLastOffsetX && !currentPageIndexDidChange { // to left
//            print("LEFT")
//            currentPageIndex -= 1
//            currentPageIndexDidChange = true
//        }
//
//        self.updateUI()
//
//
//    }
//
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        scrollViewLastOffsetX = scrollView.contentOffset.x
//        currentPageIndexDidChange = false
//
//        print("END")
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        scrollViewLastOffsetX = scrollView.contentOffset.x
//        currentPageIndexDidChange = false
//        print("??")
//    }
//}



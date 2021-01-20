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
    var todayCordinateX: CGFloat = 0
    var startDayCordinateX: CGFloat = 0
    var calendarPages: Array<CalendarPage> = []
    var currentPageIndex: Int = 1
    
    var currentPage: CalendarPage {
        print(currentPageIndex)
        return calendarPages[currentPageIndex]
    }
    
    
    var currentPagePunchedInDays: Array<Int> {
        var days: Array<Int> = []
        
        if self.item != nil { // Ensure thgat item is not nil

            for punchInDate in self.item!.punchInDate { // add all punched in date into punchedInDays array
                if punchInDate.year == currentPage.year && punchInDate.month == currentPage.month {
                    days.append(punchInDate.day)
                }
            }
        }
        return days
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        if let layout = bottomCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
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
        
        
        initializeBasicCalendarPages()
        
        addNewCalendarPage(type: .currentMonth)
        addNewCalendarPage(type: .lastMonth)
        addNewCalendarPage(type: .nextMonth)
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
    
    private func initializeBasicCalendarPages() {
      
        
//        let centerPageYear = self.engine.currentDate.year
//        let centerPageMonth = self.engine.currentDate.month
//
//        var leftPagePunchedInDays: Array<Int> = []
//        var centerPagePunchedInDays: Array<Int> = []
//        var rightPagePunchedInDays: Array<Int> = []
//
//        var leftPageYear: Int {
//            if centerPageMonth - 1 < 1 {
//                return centerPageYear - 1
//            } else {
//                return centerPageYear
//            }
//        }
//
//        var leftPageMonth: Int {
//            if centerPageMonth - 1 < 1 {
//                return 12
//            } else {
//                return centerPageMonth - 1
//            }
//        }
//
//        var rightPageYear: Int {
//            if centerPageMonth + 1 > 12 {
//                return centerPageYear + 1
//            } else {
//                return centerPageYear
//            }
//        }
//
//
//        var rightPageMonth: Int {
//            if centerPageMonth + 1 > 12 {
//                return 1
//            } else {
//                return centerPageMonth + 1
//            }
//        }
//
//
//        if self.item != nil { // Ensure thgat item is not nil
//
//            for punchInDate in self.item!.punchInDate { // add all punched in date into punchedInDays array
//                if punchInDate.year == leftPageYear && punchInDate.month == leftPageMonth {
//                    leftPagePunchedInDays.append(punchInDate.day)
//                }
//            }
//
//            for punchInDate in self.item!.punchInDate { // add all punched in date into punchedInDays array
//                if punchInDate.year == centerPageYear && punchInDate.month == centerPageMonth {
//                    centerPagePunchedInDays.append(punchInDate.day)
//                }
//            }
//
//            for punchInDate in self.item!.punchInDate { // add all punched in date into punchedInDays array
//                if punchInDate.year == rightPageYear && punchInDate.month == rightPageMonth {
//                    rightPagePunchedInDays.append(punchInDate.day)
//                }
//            }
//
//        }
//
//        let leftCalendarPage = CalendarPage(year: leftPageYear, month: leftPageMonth, punchedInDays: leftPagePunchedInDays)
//        let centerCalendarPage = CalendarPage(year: centerPageYear, month: centerPageMonth, punchedInDays: centerPagePunchedInDays)
//        let rightCalendarPage =  CalendarPage(year: rightPageYear, month: rightPageMonth, punchedInDays: rightPagePunchedInDays)
//
//        self.calendarPages.append(leftCalendarPage)
//        self.calendarPages.append(centerCalendarPage)
//        self.calendarPages.append(rightCalendarPage)
    }
    
    public func buildCalendarPage(index: Int) -> UIView {
  
        let builder = CalendarPageBuilder(calendarPage: self.calendarPages[index], width: self.bottomCollectionView.frame.width, height: self.bottomCollectionView.frame.height, cordinateX: 0, cordinateY: 0 )

        return builder.builCalendarPage()
        
    }
    
    func addNewCalendarPage(type: NewCalendarPage) {
         
        var lastPageYear: Int {
            if self.currentPage.month - 1 < 1 {
                return self.currentPage.year - 1
            } else {
                return self.currentPage.year
            }
        }
        
        var lastPageMonth: Int {
            if self.currentPage.month - 1 < 1 {
                return 12
            } else {
                return self.currentPage.month - 1
            }
        }
        
        var nextPageYear: Int {
            if self.currentPage.month + 1 > 12 {
                return self.currentPage.year + 1
            } else {
                return self.currentPage.year
            }
        }
        
        
        var nextPageMonth: Int {
            if self.currentPage.month + 1 > 12 {
                return 1
            } else {
                return self.currentPage.month + 1
            }
        }
        
        let newCalendarPage: CalendarPage
        
        if type == .lastMonth {
            newCalendarPage = CalendarPage(year: lastPageYear, month: lastPageMonth, punchedInDays: self.currentPagePunchedInDays)
            let newIndexPath = IndexPath(item: 0, section: 0)
            calendarPages.insert(newCalendarPage, at: 0)
            bottomCollectionView.insertItems(at: [newIndexPath])
           
        } else if type == .nextMonth {
            newCalendarPage = CalendarPage(year: nextPageYear, month: nextPageMonth, punchedInDays: self.currentPagePunchedInDays)
            let newIndexPath = IndexPath(item: calendarPages.count, section: 0)
            calendarPages.append(newCalendarPage)
            bottomCollectionView.insertItems(at: [newIndexPath])
        } else {
            newCalendarPage = CalendarPage(year: self.currentPage.year, month: self.currentPage.month, punchedInDays: self.currentPagePunchedInDays)
            let newIndexPath = IndexPath(item: calendarPages.count, section: 0)
            calendarPages.append(newCalendarPage)
            bottomCollectionView.insertItems(at: [newIndexPath])
        }
            
        
        
        
        
        
    }
    
    @IBAction func startDayButtonPressed(_ sender: UIButton!) {
        item!.creationDate = CustomDate(year: 2018, month: 12, day: 12)
        let startDay = item!.creationDate
        
        let currentDay = self.engine.currentDate
        let monthInterval = (currentDay.year - startDay.year) * 12 + (currentDay.month - startDay.month)
        self.startDayCordinateX = self.todayCordinateX - CGFloat(monthInterval) * self.bottomCollectionView.frame.width
        
        self.bottomCollectionView.setContentOffset(CGPoint(x: self.startDayCordinateX, y: 0), animated: true)
        self.updateUI()
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton!) {
        self.bottomCollectionView.setContentOffset(CGPoint(x: self.todayCordinateX, y: 0), animated: true)
        self.updateUI()
    }
    
    @IBAction func lastMonthButtonPressed(_ sender: Any) {

        if currentPageIndex <= 1 {
            self.addNewCalendarPage(type: .lastMonth)
        } else {
            self.currentPageIndex -= 1
        }
        
        updateUI()
       
    }
    
    @IBAction func nextMonthButtonPressed(_ sender: Any) {
    
        if currentPageIndex >= self.calendarPages.count - 1 {
            self.addNewCalendarPage(type: .nextMonth)
        } else {
            
        }
        
        self.currentPageIndex += 1
        updateUI()
    }
    
    func updateUI() {
        print(currentPageIndex)
        self.bottomCollectionView.scrollToItem(at: IndexPath(item: self.currentPageIndex, section: 0), at: .centeredVertically, animated: true)
        currentMonthLabel.text = currentPage.currentYearAndMonthInString
        
        CalendarPageViewController.shared.initialize(calendarPage: currentPage)
    
    }
    
    
    var scrollViewLastOffsetX: CGFloat = 0
    var currentPageIndexDidChange: Bool = false
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.calendarPages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        //cell.backgroundColor = UIColor.blue
        //cell.frame.size = self.bottomCollectionView.frame.size
        cell.addSubview(self.buildCalendarPage(index: indexPath.row))
        //CalendarPageViewController.shared.currentPage += 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
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



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
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    var item: Item? = nil
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let engine: AppEngine = AppEngine.shared
    var calendarLoaded: Bool = false
    var todayCordinateX: CGFloat = 0
    var startDayCordinateX: CGFloat = 0
    var calendarPages: Array<CalendarPage> = []
    var currentPageIndex: Int = 0
    var numberOfBottomCollectionViewCells: Int = 3
    var indexPath: IndexPath? = nil
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
    
    public func buildCalendarPage(index: Int) -> UIView {
            
        var cordinateX: CGFloat = 0
        
        var centerPageYear = self.engine.currentDate.year
        var centerPageMonth = self.engine.currentDate.month

        var punchedInDays: Array<Int> = []
        
        var leftPageYear: Int {
            if centerPageMonth - 1 < 1 {
                return centerPageYear - 1
            } else {
                return centerPageYear
            }
        }
        
        var leftPageMonth: Int {
            if centerPageMonth - 1 < 1 {
                return 12
            } else {
                return centerPageMonth - 1
            }
        }
        
        var rightPageYear: Int {
            if centerPageMonth + 1 > 12 {
                return centerPageYear + 1
            } else {
                return centerPageYear
            }
        }
        
        
        var rightPageMonth: Int {
            if centerPageMonth + 1 > 12 {
                return 1
            } else {
                return centerPageMonth + 1
            }
        }
        
//        if self.item != nil { // Ensure thgat item is not nil
//
//            for punchInDate in self.item!.punchInDate { // add all punched in date into punchedInDays array
//                if punchInDate.year == year && punchInDate.month == month {
//                    punchedInDays.append(punchInDate.day)
//                }
//            }
//        }
        
        let leftCalendarPage = CalendarPage(year: leftPageYear, month: leftPageMonth, punchedInDays: punchedInDays)
        let centerCalendarPage = CalendarPage(year: centerPageYear, month: centerPageMonth, punchedInDays: punchedInDays)
        let rightCalendarPage =  CalendarPage(year: rightPageYear, month: rightPageMonth, punchedInDays: punchedInDays)
        
        self.calendarPages.append(leftCalendarPage)
        self.calendarPages.append(centerCalendarPage)
        self.calendarPages.append(rightCalendarPage)
        
            
        let builder = CalendarPageBuilder(calendarPage: calendarPages[index], width: self.bottomCollectionView.frame.width, height: self.bottomCollectionView.frame.height, cordinateX: cordinateX, cordinateY: 0 )
        
        
        
//            let date = Date()
//            if year == Calendar.current.component(.year, from: date) && month == Calendar.current.component(.month, from: date) {
//                todayCordinateX = cordinateX
//            }
        
        return builder.builCalendarPage()
            
          

    
        self.bottomCollectionView.contentSize = CGSize(width: cordinateX, height: self.bottomCollectionView.frame.height)
        self.bottomCollectionView.setContentOffset(CGPoint(x: todayCordinateX, y: 0), animated: false)
        
        
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
        self.startDayCordinateX = self.todayCordinateX - CGFloat(monthInterval) * self.bottomCollectionView.frame.width
        
        self.bottomCollectionView.setContentOffset(CGPoint(x: self.startDayCordinateX, y: 0), animated: true)
        self.updateUI()
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton!) {
        self.bottomCollectionView.setContentOffset(CGPoint(x: self.todayCordinateX, y: 0), animated: true)
        self.updateUI()
    }
    
    @IBAction func prviousMonthButtonPressed(_ sender: Any) {
    
//        if indexPath != nil {
//            self.bottomCollectionView.scrollToItem(at: IndexPath(item: self.indexPath!.row - 1, section: 0), at: .centeredHorizontally, animated: true)
//        }
        
        self.bottomCollectionView.setContentOffset(CGPoint(x: 0, y: self.bottomCollectionView.contentOffset.y - self.bottomCollectionView.frame.height), animated: true)
       
    }
    
    @IBAction func nextMonthButtonPressed(_ sender: Any) {
    
//        if indexPath != nil {
//            self.bottomCollectionView.scrollToItem(at: self.indexPath!, at: .centeredHorizontally, animated: true)
//        }
        self.bottomCollectionView.setContentOffset(CGPoint(x: 0, y: self.bottomCollectionView.contentOffset.y + self.bottomCollectionView.frame.height), animated: true)
    }
    
    func updateUI() {
        
        currentMonthLabel.text = calendarPages[currentPageIndex].currentYearAndMonthInString
        
        print(Int(Double(bottomCollectionView.contentOffset.x / bottomCollectionView.contentSize.width) * Double(self.setting.calendarYearsInterval * 12)))
    }
    
    
    var scrollViewLastOffsetX: CGFloat = 0
    var currentPageIndexDidChange: Bool = false
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfBottomCollectionViewCells
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.indexPath = indexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        //cell.backgroundColor = UIColor.blue
        //cell.frame.size = self.bottomCollectionView.frame.size
        cell.addSubview(self.buildCalendarPage(index: indexPath.row))
        CalendarPageViewController.shared.currentPage += 1
        
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



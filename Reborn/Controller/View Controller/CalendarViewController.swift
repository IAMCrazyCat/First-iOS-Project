//
//  CalendarViewController.swift
//  Reborn
//
//  Created by Christian Liu on 13/1/21.
//

import UIKit


protocol CalendarViewDegelagte {
    func calendarCellDidLayout(size: CGSize)
    func calendarPageDidGoLastMonth()
    func calendarPageDidGoNextMonth()
    func calendarPageDidGoStartMonth()
    func calendarPageDidGoThisMonth()
    func calendarPageDidGoNowhere()
}


class CalendarViewController: UIViewController {
    
    //public static var shared: CalendarViewController = CalendarViewController()
    @IBOutlet weak var lastMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var startMonthButton: UIButton!
    @IBOutlet weak var thisMonthButton: UIButton!
    @IBOutlet weak var currentMonthLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var middleStackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    @IBOutlet weak var timeMachineButton: UIButton!

    
    private let setting: SystemSetting = SystemSetting.shared
    private let engine: AppEngine = AppEngine.shared
    private var storedState: CalendarState = .normal
    
    public lazy var currentCalendarPage: CalendarPage = CalendarPage(year: self.engine.currentDate.year, month: self.engine.currentDate.month, item: item!)
    public var monthLabelOriginalCordinateX: CGFloat = 0
    public var item: Item?
    public var calendarLoaded: Bool = false
    public var delegate: CalendarViewDegelagte?
    public var lastViewController: UIViewController?
    public var storedMonthInterval: Int = 0
    public var userDidGo: NewCalendarPage = .noWhere
    public var punchInMakingUpDates: Array<CustomDate> = []
    
//    lazy var currentYear = self.currentCalendarPage.year
//    lazy var currentMonth = self.currentCalendarPage.month
//    lazy var currentDay = self.currentCalendarPage.days
    

    public var state: CalendarState {
        get {
            return storedState
        }
        
        set {
            storedState = newValue
            updateUI()
        }
        
    }

    private var lastPageYear: Int {
        let currentYear = self.currentCalendarPage.year
        let currentMonth = self.currentCalendarPage.month
        let currentDay = self.currentCalendarPage.days
        let newDate = DateCalculator.calculateDate(withMonthDifference: -1, originalDate: CustomDate(year: currentYear, month: currentMonth, day: currentDay))
        return newDate.year
        
    }
    
    private var lastPageMonth: Int {
        let currentYear = self.currentCalendarPage.year
        let currentMonth = self.currentCalendarPage.month
        let currentDay = self.currentCalendarPage.days
        let newDate = DateCalculator.calculateDate(withMonthDifference: -1, originalDate: CustomDate(year: currentYear, month: currentMonth, day: currentDay))
        return newDate.month
        
    }
    
    private var nextPageYear: Int {
        let currentYear = self.currentCalendarPage.year
        let currentMonth = self.currentCalendarPage.month
        let currentDay = self.currentCalendarPage.days
        let newDate = DateCalculator.calculateDate(withMonthDifference: 1, originalDate: CustomDate(year: currentYear, month: currentMonth, day: currentDay))
        return newDate.year

    }
    
    private var nextPageMonth: Int {
        let currentYear = self.currentCalendarPage.year
        let currentMonth = self.currentCalendarPage.month
        let currentDay = self.currentCalendarPage.days
        let newDate = DateCalculator.calculateDate(withMonthDifference: 1, originalDate: CustomDate(year: currentYear, month: currentMonth, day: currentDay))
        return newDate.month
       
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        engine.add(observer: self)
        
        if let layout = bottomCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
        }
        
        view.layer.cornerRadius = setting.itemCardCornerRadius
        view.clipsToBounds = true
      
        lastMonthButton.setCornerRadius()
        thisMonthButton.setCornerRadius()
        nextMonthButton.setCornerRadius()
        startMonthButton.setCornerRadius()
    
        monthLabelOriginalCordinateX = currentMonthLabel.frame.origin.x
        updateUI()
    
        
    }
    
    override func viewDidLayoutSubviews() { // this method will be called multiple times
        //bottomCollectionView.layoutIfNeeded() // layout bottomScrollViewFirst
        if !calendarLoaded { // Ensure that calendar only be called once
            
            let cellLayout = bottomCollectionView.layoutAttributesForItem(at: IndexPath(row: 0, section: 0))
            delegate?.calendarCellDidLayout(size: cellLayout?.size ?? CGSize(width: 20, height: 20)) // Give the cell's frame back to Details VC to make the instruction label's frame is the same
            
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
    


    
    
    func updateCalendarPage(type: NewCalendarPage) {
         
        let newCalendarPage: CalendarPage
        switch type {
        case .lastMonth:
            
            self.storedMonthInterval = -1
            newCalendarPage = CalendarPage(year: lastPageYear, month: lastPageMonth, item: item!)
            self.currentCalendarPage = newCalendarPage
            
        case .nextMonth:
            
            self.storedMonthInterval = 1
            newCalendarPage = CalendarPage(year: nextPageYear, month: nextPageMonth, item: item!)
            self.currentCalendarPage = newCalendarPage
            
        case .startMonth:
            
            if item != nil {
                let startDate = self.item!.creationDate
                let currentYear = self.currentCalendarPage.year
                let currentMonth = self.currentCalendarPage.month
                let currentDay = self.currentCalendarPage.days
                
                self.storedMonthInterval = DateCalculator.calculateMonthDifference(withOriginalDate: CustomDate(year: currentYear, month: currentMonth, day: currentDay), andNewDate: startDate)

                self.currentCalendarPage = CalendarPage(year: startDate.year, month: startDate.month, item: item!)
            }
        case .thisMonth:
            let currentYear = self.currentCalendarPage.year
            let currentMonth = self.currentCalendarPage.month
            let currentDay = self.currentCalendarPage.days
            self.storedMonthInterval = DateCalculator.calculateMonthDifference(withOriginalDate: CustomDate(year: currentYear, month: currentMonth, day: currentDay), andNewDate: self.engine.currentDate)

            self.currentCalendarPage = CalendarPage(year: self.engine.currentDate.year, month: self.engine.currentDate.month, item: item!)
            
        case .noWhere:
            
            self.currentCalendarPage = CalendarPage(year: self.currentCalendarPage.year, month: self.currentCalendarPage.month, item: item!)
            print(self.currentCalendarPage.punchedInDays)
        }
    
    }
    
    @IBAction func startMonthButtonPressed(_ sender: UIButton!) {
        self.item!.creationDate = CustomDate(year: 2018, month: 12, day: 12) // For Test
        
        if self.currentCalendarPage.month == self.item!.creationDate.month && self.currentCalendarPage.year == self.item!.creationDate.year {
            self.userDidGo = .noWhere
        } else {
            self.userDidGo = .startMonth
        }
        
        updateUI()
       
    }

    @IBAction func thisMonthButtonPressed(_ sender: UIButton!) {
        
        
        if self.currentCalendarPage.month == self.engine.currentDate.month && self.currentCalendarPage.year == self.engine.currentDate.year {
            self.userDidGo = .noWhere
        } else {
            self.userDidGo = .thisMonth
        }
        updateUI()
    }
    
    @IBAction func lastMonthButtonPressed(_ sender: Any) {
        
        self.userDidGo = .lastMonth
        updateUI()
    }
    
    @IBAction func nextMonthButtonPressed(_ sender: Any) {
       
        self.userDidGo = .nextMonth
        updateUI()
    }
    
    @IBAction func timeMachineButtonPressed(_ sender: Any) {
        self.userDidGo = .noWhere
        
        if let itemDetailViewController = self.lastViewController as? ItemDetailViewController {
            itemDetailViewController.verticalScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
        self.presentTimeMachineView()
        
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let desitinationViewController = segue.destination as? TimeMachineViewController {
            self.removeFromParent() // remove its original parent controler: ItemDetailViewController
            
            let navBarheight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + (self.navigationController?.navigationBar.frame.height ?? 0.0)
            desitinationViewController.calendarView = self.view
            desitinationViewController.calendarViewOriginalPosition = CGPoint(x: self.topView.frame.origin.x, y:  self.topView.frame.origin.y + navBarheight)
            desitinationViewController.calendarViewController = self
            self.delegate = desitinationViewController
            self.state = .timeMachine
        }
       
    }
    
    private func excuteMonthLabelMoveToRightAnimation() {
        let directionAttribute = -1
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.currentMonthLabel.frame.origin.x -= CGFloat(20 * directionAttribute)
            self.currentMonthLabel.layer.opacity = 0
        }) { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.currentMonthLabel.frame.origin.x += CGFloat(40 * directionAttribute)
            }) { _ in
                self.currentMonthLabel.text = self.currentCalendarPage.currentYearAndMonthInString
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                    self.currentMonthLabel.layer.opacity = 1
                    self.currentMonthLabel.frame.origin.x = self.monthLabelOriginalCordinateX
                })
            }
        }
    }
    
    private func excuteMonthLabelMoveToLeftAnimation() {
        let directionAttribute = 1
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.currentMonthLabel.frame.origin.x -= CGFloat(20 * directionAttribute)
            self.currentMonthLabel.layer.opacity = 0
        }) { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.currentMonthLabel.frame.origin.x += CGFloat(40 * directionAttribute)
            }) { _ in
                self.currentMonthLabel.text = self.currentCalendarPage.currentYearAndMonthInString
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                    self.currentMonthLabel.layer.opacity = 1
                    self.currentMonthLabel.frame.origin.x = self.monthLabelOriginalCordinateX
                })
            }
        }
    }
    
    private func excuteMonthLabelZoomInAnimation() {
        

        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            
            self.currentMonthLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.currentMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { _ in
               
            }
        }
    }
    
    private func updateMonthLabelWithAnimation() {

        switch userDidGo {
        case .lastMonth, .startMonth:
            excuteMonthLabelMoveToRightAnimation()
        case .thisMonth, .nextMonth:
            excuteMonthLabelMoveToLeftAnimation()
        case .noWhere:
            Vibrator.vibrate(withImpactLevel: .light)
            
        }
        
        
    }
    
    private func updateMonthLabelWithoutAnimation() {
        self.currentMonthLabel.text = self.currentCalendarPage.currentYearAndMonthInString
    }
    
    private func excuteTimeMachineButtonAnimation() {
        UIView.animate(withDuration: 5, delay: 0, options: .curveLinear, animations: {
            self.timeMachineButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi )
        })
    }
    
    var transitioningDeletage: TimeMachineTransitioningDelegate? = nil
    var originalParentViewController: UIViewController? = nil
    
    func presentTimeMachineView() {
        Vibrator.vibrate(withImpactLevel: .medium)
       
        if let toViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimeMachineViewController") as? TimeMachineViewController {
            
            transitioningDeletage = TimeMachineTransitioningDelegate(from: self, to: toViewController)
            originalParentViewController = self.parent
            self.removeFromParent() // remove its original parent controler: ItemDetailViewController
            toViewController.transitioningDelegate = transitioningDeletage!
            toViewController.modalPresentationStyle = .fullScreen
  
            self.delegate = toViewController
            self.state = .timeMachine
            self.present(toViewController, animated: true)
        }
       
    }
    
    func updatePunchedInDates() {
        
        for makingUpDate in self.punchInMakingUpDates {
            self.item?.punchInDates.append(makingUpDate)
        }
        self.punchInMakingUpDates.removeAll()
       
        updateUI()
        
    }
    
    func callDelegateMethod() {
        switch userDidGo {
        case .lastMonth:
            
            if self.state == .timeMachine {
                self.delegate?.calendarPageDidGoLastMonth()
            }
        case .startMonth:
            
            if self.state == .timeMachine {
                self.delegate?.calendarPageDidGoStartMonth()
            }
        case .thisMonth:
            
            if self.state == .timeMachine {
                self.delegate?.calendarPageDidGoThisMonth()
            }
        case .nextMonth:
    
            if self.state == .timeMachine {
                self.delegate?.calendarPageDidGoNextMonth()
            }
        case .noWhere:
            if self.state == .timeMachine {
                self.delegate?.calendarPageDidGoNowhere()
            }
            self.updateMonthLabelWithoutAnimation()
        }
        
    }
    
   

}

extension CalendarViewController: UIObserver {
    func updateUI() {
        self.timeMachineButton.tintColor = self.engine.userSetting.themeColor
        
        self.callDelegateMethod()
        self.updateCalendarPage(type: userDidGo)
        self.bottomCollectionView.reloadData()
        
        if self.state == .normal {
            updateMonthLabelWithAnimation()
        } else if self.state == .timeMachine {
            updateMonthLabelWithoutAnimation()
        }
        
       
       
    }
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @objc func cellButtonPressed(_ sender: UIButton) {
        
        Vibrator.vibrate(withImpactLevel: .light)
        if let pressedCell = self.bottomCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? CalendarCell {
            
            if pressedCell.state == .selected {
    
                pressedCell.updateAppearence(withType: .unselected, cellDay: sender.currentTitle ?? "?")
                
                var index = 0
                for makingUpDate in self.punchInMakingUpDates {
            
                    if makingUpDate == CustomDate(year: self.currentCalendarPage.year, month: self.currentCalendarPage.month, day: Int(sender.currentTitle ?? "1") ?? 1) {
                        self.punchInMakingUpDates.remove(at: index)
                    }
                    index += 1
                }

            } else {
                
                pressedCell.updateAppearence(withType: .selected, cellDay: sender.currentTitle ?? "?")
                self.punchInMakingUpDates.append(CustomDate(year: self.currentCalendarPage.year, month: self.currentCalendarPage.month, day: Int(sender.currentTitle ?? "1") ?? 1))
                
              
            }

            
        }
          
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 42
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        let dayNumber = indexPath.row - self.currentCalendarPage.weekdayOfFirstDay + 1
        cell.dayButton.tag = indexPath.row
        cell.dayButton.addTarget(self, action: #selector(self.cellButtonPressed(_:)), for: .touchUpInside)
        
        if self.currentCalendarPage.year == self.engine.currentDate.year && self.currentCalendarPage.month == self.engine.currentDate.month && dayNumber == self.engine.currentDate.day {
            
            cell.addDotToBottom(withColor: UIColor.label.withAlphaComponent(0.3))
            print("HHHH")
            
        } else if self.currentCalendarPage.year == self.item!.creationDate.year && self.currentCalendarPage.month == self.item!.creationDate.month && dayNumber == self.item!.creationDate.day {
            
            cell.addDotToBottom(withColor: self.engine.userSetting.themeColor.withAlphaComponent(0.5))
        }
        

        if indexPath.row <= self.currentCalendarPage.weekdayOfFirstDay - 1 { //Before the first day
          
            let lastMonthCalendarPage = CalendarPage(year: self.lastPageYear, month: self.lastPageMonth, item: item!)
            let lastMonthDayNumber = (lastMonthCalendarPage.days - self.currentCalendarPage.weekdayOfFirstDay) + (indexPath.row + 1)
            
            if lastMonthCalendarPage.punchedInDays.contains(lastMonthDayNumber) { // last month punchedIn day
                cell.updateAppearence(withType: .nothThisMonthPunchedIn, cellDay: String(lastMonthDayNumber))
            } else {
                cell.updateAppearence(withType: .notThisMonthMissedDay, cellDay: String(lastMonthDayNumber))
            }
            

        } else if indexPath.row >  self.currentCalendarPage.weekdayOfFirstDay - 1 && indexPath.row < self.currentCalendarPage.days + self.currentCalendarPage.weekdayOfFirstDay { // Between the firstday And Last Day
  
            if self.currentCalendarPage.punchedInDays.contains(dayNumber) { // punchedIn day
                cell.updateAppearence(withType: .punchedInDay, cellDay: String(dayNumber))
            
            } else if self.punchInMakingUpDates.contains(CustomDate(year: self.currentCalendarPage.year, month: self.currentCalendarPage.month, day: dayNumber)) { // selected punched in day
                cell.updateAppearence(withType: .selected, cellDay: String(dayNumber))
            } else {
                cell.updateAppearence(withType: .missedDay, cellDay: String(dayNumber))
            }
            
        } else { // After lastday
            let nextMonthCalendarPage = CalendarPage(year: self.nextPageYear, month: self.nextPageMonth, item: item!)
            let nextMonthDayNumber = (indexPath.row + 1) - (self.currentCalendarPage.days + self.currentCalendarPage.weekdayOfFirstDay)
            
            if nextMonthCalendarPage.punchedInDays.contains(nextMonthDayNumber) { // next month punchedIn day
                cell.updateAppearence(withType: .nothThisMonthPunchedIn, cellDay: String(nextMonthDayNumber))
            } else {
                cell.updateAppearence(withType: .notThisMonthMissedDay, cellDay: String(nextMonthDayNumber))
            }
            
            
        }
        
       
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width - 2) / 9, height: (collectionView.frame.width - 2) / 9)
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



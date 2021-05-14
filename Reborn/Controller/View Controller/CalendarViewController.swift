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
    func calendarPageDidGoSameMonth()
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

    @IBOutlet var startDayDot: UIView!
    @IBOutlet var todayDot: UIView!
    
    private let setting: SystemSetting = SystemSetting.shared
    private let engine: AppEngine = AppEngine.shared
    private var storedState: CalendarState = .normal
    private var originalKeys: Int = AppEngine.shared.currentUser.energy
    
    public lazy var currentCalendarPage: CalendarPage = CalendarPage(year: CustomDate.current.year, month: CustomDate.current.month, item: item)
    public var monthLabelOriginalCordinateX: CGFloat = 0
    public var item: Item!
    public var calendarLoaded: Bool = false
    public var delegate: CalendarViewDegelagte?
    public var lastViewController: UIViewController?

    //public var storedMonthInterval: Int = 0
    public var userDidGo: NewCalendarPage = .thisMonth
    public var punchInMakingUpDates: Array<CustomDate> = []
    public var selectedDays: Int {
        return punchInMakingUpDates.count
    }

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
        
        todayDot.setCornerRadius()
        startDayDot.setCornerRadius()
        
        todayDot.backgroundColor = .label
        startDayDot.backgroundColor = engine.userSetting.themeColor.uiColor
    
        monthLabelOriginalCordinateX = currentMonthLabel.frame.origin.x
        //userDidGo = .startMonth // new
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewLayoutMarginsDidChange() {
      
    }
    


    
    
    func updateCurrentCalendarPage(whenUserDidGo type: NewCalendarPage) {
         
      
        switch type {
        case .lastMonth: self.currentCalendarPage = CalendarPage(year: lastPageYear, month: lastPageMonth, item: item)
            
        case .nextMonth: self.currentCalendarPage = CalendarPage(year: nextPageYear, month: nextPageMonth, item: item)
            
        case .startMonth: self.currentCalendarPage = CalendarPage(year: self.item.creationDate.year, month: self.item.creationDate.month, item: item)
            
        case .thisMonth: self.currentCalendarPage = CalendarPage(year: CustomDate.current.year, month: CustomDate.current.month, item: item)
            
        case .sameMonth: self.currentCalendarPage = CalendarPage(year: self.currentCalendarPage.year, month: self.currentCalendarPage.month, item: item)
            
        case .noWhere: break
        }
        
        if self.state == .normal {
            
            updateMonthLabel(animated: true)
            
        } else if self.state == .timeMachine {
            
            updateMonthLabel(animated: false)
            
        }
        
        
        self.userDidGo = .noWhere
    
    }
    
    @IBAction func startMonthButtonPressed(_ sender: UIButton!) {
        Vibrator.vibrate(withImpactLevel: .light)
        //self.item.creationDate = CustomDate(year: 2018, month: 12, day: 12) // For Test
        
        if self.currentCalendarPage.month == self.item.creationDate.month && self.currentCalendarPage.year == self.item.creationDate.year {
            self.userDidGo = .sameMonth
        } else {
            self.userDidGo = .startMonth
        }
        
        updateUI()
       
    }

    @IBAction func thisMonthButtonPressed(_ sender: UIButton!) {
        
        Vibrator.vibrate(withImpactLevel: .light)
        if self.currentCalendarPage.month == CustomDate.current.month && self.currentCalendarPage.year == CustomDate.current.year {
            self.userDidGo = .sameMonth
        } else {
            self.userDidGo = .thisMonth
        }
        updateUI()
    }
    
    @IBAction func lastMonthButtonPressed(_ sender: Any) {
        Vibrator.vibrate(withImpactLevel: .light)
        self.userDidGo = .lastMonth
        updateUI()
    }
    
    @IBAction func nextMonthButtonPressed(_ sender: Any) {
        Vibrator.vibrate(withImpactLevel: .light)
        self.userDidGo = .nextMonth
        updateUI()
    }
    
    @IBAction func timeMachineButtonPressed(_ sender: Any) {
        self.userDidGo = .sameMonth
        
        if let itemDetailViewController = self.lastViewController as? ItemDetailViewController {
            itemDetailViewController.verticalScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } // If not at the top scroll to the top
        
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
    
    private func monthLabelMoveToRight() {
        let directionAttribute = -1
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.currentMonthLabel.frame.origin.x -= CGFloat(20 * directionAttribute)
            self.currentMonthLabel.layer.opacity = 0
        }) { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.currentMonthLabel.frame.origin.x += CGFloat(40 * directionAttribute)
            }) { _ in
                self.changeMonthLabelText()
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                    self.currentMonthLabel.layer.opacity = 1
                    self.currentMonthLabel.frame.origin.x = self.monthLabelOriginalCordinateX
                })
            }
        }
    }
    
    private func monthLabelMoveToLeft() {
        let directionAttribute = 1
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.currentMonthLabel.frame.origin.x -= CGFloat(20 * directionAttribute)
            self.currentMonthLabel.layer.opacity = 0
        }) { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.currentMonthLabel.frame.origin.x += CGFloat(40 * directionAttribute)
            }) { _ in
                self.changeMonthLabelText()
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
    
    private func monthLabelFadeIn() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            
            self.currentMonthLabel.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.changeMonthLabelText()
                self.currentMonthLabel.alpha = 1
            }) { _ in
            }
        }
    }
    
    private func changeMonthLabelText() {
        self.currentMonthLabel.text = self.currentCalendarPage.currentYearAndMonthInString
    }
    
    private func updateMonthLabel(animated: Bool) {
        
        if animated {
            
            switch userDidGo {
            case .lastMonth: monthLabelMoveToRight()
            case .nextMonth: monthLabelMoveToLeft()
            case .thisMonth, .startMonth: monthLabelFadeIn()
            case .sameMonth: break
            case .noWhere: break
            }
            
        } else {
            changeMonthLabelText()
        }
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

            toViewController.calendarViewController = self
            
            self.delegate = toViewController
            self.state = .timeMachine
            self.present(toViewController, animated: true)
        }
        
        updateUI()
       
    }
    
   
    
    func callDelegateMethod() {
        switch userDidGo {
        case .lastMonth: self.delegate?.calendarPageDidGoLastMonth()
        case .startMonth: self.delegate?.calendarPageDidGoStartMonth()
        case .thisMonth: self.delegate?.calendarPageDidGoThisMonth()
        case .nextMonth: self.delegate?.calendarPageDidGoNextMonth()
        case .sameMonth: self.delegate?.calendarPageDidGoSameMonth(); self.updateMonthLabel(animated: false)
        case .noWhere: break
        }
       
        
    }
    
    func updateButtons() {
        if self.state == .timeMachine {
            self.startMonthButton.isUserInteractionEnabled = false
            self.thisMonthButton.isUserInteractionEnabled = false
            self.timeMachineButton.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5) {
                self.startMonthButton.alpha = 0
                self.thisMonthButton.alpha = 0
                self.todayDot.alpha = 0
                self.startDayDot.alpha = 0
            }
            
        } else if self.state == .normal {
            self.startMonthButton.isUserInteractionEnabled = true
            self.thisMonthButton.isUserInteractionEnabled = true
            self.timeMachineButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5) {
                self.startMonthButton.alpha = 1
                self.thisMonthButton.alpha = 1
                self.todayDot.alpha = 1
                self.startDayDot.alpha = 1
                
                
            }
        }
        
    }
    
   

}

extension CalendarViewController: UIObserver {
    func updateUI() {
 
        self.timeMachineButton.tintColor = self.engine.userSetting.themeColor.uiColor
        self.state == .timeMachine ? self.callDelegateMethod() : ()
        self.updateCurrentCalendarPage(whenUserDidGo: self.userDidGo)
        self.updateButtons()
        self.bottomCollectionView.reloadData()
       
    }
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func renderLastMonthCells() {
        
    }
    
    func renderThisMonthCells() {
        
    }
    
    func renderNextMonthCells() {
        
    }
    
    @objc func cellButtonPressed(_ sender: UIButton) {
        
        Vibrator.vibrate(withImpactLevel: .light)

        if let pressedCell = self.bottomCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? CalendarCell {
            
            if self.punchInMakingUpDates.contains(pressedCell.date) {

                var index = 0 // Delete making up day
                for makingUpDate in self.punchInMakingUpDates {

                    if makingUpDate == CustomDate(year: self.currentCalendarPage.year, month: self.currentCalendarPage.month, day: Int(sender.currentTitle ?? "1") ?? 1) {
                        self.punchInMakingUpDates.remove(at: index)
                    }
                    index += 1
                }

            } else { // add making up day

                self.punchInMakingUpDates.append(CustomDate(year: self.currentCalendarPage.year, month: self.currentCalendarPage.month, day: Int(sender.currentTitle ?? "1") ?? 1))
//
            }

            self.updateUI()
            self.engine.notifyUIObservers(withIdentifier: "TimeMachineViewController")
            
            
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
        
 
        if indexPath.row <= self.currentCalendarPage.weekdayOfFirstDay - 1 {
            //Before the first day
        
            
            let lastMonthCalendarPage = CalendarPage(year: self.lastPageYear, month: self.lastPageMonth, item: item)
            let lastMonthDayNumber = (lastMonthCalendarPage.days - self.currentCalendarPage.weekdayOfFirstDay) + (indexPath.row + 1)
            
            cell.date = CustomDate(year: lastMonthCalendarPage.year, month: lastMonthCalendarPage.month, day: lastMonthDayNumber)
            if lastMonthCalendarPage.punchedInDays.contains(lastMonthDayNumber) {
                // last month punchedIn day
                cell.updateUI(withType: .grayedOutWithColorFill, selectable: false, cellDay: String(lastMonthDayNumber))
            } else {
                cell.updateUI(withType: .grayedOutWithoutColorFill, selectable: false, cellDay: String(lastMonthDayNumber))
            }
            
            if self.state == .timeMachine && DateCalculator.calculateDayDifferenceBetween(CustomDate(year: self.currentCalendarPage.year, month: self.currentCalendarPage.month, day: dayNumber), to: CustomDate.current) < 0 { // day after today in timemachine
                cell.updateUI(withType: .grayedOutWithoutColorFill, selectable: false, cellDay: String(lastMonthDayNumber))
                          
            }
            

        } else if indexPath.row >  self.currentCalendarPage.weekdayOfFirstDay - 1 && indexPath.row < self.currentCalendarPage.days + self.currentCalendarPage.weekdayOfFirstDay {
            // Between the firstday And Last Day
            cell.date = CustomDate(year: currentCalendarPage.year, month: currentCalendarPage.month, day: dayNumber)
            
            if self.currentCalendarPage.punchedInDays.contains(dayNumber) { // punchedIn day

                cell.updateUI(withType: .normalWithColorFill, selectable: false, cellDay: String(dayNumber))
            
            } else if self.punchInMakingUpDates.contains(CustomDate(year: self.currentCalendarPage.year, month: self.currentCalendarPage.month, day: dayNumber)) {
                // selected making up day
                cell.updateUI(withType: .normalWithColorEdge, selectable: self.state == .timeMachine ? true : false, cellDay: String(dayNumber))
                
            } else if self.state == .timeMachine && DateCalculator.calculateDayDifferenceBetween(CustomDate(year: self.currentCalendarPage.year, month: self.currentCalendarPage.month, day: dayNumber), to: CustomDate.current) < 0 { // day after today in timemachine
                cell.updateUI(withType: .grayedOutWithoutColorFill, selectable: false, cellDay: String(dayNumber))
                
            } else {

                cell.updateUI(withType: .normalWithoutColorFill, selectable: self.state == .timeMachine ? true : false, cellDay: String(dayNumber))
            }
            
            
            if self.currentCalendarPage.year == CustomDate.current.year && self.currentCalendarPage.month == CustomDate.current.month && dayNumber == CustomDate.current.day {
                // today dot
                cell.addDotToBottom(withColor: UIColor.label.withAlphaComponent(1))
            }
            
            if self.currentCalendarPage.year == self.item.creationDate.year && self.currentCalendarPage.month == self.item.creationDate.month && dayNumber == self.item.creationDate.day {
                // start date dot
                cell.addDotToBottom(withColor: self.engine.userSetting.themeColor.uiColor.withAlphaComponent(1))

            }
            
            
        } else { // After lastday
           

           
            let nextMonthCalendarPage = CalendarPage(year: self.nextPageYear, month: self.nextPageMonth, item: item)
            let nextMonthDayNumber = (indexPath.row + 1) - (self.currentCalendarPage.days + self.currentCalendarPage.weekdayOfFirstDay)
            cell.date = CustomDate(year: nextMonthCalendarPage.year, month: nextMonthCalendarPage.month, day: nextMonthDayNumber)
            if nextMonthCalendarPage.punchedInDays.contains(nextMonthDayNumber) { // next month punchedIn day
                cell.updateUI(withType: .grayedOutWithColorFill, selectable: false, cellDay: String(nextMonthDayNumber))
            } else {
                cell.updateUI(withType: .grayedOutWithoutColorFill, selectable: false, cellDay: String(nextMonthDayNumber))
            }
            
            if self.state == .timeMachine && DateCalculator.calculateDayDifferenceBetween(CustomDate(year: self.currentCalendarPage.year, month: self.currentCalendarPage.month, day: dayNumber), to: CustomDate.current) < 0 { // day after today in timemachine
                               cell.updateUI(withType: .grayedOutWithoutColorFill, selectable: false, cellDay: String(nextMonthDayNumber))
                          
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



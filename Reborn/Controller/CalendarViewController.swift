//
//  CalendarViewController.swift
//  Reborn
//
//  Created by Christian Liu on 13/1/21.
//

import UIKit
enum NewCalendarPage {
    case lastMonth
    case startMonth
    case noWhere
    case thisMonth
    case nextMonth
}

enum CalendarState {
    case normal
    case timeMachine
}

protocol CalendarViewDegelagte {
    func calendarCellDidLayout(size: CGSize)
    
    func calendarPageDidGoLastMonth()
    func calendarPageDidGoNextMonth()
    func calendarPageDidGoStartMonth()
    func calendarPageDidGoThisMonth()
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
    
    var monthLabelOriginalCordinateX: CGFloat = 0
    
    var item: Item?
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let engine: AppEngine = AppEngine.shared
    var calendarLoaded: Bool = false
    
    var currentCalendarPage: CalendarPage?
    
    var delegate: CalendarViewDegelagte?
    var superViewController: UIViewController?
    private var storedState: CalendarState = .normal
    
    var state: CalendarState {
        get {
            return storedState
        }
        
        set {
            storedState = newValue
            updateUI()
        }
        
    }
    
    
    var lastPageYear: Int {
        if self.currentCalendarPage!.month - 1 < 1 {
            return self.currentCalendarPage!.year - 1
        } else {
            return self.currentCalendarPage!.year
        }
    }
    
    var lastPageMonth: Int {
        if self.currentCalendarPage!.month - 1 < 1 {
            return 12
        } else {
            return self.currentCalendarPage!.month - 1
        }
    }
    
    var nextPageYear: Int {
        if self.currentCalendarPage!.month + 1 > 12 {
            return self.currentCalendarPage!.year + 1
        } else {
            return self.currentCalendarPage!.year
        }
    }
    
    
    var nextPageMonth: Int {
        if self.currentCalendarPage!.month + 1 > 12 {
            return 1
        } else {
            return self.currentCalendarPage!.month + 1
        }
    }
    
    var userDidGo: NewCalendarPage = .noWhere
        
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
       
        if let layout = bottomCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
        }
        
        view.layer.cornerRadius = setting.itemCardCornerRadius
    
        view.clipsToBounds = true
        
        lastMonthButton.layer.cornerRadius = setting.calendarFunctionButtonCornerRadius
        //lastMonthButton.setViewShadow()
        nextMonthButton.layer.cornerRadius = setting.calendarFunctionButtonCornerRadius
    
        //nextMonthButton.setViewShadow()
        startMonthButton.layer.cornerRadius = setting.calendarFunctionButtonCornerRadius
        //startDayButton.setViewShadow()
        thisMonthButton.layer.cornerRadius = setting.calendarFunctionButtonCornerRadius
        //todayButton.setViewShadow()
        
        
       
        currentCalendarPage = CalendarPage(year: self.engine.currentDate.year, month: self.engine.currentDate.month, punchedInDays: self.getPunchedInDays(pageYear: self.engine.currentDate.year, pageMonth: self.engine.currentDate.month))
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
    
 


    
    private func getPunchedInDays(pageYear year: Int, pageMonth month: Int) -> Array<Int> {
        var punchedInDays: Array<Int> = []
        if self.item != nil {
            for punchedInDate in self.item!.punchInDates { // add all punched in date into punchedInDays array
                if punchedInDate.year == year && punchedInDate.month == month {
                    punchedInDays.append(punchedInDate.day)
                }
            }
        }
       
        return punchedInDays
    }
    
    
    func updateCalendarPage(type: NewCalendarPage) {
         
       
        
        let newCalendarPage: CalendarPage
  

        if type == .lastMonth {
            newCalendarPage = CalendarPage(year: lastPageYear, month: lastPageMonth, punchedInDays: self.getPunchedInDays(pageYear: lastPageYear, pageMonth: lastPageMonth))
            self.currentCalendarPage! = newCalendarPage

           
        } else if type == .nextMonth {
            newCalendarPage = CalendarPage(year: nextPageYear, month: nextPageMonth, punchedInDays:  self.getPunchedInDays(pageYear: nextPageYear, pageMonth: nextPageMonth))
            self.currentCalendarPage! = newCalendarPage
   
        }
            
    }
    
    @IBAction func startMonthButtonPressed(_ sender: UIButton!) {
        self.item!.creationDate = CustomDate(year: 2018, month: 12, day: 12)
        
        
        if item != nil {
            
            if state == .normal {
                
                let startDate = item!.creationDate
                self.currentCalendarPage! = CalendarPage(year: startDate.year, month: startDate.month, punchedInDays: getPunchedInDays(pageYear: startDate.year, pageMonth: startDate.month))
        
                self.updateUI()
                self.delegate?.calendarPageDidGoStartMonth()
            } else if state == .timeMachine {
                
            }
            
          
        }
       
    }
    
    @objc func clickLastMonth() {
        self.lastMonthButtonPressed(UIButton())
    }
    
    
    
    @IBAction func thisMonthButtonPressed(_ sender: UIButton!) {
        
        
        self.currentCalendarPage! = CalendarPage(year: self.engine.currentDate.year, month: self.engine.currentDate.month, punchedInDays: self.getPunchedInDays(pageYear: self.engine.currentDate.year, pageMonth: self.engine.currentDate.month))
        self.updateUI()
        self.delegate?.calendarPageDidGoThisMonth()
    }
    
    @IBAction func lastMonthButtonPressed(_ sender: Any) {
        self.userDidGo = .lastMonth

        self.updateCalendarPage(type: .lastMonth)
        self.updateUI()
        self.delegate?.calendarPageDidGoLastMonth()
       
    }
    
    @IBAction func nextMonthButtonPressed(_ sender: Any) {
        self.userDidGo = .nextMonth

        self.updateCalendarPage(type: .nextMonth)
        updateUI()
        self.delegate?.calendarPageDidGoNextMonth()
    }
    
    @IBAction func timeMachineButtonPressed(_ sender: Any) {
        if let viewController = superViewController as? ItemDetailViewController {
            viewController.goTimeMachineView()
        }
       
    }
    
    private func updateMonthLabelWithAnimation() {
        
        var directionAttribute: Int
        switch userDidGo {
        case .lastMonth:
            directionAttribute = 1
        case .startMonth:
            directionAttribute = 1
        case .thisMonth:
            directionAttribute = -1
        case .nextMonth:
            directionAttribute = -1
        case .noWhere:
            directionAttribute = 0
        }
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.currentMonthLabel.frame.origin.x -= CGFloat(20 * directionAttribute)
            self.currentMonthLabel.layer.opacity = 0
        }) { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.currentMonthLabel.frame.origin.x += CGFloat(40 * directionAttribute)
            }) { _ in
                self.currentMonthLabel.text = self.currentCalendarPage!.currentYearAndMonthInString
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                    self.currentMonthLabel.layer.opacity = 1
                    self.currentMonthLabel.frame.origin.x = self.monthLabelOriginalCordinateX
                }) { _ in
                    
                }
            }
        }
    }
    
    private func updateMonthLabelWithoutAnimation() {
        self.currentMonthLabel.text = self.currentCalendarPage!.currentYearAndMonthInString
    }
    
    private func excuteTimeMachineButtonAnimation() {
        UIView.animate(withDuration: 5, delay: 0, options: .curveLinear, animations: {
            self.timeMachineButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi )
        })
    }
    
    func updateUI() {
        
        self.bottomCollectionView.reloadData()
        
        if self.state == .normal {
            updateMonthLabelWithAnimation()
        } else if self.state == .timeMachine {
            updateMonthLabelWithoutAnimation()
            //excuteTimeMachineButtonAnimation()
        }
       
    }
    
    

}



extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 42
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
       

        if indexPath.row < (self.currentCalendarPage!.weekdayOfFirstDay) - 1 { //Before the first day

            cell.contentView.backgroundColor = .clear

        } else if indexPath.row >  self.currentCalendarPage!.weekdayOfFirstDay - 1 && indexPath.row < self.currentCalendarPage!.days + self.currentCalendarPage!.weekdayOfFirstDay { // Between the firstday And Last Day

            let dayNumber = indexPath.row - self.currentCalendarPage!.weekdayOfFirstDay + 1

            cell.dayLabel.text = String(dayNumber)
            
            if self.currentCalendarPage!.punchedInDays.contains(dayNumber) { // punchedIn day UI
                cell.contentView.backgroundColor = UserStyleSetting.themeColor
                cell.dayLabel.textColor = .white
            }

        } else { // After lastday
            cell.contentView.backgroundColor = .clear
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



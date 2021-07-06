//
//  TimeMachineCalendarPageBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 29/1/21.
//

import Foundation
import UIKit

class TimeMachineCalendarPageViewBuilder: ViewBuilder {
    
    
    
    var referenceCalendarPage: CalendarPage
    var outputView: UIView = UIView()
    var calendarView: UIView
    var monthDifference: Int
    
    init(interactableCalendarView calendarView: UIView, referenceCalendarPage: CalendarPage, monthDifference: Int) {
        
        self.calendarView = calendarView
        self.referenceCalendarPage = referenceCalendarPage
        self.monthDifference = monthDifference
    }
    
    func buildView() -> UIView {
        createView()
        addTopView()
        addMiddleView()
        addBottomView()
        return outputView
    }
    
    func createView() {
        self.outputView.accessibilityIdentifier = "TempCalendarPageView"
        self.outputView.frame = calendarView.frame
        
        self.outputView.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackContent
        self.outputView.layer.cornerRadius = calendarView.layer.cornerRadius
        

    }
    
    
    private func addTopView() {
        let topView = UIView()
        topView.backgroundColor = .clear
        if let referenceView = self.calendarView.getSubviewBy(idenifier: "TopView") {
            
            topView.frame = referenceView.frame
           
            
            if let referenceLabel = referenceView.getSubviewBy(idenifier: "MonthLabel") as? UILabel {
                
                let dateLabel = UILabel()
                dateLabel.frame = referenceLabel.frame
                
                let currentYear = referenceCalendarPage.year
                let currentMonth = referenceCalendarPage.month
                let currentDay = referenceCalendarPage.days
                
                let newDate = DateCalculator.calculateDate(withMonthDifference: self.monthDifference, originalDate: CustomDate(year: currentYear, month: currentMonth, day: currentDay))
                dateLabel.text = "\(newDate.year)年 \(newDate.month)月"
                topView.addSubview(dateLabel)
            }
            
            let buttonsIdentifier = ["TimeMachineButton", "LastMonthButton", "StartMonthButton", "ThisMonthButton", "NextMonthButton"]
            
            for identifier in buttonsIdentifier {
                
                if let referenceButton = referenceView.getSubviewBy(idenifier: identifier) as? UIButton {
                    
                    let button = UIButton()
                    button.frame = referenceButton.frame
                    button.setImage(referenceButton.currentImage, for: .normal)
                    button.setTitle(referenceButton.currentTitle, for: .normal)
                    button.alpha = referenceButton.alpha
                    button.setTitleColor(referenceButton.currentTitleColor, for: .normal)
                    button.tintColor = referenceButton.tintColor
                    topView.addSubview(button)
                }
            }
            
           
        
        }
        
        self.outputView.addSubview(topView)
    }
    
    private func addMiddleView() {
        let middleView = UIView()
        middleView.backgroundColor = .clear
        if let referenceView = self.calendarView.getSubviewBy(idenifier: "MiddleView") {
            middleView.frame = referenceView.frame
            
            
            
            if let referenceStackView = referenceView.subviews.first as? UIStackView {
                
                let stackView = UIStackView()
                stackView.frame = referenceStackView.frame
                stackView.distribution = referenceStackView.distribution
                middleView.addSubview(stackView)
                
                for referenceLabel in referenceStackView.subviews {
                    if let referenceLabel = referenceLabel as? UILabel {
                        let dayLabel = UILabel()
                        dayLabel.frame = referenceLabel.frame
                        dayLabel.text = referenceLabel.text
                        dayLabel.textColor = referenceLabel.textColor
                        dayLabel.tintColor = referenceLabel.tintColor
                        
                        stackView.addSubview(dayLabel)

                    }
                }
                
                
            }
            
        }
        self.outputView.addSubview(middleView)
    }
    
    private func addBottomView() {
        
    }
    
    
  
    
    
}

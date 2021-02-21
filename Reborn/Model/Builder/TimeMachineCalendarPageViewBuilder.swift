//
//  TimeMachineCalendarPageBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 29/1/21.
//

import Foundation
import UIKit

class TimeMachineCalendarPageViewBuilder {
    
    
    var calendarViewController: CalendarViewController
    var outputCalendarpageView: UIView? = nil
    var calendarView: UIView
    var monthDifference: Int
    
    init(interactableCalendarView calendarView: UIView, calendarViewController: CalendarViewController, monthDifference: Int) {
        
        self.calendarView = calendarView
        self.calendarViewController = calendarViewController
        self.monthDifference = monthDifference
    }
    
    public func buildCalendarPage() -> UIView {
        createCalendarPageView()
        
        addTopView()
        addMiddleView()
        addBottomView()
        return outputCalendarpageView!
        
    }
    
    private func createCalendarPageView() {
        self.outputCalendarpageView = UIView()
        self.outputCalendarpageView?.frame = calendarView.frame
        self.outputCalendarpageView?.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackContent
        self.outputCalendarpageView?.layer.cornerRadius = calendarView.layer.cornerRadius
        
    }
    
    private func addTopView() {
        let topView = UIView()
        
        if let referenceView = self.getSubviewByIdentifier(superview: self.calendarView, identifier: "TopView") {
            
            topView.frame = referenceView.frame
            
            
            if let referenceLabel = self.getSubviewByIdentifier(superview: referenceView, identifier: "MonthLabel") as? UILabel {
                
                let dateLabel = UILabel()
                dateLabel.frame = referenceLabel.frame
                
                let currentYear = self.calendarViewController.currentCalendarPage.year
                let currentMonth = self.calendarViewController.currentCalendarPage.month
                let currentDay = self.calendarViewController.currentCalendarPage.days
                
                let newDate = DateCalculator.calculateDate(withMonthDifference: self.monthDifference, originalDate: CustomDate(year: currentYear, month: currentMonth, day: currentDay))
                dateLabel.text = "\(newDate.year)年 \(newDate.month)月"
                topView.addSubview(dateLabel)
            }
            
            let buttonsIdentifier = ["TimeMachineButton", "LastMonthButton", "StartMonthButton", "ThisMonthButton", "NextMonthButton"]
            
            for identifier in buttonsIdentifier {
                
                if let referenceButton = self.getSubviewByIdentifier(superview: referenceView, identifier: identifier) as? UIButton {
                    
                    let button = UIButton()
                    button.frame = referenceButton.frame
                    button.setImage(referenceButton.currentImage, for: .normal)
                    button.setTitle(referenceButton.currentTitle, for: .normal)

                    button.setTitleColor(referenceButton.currentTitleColor, for: .normal)
                    button.tintColor = referenceButton.tintColor
                    topView.addSubview(button)
                }
            }
            
           
        
        }
        
        self.outputCalendarpageView?.addSubview(topView)
    }
    
    private func addMiddleView() {
        let middleView = UIView()
        
        if let referenceView = self.getSubviewByIdentifier(superview: self.calendarView, identifier: "MiddleView") {
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
        self.outputCalendarpageView?.addSubview(middleView)
    }
    
    private func addBottomView() {
        
    }
    
    
  
    
    private func getSubviewByIdentifier(superview: UIView, identifier: String) -> UIView? {
        
        for subview in superview.subviews {
            if subview.accessibilityIdentifier == identifier {
                return subview
            }
        }
        return nil
    }
}

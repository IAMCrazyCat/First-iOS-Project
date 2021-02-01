//
//  DateCalculator.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
class DateCalculator {
    private var currentYear: Int = 1997
    private var currentMonth: Int = 4
    open var monthInterval: Int = 0
    private var newYear: Int = 2077
    private var newMonth: Int = 4
    
    open var monthResult: Int {
        if monthInterval < 0 {
            var month = self.currentMonth + self.monthInterval
            while month < 0 {
                month = 12 + month

            }
            
            if month == 0 {
                month = 12
            }
            return month
            
        } else if monthInterval > 0 {
            
            var month = monthInterval % 12 + self.currentMonth
            
            if month > 12 {
                month = month - 12
            }
  
            return month
            
        } else {
            
            return currentMonth
        }
    
    }
    
    open var yearResult: Int {
        if monthInterval < 0 {
            var month = self.currentMonth + self.monthInterval
            var year = 0
            while month < 0 {

                month = 12 + month
                year += 1
            }
            
            if month == 0 {
                month = 12
                year += 1
            }
            
            year = self.currentYear - year
            return year
            
        } else if monthInterval > 0 {
            
            let month = monthInterval % 12 + self.currentMonth
            
            var year = Int(monthInterval / 12) + self.currentYear
            if month > 12 {
                year += 1
                
            }

            return year
            
        } else {
            
            return currentYear
        }
       
      
    }
    
    init(currentYear: Int, currentMonth: Int, monthInterval: Int) {
        self.currentYear = currentYear
        self.currentMonth = currentMonth
        self.monthInterval = monthInterval
    }
    
    init(currentYear: Int, currentMonth: Int, newYear: Int, newMonth: Int) {
        self.currentYear = currentYear
        self.currentMonth = currentMonth
        self.newYear = newYear
        self.newMonth = newMonth
        
        let yearInterval = newYear - currentYear
        self.monthInterval = newMonth - currentMonth
        self.monthInterval = yearInterval * 12 + self.monthInterval
    }
    
    
}

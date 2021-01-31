//
//  DateCalculator.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
class DateCalculator {
    private var currentYear: Int
    private var currentMonth: Int
    private var monthDifference: Int
    
    open var monthResult: Int {
        if monthDifference < 0 {
            var month = self.currentMonth + self.monthDifference
            while month < 0 {
                month = 12 + month

            }
            
            if month == 0 {
                month = 12
            }
            return month
            
        } else if monthDifference > 0 {
            
            var month = monthDifference % 12 + self.currentMonth
            
            if month > 12 {
                month = month - 12
            }
  
            return month
            
        } else {
            
            return currentMonth
        }
    
    }
    
    open var yearResult: Int {
        if monthDifference < 0 {
            var month = self.currentMonth + self.monthDifference
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
            
        } else if monthDifference > 0 {
            
            let month = monthDifference % 12 + self.currentMonth
            
            var year = Int(monthDifference / 12) + self.currentYear
            if month > 12 {
                year += 1
                
            }

            return year
            
        } else {
            
            return currentYear
        }
       
      
    }
    
    init(currentYear: Int, currentMonth: Int, monthDifference: Int) {
        self.currentYear = currentYear
        self.currentMonth = currentMonth
        self.monthDifference = monthDifference
    }
    
    
}

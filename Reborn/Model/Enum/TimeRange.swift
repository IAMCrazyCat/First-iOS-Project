//
//  TimeInterval.swift
//  Reborn
//
//  Created by Christian Liu on 12/2/21.
//

import Foundation
enum TimeRange: Int, CaseIterable {
    case midnight
    case morning
    case noon
    case afternoon
    case night
    
    
    public static var time: DateComponents {
        let date = Date()
        return Calendar.current.dateComponents([.hour,.minute,.second], from: date)
    }
    
    public static var current: TimeRange {

        for timeRange in TimeRange.allCases {

            if timeRange.range.contains(self.time.hour!) {
                
                return timeRange
            }
        }
        return .morning
    }
    
    var range: Range<Int> {
        switch self {
        case .midnight: return 0 ..< 6
        case .morning: return 6 ..< 12
        case .noon: return 12 ..< 15
        case .afternoon: return 15 ..< 18
        case .night: return 18 ..< 24
        
        }
    }
}

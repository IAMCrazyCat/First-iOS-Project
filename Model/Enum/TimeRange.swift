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

    
    var range: Range<Int> {
        switch self {
        case .midnight: return 0 ..< 6
        case .morning: return 6 ..< 12
        case .noon: return 12 ..< 15
        case .afternoon: return 15 ..< 20
        case .night: return 20 ..< 24
        
        }
    }
}

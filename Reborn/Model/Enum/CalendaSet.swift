//
//  CalendarCellState.swift
//  Reborn
//
//  Created by Christian Liu on 5/2/21.
//

import Foundation

enum CalendarCellState {
    case selected
    case unselected
}

enum CalendarCellType {
    case punchedInDay
    case breakDay
    case missedDay
    case notThisMonthMissedDay
    case nothThisMonthPunchedIn
    case selected
    case unselected
    case unselectedInTimeMachine
    case dayAfterTodayInTimeMachine
}

enum CalendarState {
    case normal
    case timeMachine
}


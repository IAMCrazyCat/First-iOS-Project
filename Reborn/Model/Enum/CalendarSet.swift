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
    case normalWithColorFill
    case normalWithoutColorFill
    case normalWithColorEdge
    case grayedOutWithColorFill
    case grayedOutWithoutColorFill
    case unselected

}

enum CalendarState {
    case normal
    case timeMachine
}


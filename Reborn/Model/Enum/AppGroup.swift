//
//  AppGroup.swift
//  Reborn
//
//  Created by Christian Liu on 23/3/21.
//

import Foundation

public enum AppGroup: String {
  case identifier = "group.Reborn.Widget"

  public var containerURL: URL {
    switch self {
    case .identifier:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}

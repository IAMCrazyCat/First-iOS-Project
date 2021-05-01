//
//  Icon.swift
//  Reborn
//
//  Created by Christian Liu on 28/4/21.
//

import Foundation
import UIKit
class Icon: Codable {
    static var forbidden: Icon = Icon(image: #imageLiteral(resourceName: "close"), isVipIcon: false)
    static var defaultIcon1: Icon = Icon(image: #imageLiteral(resourceName: "rocket"), isVipIcon: false, name: "a-default-rocket.png")
    static var defaultIcon2: Icon = Icon(image: #imageLiteral(resourceName: "close"), isVipIcon: false)
    
    private var imageData: Data
    public var image: UIImage {
        return UIImage(data: self.imageData) ?? Icon.defaultIcon1.image
    }
    public var isVipIcon: Bool
    public var name: String
    
    init(image: UIImage, isVipIcon: Bool, name: String = "") {
        self.imageData = image.pngData() ?? Data()
        self.isVipIcon = isVipIcon
        self.name = name
    }
   
}

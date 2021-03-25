//
//  User.swift
//  Reborn
//
//  Created by Christian Liu on 9/1/21.
//

import Foundation
import UIKit


class User: Codable {
    //public static var shared = User(name: String, gender: Gender, avater: UIImageView, keys: Int, items: Array<Item>, vip: Bool)
    var name: String
    var gender: Gender
    var avatar: Data
    var keys: Int
    var items: Array<Item>
    var vip: Bool
    
    //var themeColorSetting: ThemeColor? = nil

    
    public init(name: String, gender: Gender, avatar: UIImage, keys: Int, items: Array<Item>, vip: Bool) {
        self.name = name
        self.gender = gender
        self.avatar = avatar.pngData() ?? Data()
        self.keys = keys
        self.items = items
        self.vip = vip
    }
    
    public func getAvatarImage() -> UIImage {
        return UIImage(data: avatar) ?? UIImage()
    }
    
    public func setAvatarImage(_ image: UIImage) {

        avatar = image.pngData() ?? #imageLiteral(resourceName: "Test").pngData()!

    }
    
    public func getOverAllProgress() -> Double {
        
        var overAllProgress = 0.0
        
        for item in self.items {
           
            if item.targetDays != 0 {
                let itemProgress = Double(item.finishedDays) / Double(item.targetDays)
    
                overAllProgress += itemProgress
            }

        }
        
        if self.items.count != 0 {
            overAllProgress /= Double(self.items.count)
        }
        
        
        return overAllProgress
       
    }
    

}

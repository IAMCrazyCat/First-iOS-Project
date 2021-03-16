//
//  PillSegmentedControlImageFactory.swift
//  Reborn
//
//  Created by Christian Liu on 16/3/21.
//

import Foundation
import UIKit
protocol SegmentedControlImageFactory {
    func background(color: UIColor) -> UIImage?
    func divider(leftColor: UIColor, rightColor: UIColor) -> UIImage?
}

extension SegmentedControlImageFactory {
    func background(color: UIColor) -> UIImage? { return nil }
    func divider(leftColor: UIColor, rightColor: UIColor) -> UIImage? { return nil }
}

struct PillSegmentedControlImageFactory: SegmentedControlImageFactory {
    var size = CGSize(width: 32, height: 32)
    
    func background(color: UIColor) -> UIImage? {
        return UIImage.render(size: size) {
            color.setFill()
            let rect = CGRect(origin: .zero, size: size)
            UIBezierPath(roundedRect: rect, cornerRadius: size.height/2)
                .fill()
        }
    }
    
    func divider(leftColor: UIColor, rightColor: UIColor) -> UIImage? {
        return UIImage.render(size: size) {
            let radius = size.height/2
            
            leftColor.setFill()
            UIBezierPath(arcCenter: CGPoint(x: 0, y: radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: -CGFloat.pi/2, clockwise: false)
                .fill()
            
            rightColor.setFill()
            UIBezierPath(arcCenter: CGPoint(x: size.width, y: radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: -CGFloat.pi/2, clockwise: true)
                .fill()
        }
    }
}

//
//  EraserViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 29/4/21.
//

import Foundation
import UIKit
class EraserViewBuilder: ViewBuilder {
    
    var frame: CGRect
    var item: Item
    var outputView: UIView = UIView()
    init(frame: CGRect, item: Item) {
        self.frame = frame
        self.item = item
    }
    
    
    func buildView() -> UIView {
        createView()
        addImageView()
        addLabel()
        return outputView
    }
    
    func createView() {
        outputView.frame = self.frame
    }
    
    func addImageView() {
        let imageView = UIImageView()
        imageView.frame = self.outputView.bounds
        imageView.image = #imageLiteral(resourceName: "Eraser")
        self.outputView.addSubview(imageView)
        
    }
    
    func addLabel() {
        let firstLabel = UILabel()
        firstLabel.textColor = .white
        firstLabel.text = "DIGITAL ERASER"
        firstLabel.font = .systemFont(ofSize: 20)
        
        self.outputView.addSubview(firstLabel)
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLabel.topAnchor.constraint(equalTo: self.outputView.topAnchor, constant: 10).isActive = true
        firstLabel.centerXAnchor.constraint(equalTo: self.outputView.centerXAnchor).isActive = true
        
        let secondLabel = UILabel()
        secondLabel.textColor = .black
        secondLabel.text = "REBORN"
        secondLabel.font = .systemFont(ofSize: 30)
        
        self.outputView.addSubview(secondLabel)
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.centerYAnchor.constraint(equalTo: self.outputView.centerYAnchor, constant: -10).isActive = true
        secondLabel.centerXAnchor.constraint(equalTo: self.outputView.centerXAnchor).isActive = true
        
        let thirdLabel = UILabel()
        thirdLabel.textColor = .white
        thirdLabel.text = "Deleting \(item.name)"
        thirdLabel.font = .systemFont(ofSize: 15)
        
        self.outputView.addSubview(thirdLabel)
        thirdLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdLabel.bottomAnchor.constraint(equalTo: self.outputView.bottomAnchor, constant: -25).isActive = true
        thirdLabel.centerXAnchor.constraint(equalTo: self.outputView.centerXAnchor).isActive = true
        
        
        
    }
    
    
}

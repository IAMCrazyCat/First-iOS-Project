//
//  NewFeaturesPopUpViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 13/6/21.
//

import Foundation
import UIKit
class NewFeaturesPopUpViewBuilder: PopUpViewBuilder {
    let scrollView = UIScrollView()
    let scrollViewContentView = UIView()
    
    var newFeatures: Array<CustomData>
    init(popUpViewController: PopUpViewController, frame: CGRect, newFeatures: Array<CustomData>) {
        self.newFeatures = newFeatures
        super.init(popUpViewController: popUpViewController, frame: frame)
    }
    
    override func buildView() -> UIView {
        super.buildView()
        addScrollview()
        addContentView()
        addNewFeatureViews()
        return super.outPutView
    }
    
    private func addScrollview() {
        super.contentView.addSubview(scrollView)
        scrollView.accessibilityIdentifier = "ScrollView"
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: super.contentView.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: super.contentView.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: super.contentView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: super.contentView.bottomAnchor).isActive = true
        
        scrollView.layoutIfNeeded()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: scrollView.frame.width, height: 60)
        
    }
    
    private func addContentView() {
       
        scrollViewContentView.accessibilityIdentifier = "ScrollViewContentView"
        scrollViewContentView.frame = CGRect(x: 0, y: 0, width: super.contentView.frame.width, height: super.contentView.frame.height + 10)
        scrollView.addSubview(scrollViewContentView)
//        scrollViewContentView.translatesAutoresizingMaskIntoConstraints = false
//        scrollViewContentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
//        scrollViewContentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
//        scrollViewContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        scrollViewContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    private func addNewFeatureViews() {
        
        func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat{
            let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = font
            label.text = text

            label.sizeToFit()
            return label.frame.height
        }
        
        var featureViewY: CGFloat = 0
        var currentFeatureView: UIView? = nil
        for newFeature in newFeatures {
            super.contentView.layoutIfNeeded()
            let firstLabelFont = AppEngine.shared.userSetting.smallFont.bold()
            let secondLabelFont = AppEngine.shared.userSetting.smallFont
            let labelGap: CGFloat = 5
            let firstLabelHeight = heightForView(text: newFeature.title, font: firstLabelFont, width: self.scrollViewContentView.frame.width - 20)
            let secondLabelHeight = heightForView(text: newFeature.body ?? "", font: secondLabelFont, width: self.scrollViewContentView.frame.width - 20)
            let featureViewHeightAccordingToLabels = firstLabelHeight + labelGap + secondLabelHeight
    
            let featureView = UIView()
            featureView.backgroundColor = .clear
            self.scrollViewContentView.addSubview(featureView)
            featureView.frame = CGRect(x: 0, y: featureViewY, width: self.scrollViewContentView.frame.width, height: featureViewHeightAccordingToLabels)

            let firstLabel = UILabel()
            firstLabel.text = newFeature.title
            firstLabel.font = firstLabelFont
            firstLabel.textColor = .label
            featureView.addSubview(firstLabel)
            
            firstLabel.translatesAutoresizingMaskIntoConstraints = false
            firstLabel.topAnchor.constraint(equalTo: featureView.topAnchor).isActive = true
            firstLabel.rightAnchor.constraint(equalTo: featureView.rightAnchor).isActive = true
            firstLabel.leftAnchor.constraint(equalTo: featureView.leftAnchor, constant: 20).isActive = true
            
            
            let dot = UIView()
            let dotRadius: CGFloat = 5
            dot.backgroundColor = AppEngine.shared.userSetting.themeColor.uiColor
            
            featureView.addSubview(dot)
            
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: dotRadius * 2).isActive = true
            dot.heightAnchor.constraint(equalToConstant: dotRadius * 2).isActive = true
            dot.rightAnchor.constraint(equalTo: firstLabel.leftAnchor, constant: -10).isActive = true
            dot.centerYAnchor.constraint(equalTo: firstLabel.centerYAnchor).isActive = true
            
            dot.setCornerRadius()
            
            let secondLabel = UILabel()
            
            secondLabel.text = newFeature.body
            secondLabel.font = secondLabelFont
            secondLabel.textColor = .label
            secondLabel.lineBreakMode = .byWordWrapping
            secondLabel.numberOfLines = 0
            
            featureView.addSubview(secondLabel)
            secondLabel.translatesAutoresizingMaskIntoConstraints = false
            secondLabel.leftAnchor.constraint(equalTo: firstLabel.leftAnchor).isActive = true
            secondLabel.rightAnchor.constraint(equalTo: firstLabel.rightAnchor).isActive = true
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: labelGap).isActive = true

            featureViewY += 20 + featureView.frame.height
            currentFeatureView = featureView
        }
        
        let height = currentFeatureView?.frame.maxY ?? 500 + 10
        scrollView.contentSize = CGSize(width: super.contentView.frame.width, height: height)
    }
}

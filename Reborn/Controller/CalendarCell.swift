//
//  CalendarCell.swift
//  Reborn
//
//  Created by Christian Liu on 21/1/21.
//

import Foundation
import UIKit
class CalendarCell: UICollectionViewCell {

    static var identifier: String = "CalendarCell"
    
    var calendarPageView: UICollectionView? = nil
    
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    
    var calendarPage: CalendarPage? {
        didSet {
            CalendarPageViewController.shared.calendarPage = self.calendarPage
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.red
        self.setUpUI()
        self.contentView.addSubview(calendarPageView!)
        
    }
    
    private func setUpUI() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.contentView.frame.width / 7, height: self.contentView.frame.height / 6)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        calendarPageView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height), collectionViewLayout: layout)
        calendarPageView!.backgroundColor = UIColor.green//SystemStyleSetting.shared.whiteAndBlack
        calendarPageView!.register(CalendarPageCell.self, forCellWithReuseIdentifier: CalendarPageCell.identifier)
        calendarPageView!.delegate = CalendarPageViewController.shared
        calendarPageView!.dataSource = CalendarPageViewController.shared
     
        calendarPageView!.tag = 11607
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    
    }
    
    override func layoutSubviews() {
        
    }
    
    
    
}

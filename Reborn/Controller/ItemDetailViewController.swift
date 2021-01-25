//
//  ItemDetailViewController.swift
//  Reborn
//
//  Created by Christian Liu on 8/1/21.
//

import UIKit

class ItemDetailViewController: UIViewController, CalendarViewDegelagte {
    
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var mediumView: UIView!
    
    @IBOutlet weak var instructionView: UIView!
    @IBOutlet weak var notInPlanLabel: UILabel!
    @IBOutlet weak var absentLabel: UILabel!
    @IBOutlet weak var presentLabel: UILabel!
    
    @IBOutlet weak var verticallyScrollContentView: UIView!
    
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let engine: AppEngine = AppEngine.shared
    var item: Item? = nil
    
    var dayCellFrame: CGRect? {
        didSet {
            self.notInPlanLabel.frame = dayCellFrame!
            self.notInPlanLabel.layoutIfNeeded()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.layer.cornerRadius = setting.itemCardCornerRadius
        topView.setViewShadow()
        
        calendarView.layer.cornerRadius = setting.itemCardCornerRadius
        calendarView.setViewShadow()
        calendarView.layer.masksToBounds = true
    
//        mediumView.layer.cornerRadius  = setting.itemCardCornerRadius
//        mediumView.setViewShadow()
        
        absentLabel.backgroundColor = .white
        notInPlanLabel.backgroundColor = UserStyleSetting.themeColor.withAlphaComponent(0.5)
        presentLabel.backgroundColor = UserStyleSetting.themeColor
        setUpUI()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? CalendarViewController {
            destinationViewController.item = item
            destinationViewController.delegate = self
        }
        
        
    }
    
    func setUpUI() {
        if item != nil {
            self.verticallyScrollContentView.layoutIfNeeded()
            let builder = ItemViewBuilder(item: item!, width: self.mediumView.frame.width, height: self.setting.itemDetailsViewHeight, corninateX: 0, cordinateY: 0)
            let detailsView = builder.buildDetailsView()
            self.mediumView.addSubview(detailsView)
            print(detailsView)
        }
        
    }
    
    func setUpInstructionLabelsSize(size: CGSize) {
        

        self.absentLabel.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.absentLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        self.absentLabel.layoutIfNeeded()
        self.instructionView.layoutIfNeeded()
        self.absentLabel.layer.cornerRadius = self.absentLabel.frame.width / 2
        self.absentLabel.layer.borderWidth = 0.1
        self.absentLabel.layer.masksToBounds = true
        

        self.notInPlanLabel.centerXAnchor.constraint(equalTo: self.instructionView.centerXAnchor).isActive = true
        self.notInPlanLabel.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.notInPlanLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        self.instructionView.layoutIfNeeded()
        self.notInPlanLabel.layer.cornerRadius = self.notInPlanLabel.frame.width / 2
        self.notInPlanLabel.layer.masksToBounds = true
        

        self.presentLabel.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.presentLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        self.instructionView.layoutIfNeeded()
        self.presentLabel.layer.cornerRadius = self.presentLabel.frame.width / 2
        self.presentLabel.layer.masksToBounds = true
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

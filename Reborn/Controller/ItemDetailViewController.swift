//
//  ItemDetailViewController.swift
//  Reborn
//
//  Created by Christian Liu on 8/1/21.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var recordsView: UIView!
    
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let engine: AppEngine = AppEngine.shared
    var itemID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordsView.layer.cornerRadius = setting.itemCardCornerRadius
        recordsView.setViewShadow()
        print(engine.generateCalendar(itemID: itemID)!)
        if let calendar = engine.generateCalendar(itemID: itemID) {
            
            recordsView.addSubview(calendar)
        }
        
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

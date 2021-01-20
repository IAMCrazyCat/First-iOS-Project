//
//  ItemDetailViewController.swift
//  Reborn
//
//  Created by Christian Liu on 8/1/21.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var calendarView: UIView!
    
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let engine: AppEngine = AppEngine.shared
    var item: Item? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //print(engine.buildCalendar(itemID: itemID)!)
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? CalendarViewController {
            destinationViewController.item = item
            
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

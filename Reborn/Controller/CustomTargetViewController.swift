//
//  CustomTargetViewController.swift
//  Reborn
//
//  Created by Christian Liu on 28/12/20.
//

import UIKit


class CustomTargetViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: 250)
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

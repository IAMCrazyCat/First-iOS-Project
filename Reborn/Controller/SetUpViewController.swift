//
//  SetUpViewController.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import UIKit

class SetUpViewController: UIViewController {

    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var nextStepButton: UIButton!
    
    var setting = StyleSetting()
    override func viewDidLoad() {
        super.viewDidLoad()

        questionTextLabel.font = questionTextLabel.font.withSize(setting.FontNormalSize)
        nextStepButton.layer.cornerRadius = setting.mainButtonCornerRadius
    }
    
    @IBAction func nextStepButtonPressed(_ sender: UIButton) {
        
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

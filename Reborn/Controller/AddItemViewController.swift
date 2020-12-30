//
//  AddItemViewController.swift
//  Reborn
//
//  Created by Christian Liu on 27/12/20.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var middleContentView: UIView!
    @IBOutlet weak var everydayOptionButton: UIButton!
    @IBOutlet weak var mondayToFridayOptionButton: UIButton!
    @IBOutlet weak var weekendOptionButton: UIButton!
    @IBOutlet weak var customizeFrequencyButton: UIButton!
    
    @IBOutlet weak var addFrequencyButton: UIButton!
    @IBOutlet weak var deleteFrequencyButton: UIButton!
    
    let engine = AppEngine.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideAllFrequencyOptionButtons(true)
        updateUI()
    }
    
    func loadPreViewItemCard() {
        let preViewItemCard = engine.generateNewItemCard(name: "", type: "", days: 0)
        preViewItemCard.center = middleContentView.center
        self.middleContentView.addSubview(preViewItemCard)
    }
    
    func hideAllFrequencyOptionButtons(_ isHidden: Bool) {
        everydayOptionButton.isHidden = isHidden
        mondayToFridayOptionButton.isHidden = isHidden
        weekendOptionButton.isHidden = isHidden
        customizeFrequencyButton.isHidden = isHidden
        deleteFrequencyButton.isHidden = isHidden
    }
    
    @IBAction func typeOptionButtonPressed(_ sender: UIButton) {
        print(sender.currentTitle!)
    }
    
    
    @IBAction func targetOptionButtonPressed(_ sender: UIButton) {
        print(sender.currentTitle!)
    }
    
    @IBAction func frequencyOptionButtonPressed(_ sender: UIButton) {
        print(sender.currentTitle)
    }
    
    
    
    @IBAction func addFrequencyButtonPressed(_ sender: Any) {
        self.addFrequencyButton.isHidden = true
        self.hideAllFrequencyOptionButtons(false)
    }
    
    @IBAction func deleteFrequencyButtonPressed(_ sender: Any) {
        self.addFrequencyButton.isHidden = false
        self.hideAllFrequencyOptionButtons(true)
    }
    
    func updateUI() {
        loadPreViewItemCard()
    }

    @IBAction func optionButtonPressed(_ sender: UIButton) {
        
    }
}

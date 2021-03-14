//
//  SetUpPage.swift
//  Reborn
//
//  Created by Christian Liu on 20/12/20.
//

import Foundation
struct SetUpPage {
    var ID = 0
    var question = ""
    var buttons: Array<CustomData> = []
    
    init(ID: Int, question: String, buttons: Array<CustomData>){
        self.ID = ID
        self.question = question
        self.buttons = buttons
    }

}

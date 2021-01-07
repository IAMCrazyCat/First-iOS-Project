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
    var buttons: Array<DataOption> = []
    
    init(ID: Int, question: String, buttons: Array<DataOption>){
        self.ID = ID
        self.question = question
        self.buttons = buttons
    }

}

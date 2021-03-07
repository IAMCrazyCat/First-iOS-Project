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
    var buttons: Array<DataModel> = []
    
    init(ID: Int, question: String, buttons: Array<DataModel>){
        self.ID = ID
        self.question = question
        self.buttons = buttons
    }

}

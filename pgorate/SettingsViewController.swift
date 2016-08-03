//
//  SettingsViewController.swift
//  pgorate
//
//  Created by Rowell Heria on 03/08/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import Foundation
import Eureka
import SwiftyUserDefaults

class SettingsViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createForm()
    }
    
    func createForm() {
        form +++ Section("Trainer")
            <<< LabelRow() {
                $0.title = "Username"
                $0.value = Defaults[.trainerName]
            }
            <<< LabelRow() {
                $0.title = "Team"
                $0.value = Defaults[.trainerTeam]
            }
            
            +++ Section("Pokémon")
            <<< PushRow<String>() {
                $0.title = "Order by"
                $0.options = ["Name", "Number", "CP"]
                $0.value = Defaults[.filterBy]
            }.onChange({ (row) in
                Defaults[.filterBy] = row.value!
            })
            <<< SwitchRow() {
                $0.title = "Show nickname"
                $0.value = Defaults[.showNick]
        }.onChange({ (row) in
            Defaults[.showNick] = row.value!
        })
        
        +++ Section()
            <<< ButtonRow() {
                $0.title = "Log Out"
        }
        
    }
}
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
import PGoApi

class SettingsViewController: FormViewController {
    
    var playerStats: Pogoprotos.Data.Player.PlayerStats!
    
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
            <<< LabelRow() {
                $0.title = "Level"
                $0.value = "\(playerStats.level)"
            }
            
            +++ Section("Pokémon")
            <<< PushRow<String>() {
                $0.title = "Order by"
                $0.options = ["CP", "IV - Attack", "IV - Defence", "IV - Stamina", "IV Perfection", "Level", "Name", "Number"]
                $0.value = Defaults[.filterBy]
                }.onChange{ row in
                    if let val = row.value {
                        Defaults[.filterBy] = val
                    }
            }
            <<< SwitchRow() {
                $0.title = "Show nickname"
                $0.value = Defaults[.showNick]
                }.onChange{ row in
                    Defaults[.showNick] = row.value!
            }
            
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Log Out"
                }.onCellSelection{ (cell, row) in
                    self.showConfirmation()
        }
        
    }
    
    func showConfirmation() {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you would like to log out?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes, Log out", style: .Destructive){ _ in
            self.navigationController?.dismissViewControllerAnimated(true, completion: {})
            })
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
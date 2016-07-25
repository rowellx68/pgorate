//
//  ViewController.swift
//  pgorate
//
//  Created by Rowell Heria on 24/07/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import UIKit
import Eureka

class ViewController: FormViewController {
    
    var playerData: Pogoprotos.Data.PlayerData!
    var inventoryItems: [Pogoprotos.Inventory.InventoryItem]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createForm()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPokemonListSegue" {
            let view = segue.destinationViewController as! PokemonDataViewController
            view.playerData = playerData
            view.inventoryItems = inventoryItems
        }
    }
    
    func createForm() {
        form +++ Section("Account Type")
            <<< SegmentedRow<String>("acc_type") {
                $0.options = ["Pokémon Trainer Club", "Google"]
                $0.value = "Pokémon Trainer Club"
            }.cellSetup({ (cell, row) in
                //46, 204, 113
                cell.segmentedControl.tintColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
            })
        +++ Section("Credentials")
            <<< TextRow("ptc_username") {
                $0.title = "Username"
        }.cellSetup({ (cell, row) in
            cell.textField.autocapitalizationType = .None
            cell.textField.autocorrectionType = .No
        })
            <<< PasswordRow("password") {
                $0.title = "Password"
        }
        
            +++ Section(header: "", footer: "Use at your own risk. Don't cry if Niantic bans you.")
            <<< ButtonRow("btn_login") {
                $0.title = "Login"
        }.onCellSelection({ (cell, row) in
            self.validateAndGetCredentials()
        })
    }
    
    func validateAndGetCredentials() {
        let username = form.rowByTag("ptc_username") as! TextRow
        let password = form.rowByTag("password") as! PasswordRow
        
        if username.value != nil && password.value != nil {
            Auth.sharedInstance.delegate = self
            Auth.sharedInstance.login(username.value!, password: password.value!)
            addActivityIndicator()
            disableInput(withCondition: true)
        } else {
            showAlert("Fields Required", message: "All fields are required! How do you expect to login?")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func disableInput(withCondition condition: Condition = true) {
        let button = form.rowByTag("btn_login") as! ButtonRow
        let username = form.rowByTag("ptc_username") as! TextRow
        let password = form.rowByTag("password") as! PasswordRow
        let account = form.rowByTag("acc_type") as! SegmentedRow<String>
        
        username.disabled = condition
        password.disabled = condition
        button.disabled = condition
        account.disabled = condition
        
        username.evaluateDisabled()
        password.evaluateDisabled()
        button.evaluateDisabled()
        account.evaluateDisabled()
    }
    
    func addActivityIndicator() {
        let button = UIBarButtonItem()
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.startAnimating()
        button.customView = activityIndicator
        
        navigationItem.setRightBarButtonItem(button, animated: true)
    }
    
    func removeActivityIndicator() {
        navigationItem.setRightBarButtonItem(nil, animated: true)
    }
}


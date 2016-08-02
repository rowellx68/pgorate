//
//  PokemonDataTableViewController.swift
//  pgorate
//
//  Created by Rowell Heria on 24/07/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import UIKit

class PokemonDataTableViewController: UITableViewController {
    
    var playerData: Pogoprotos.Data.PlayerData!
    var inventoryItems: [Pogoprotos.Inventory.InventoryItem]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "PokéRate"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventoryItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pokeCell") as! PokemonTableViewCell!
        let pokeData = inventoryItems[indexPath.row].inventoryItemData!.pokemonData
        
        let overall = Float(pokeData.individualAttack + pokeData.individualStamina + pokeData.individualDefense)/45.0
        
        cell.pokeImage.image = UIImage(named: "\(pokeData.pokemonId.hashValue)")
        cell.name.text = pokeData.pokemonId.toString()
        cell.percent.text = "\(String(format: "%.2f", overall * 100))%"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

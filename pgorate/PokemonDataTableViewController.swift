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
        
        cell.pokeImage.image = UIImage(named: "\(pokeData.pokemonId.hashValue)")
        
        if pokeData.hasNickname {
            cell.name.text = pokeData.nickname
        } else {
            cell.name.text = pokeData.pokemonId.description.stringByReplacingOccurrencesOfString(".", withString: "")
        }
        
        if !pokeData.hasFavorite {
            cell.favourite = nil
        } else {
            cell.favourite?.image = UIImage(named: "fave")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

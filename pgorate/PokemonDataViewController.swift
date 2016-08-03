//
//  PokemonDataViewController.swift
//  pgorate
//
//  Created by Rowell Heria on 24/07/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import UIKit
import PGoApi

class PokemonDataViewController: UINavigationController {

    var playerData: Pogoprotos.Data.PlayerData!
    var inventoryItems: [Pogoprotos.Inventory.InventoryItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rootViewController = self.topViewController as! PokemonDataTableViewController
        
        rootViewController.playerData = playerData
        rootViewController.pokemonList = filterPokemonFromInventory(inventoryItems)
        
        self.viewControllers = [rootViewController]
    }
    
    func filterPokemonFromInventory(inventory: [Pogoprotos.Inventory.InventoryItem]) -> [Pogoprotos.Data.PokemonData] {
        var pokemon:[Pogoprotos.Data.PokemonData] = []
        
        for item in inventory {
            if item.inventoryItemData.hasPokemonData && !item.inventoryItemData.pokemonData.isEgg {
                pokemon.append(item.inventoryItemData.pokemonData)
            }
        }
        
        return pokemon
    }
}

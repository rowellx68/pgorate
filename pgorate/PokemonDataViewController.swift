//
//  PokemonDataViewController.swift
//  pgorate
//
//  Created by Rowell Heria on 24/07/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import UIKit
import PGoApi
import SwiftyUserDefaults

class PokemonDataViewController: UINavigationController {

    var playerData: Pogoprotos.Data.PlayerData!
    var inventoryItems: [Pogoprotos.Inventory.InventoryItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rootViewController = self.topViewController as! PokemonDataTableViewController
        
        rootViewController.playerData = playerData
        rootViewController.pokemonList = filterPokemonFromInventory(inventoryItems)
        
        self.viewControllers = [rootViewController]
        setPlayerDefaults()
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
    
    func setPlayerDefaults() {
        Defaults[.trainerName] = playerData.username
        switch playerData.team {
        case .Blue:
            Defaults[.trainerTeam] = "Mystic"
            navigationBar.barTintColor = UIColor(red:52/255, green:152/255, blue:219/255, alpha: 1)
        case .Red:
            Defaults[.trainerTeam] = "Valor"
            navigationBar.barTintColor = UIColor(red:231/255, green:76/255, blue:60/255, alpha: 1)
        case .Yellow:
            Defaults[.trainerTeam] = "Instinct"
            navigationBar.barTintColor = UIColor(red:241/255, green:196/255, blue:15/255, alpha: 1)
        default:
            Defaults[.trainerTeam] = "N/A"
        }
    }
}

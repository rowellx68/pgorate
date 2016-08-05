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
    var auth: PGoAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rootViewController = self.topViewController as! PokemonDataTableViewController
        
        rootViewController.playerData = playerData
        rootViewController.pokemonList = filterPokemonFromInventory(inventoryItems)
        rootViewController.playerStats = filterPlayerStatsFromInventory(inventoryItems)
        rootViewController.auth = auth
        
        self.viewControllers = [rootViewController]
        setPlayerDefaults()
    }
    
    func filterPokemonFromInventory(inventory: [Pogoprotos.Inventory.InventoryItem]) -> [Pogoprotos.Data.PokemonData] {
        let pokemon = inventory.filter { item in
            item.inventoryItemData.hasPokemonData && !item.inventoryItemData.pokemonData.isEgg
        }
        
        return pokemon.map{ $0.inventoryItemData.pokemonData }
    }
    
    func filterPlayerStatsFromInventory(inventory: [Pogoprotos.Inventory.InventoryItem]) -> Pogoprotos.Data.Player.PlayerStats {
        let stats = inventory.filter { i in
            i.inventoryItemData.hasPlayerStats
        }
        
        return stats.first!.inventoryItemData.playerStats
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

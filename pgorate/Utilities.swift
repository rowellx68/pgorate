//
//  Utilities.swift
//  pgorate
//
//  Created by Rowell Heria on 05/08/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import Foundation
import PGoApi

class InventoryUtilities {
    static func filterPokemonFromInventory(inventory: [Pogoprotos.Inventory.InventoryItem]) -> [Pogoprotos.Data.PokemonData] {
        let pokemon = inventory.filter { item in
            item.inventoryItemData.hasPokemonData && !item.inventoryItemData.pokemonData.isEgg
        }
        
        return pokemon.map{ $0.inventoryItemData.pokemonData }
    }
    
    static func filterPlayerStatsFromInventory(inventory: [Pogoprotos.Inventory.InventoryItem]) -> Pogoprotos.Data.Player.PlayerStats {
        let stats = inventory.filter { item in
            item.inventoryItemData.hasPlayerStats
        }
        
        return stats.first!.inventoryItemData.playerStats
    }
}

class PokemonUtilities {
    static func getName(ofPokemon pokemon: Pogoprotos.Data.PokemonData, showNickname: Bool) -> String {
        if pokemon.hasNickname && showNickname {
            return pokemon.nickname
        } else {
            // ideally we pull from localised strings instead
            return pokemon.pokemonId.description.stringByReplacingOccurrencesOfString(".", withString: "")
        }
    }
}
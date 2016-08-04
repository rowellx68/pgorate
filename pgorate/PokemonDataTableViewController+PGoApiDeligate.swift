//
//  PokemonDataTableViewController+PGoApiDeligate.swift
//  pgorate
//
//  Created by Rowell Heria on 04/08/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import Foundation
import PGoApi

extension PokemonDataTableViewController: PGoApiDelegate {
    
    func didReceiveApiResponse(intent: PGoApiIntent, response: PGoApiResponse) {
        if (intent == .GetInventory) {
            if response.subresponses.count == 1 {
                let inventory = response.subresponses[0] as! Pogoprotos.Networking.Responses.GetInventoryResponse
                
                if inventory.hasInventoryDelta {
                    pokemonList = filterPokemonFromInventory(inventory.inventoryDelta.inventoryItems)
                    sortPokemon()
                    tableView.reloadData()
                }
                
            } else {
                showAlert("Oops", message: "An error occured. We didn't receive enough data from the server. It might be experiencing some issues.")
            }
        }
        
        refreshControl?.endRefreshing()
    }
    
    func didReceiveApiError(intent: PGoApiIntent, statusCode: Int?) {
        showAlert("Oops", message: "An error occured. The game servers might be down. Try again later.")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
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
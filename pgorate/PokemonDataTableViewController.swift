//
//  PokemonDataTableViewController.swift
//  pgorate
//
//  Created by Rowell Heria on 24/07/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import UIKit
import PGoApi
import SwiftyUserDefaults

class PokemonDataTableViewController: UITableViewController {
    
    var playerData: Pogoprotos.Data.PlayerData!
    var pokemonList: [Pogoprotos.Data.PokemonData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "PokéRate"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sortPokemon()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pokeCell") as! PokemonTableViewCell!
        let pokeData = pokemonList[indexPath.row]
        
        cell.pokeImage.image = UIImage(named: "\(pokeData.pokemonId.hashValue)")
        
        cell.cp.text = "CP: \(pokeData.cp)"
        cell.iv.text = "IV: \(pokeData.individualAttack)/\(pokeData.individualDefense)/\(pokeData.individualStamina)"
        
        if pokeData.hasNickname && Defaults[.showNick] {
            cell.name.text = pokeData.nickname
        } else {
            cell.name.text = pokeData.pokemonId.description.stringByReplacingOccurrencesOfString(".", withString: "")
        }
        
        if !pokeData.hasFavorite {
            cell.favourite?.hidden = true
        } else {
            cell.favourite?.hidden = false
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func sortPokemon() {
        switch Defaults[.filterBy] {
        case "Name":
            sortByName()
        case "Number":
            sortById()
        case "CP":
            sortByCP()
        case "IV - Attack":
            sortByIVAttack()
        case "IV - Defence":
            sortByIVDefence()
        case "IV - Stamina":
            sortByIVStamina()
        default:
            return
        }
    }
    
    private func sortByName() {
        pokemonList.sortInPlace{ a, b in
            let aName = a.hasNickname && Defaults[.showNick]
                ? a.nickname
                : a.pokemonId.toString()
            
            let bName = b.hasNickname && Defaults[.showNick]
                ? b.nickname
                : b.pokemonId.toString()
            
            return aName < bName
        }
    }
    
    private func sortById() {
        pokemonList.sortInPlace{ a, b in
            return a.pokemonId.rawValue < b.pokemonId.rawValue
        }
    }
    
    private func sortByCP() {
        pokemonList.sortInPlace{ a, b in
            a.cp > b.cp
        }
    }
    
    private func sortByIVAttack() {
        pokemonList.sortInPlace{ a, b in
            a.individualAttack > b.individualAttack
        }
    }
    
    private func sortByIVDefence() {
        pokemonList.sortInPlace{ a, b in
            a.individualDefense > b.individualDefense
        }
    }
    
    private func sortByIVStamina() {
        pokemonList.sortInPlace{ a, b in
            a.individualStamina > b.individualStamina
        }
    }
}

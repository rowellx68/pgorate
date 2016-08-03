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
        default:
            return
        }
    }
    
    private func sortByName() {
        pokemonList.sortInPlace({ (a, b) -> Bool in
            let aName:String
            let bName:String
            
            if a.hasNickname && Defaults[.showNick] {
                aName = a.nickname
            } else {
                aName = a.pokemonId.toString()
            }
            
            if b.hasNickname && Defaults[.showNick] {
                bName = a.nickname
            } else {
                bName = b.pokemonId.toString()
            }
            
            return aName < bName
        })
    }
    
    private func sortById() {
        pokemonList.sortInPlace({ (a, b) -> Bool in
            return a.pokemonId.rawValue < b.pokemonId.rawValue
        })
    }
    
    private func sortByCP() {
        pokemonList.sortInPlace({ (a, b) -> Bool in
            return a.cp > b.cp
        })
    }
}

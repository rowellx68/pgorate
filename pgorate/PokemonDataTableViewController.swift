//
//  PokemonDataTableViewController.swift
//  pgorate
//
//  Created by Rowell Heria on 24/07/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import UIKit
import PGoApi
import RealmSwift
import SwiftyUserDefaults

class PokemonDataTableViewController: UITableViewController {
    
    var playerData: Pogoprotos.Data.PlayerData!
    var playerStats: Pogoprotos.Data.Player.PlayerStats!
    var auth: PGoAuth!
    var realm: Realm!
    
    private var pokemonDataList: Results<Pokemon>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonDataList = realm.objects(Pokemon.self)
        
        self.navigationItem.title = "PokéRate"
        self.refreshControl?.addTarget(self, action: #selector(PokemonDataTableViewController.fetchPokemon), forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sortPokemon()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonDataList!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pokeCell") as! PokemonTableViewCell!
        let pokeData = pokemonDataList![indexPath.row]
        let hp = Float(pokeData.stamina)/Float(pokeData.staminaMax)
        
        cell.pokeImage.image = UIImage(named: "\(pokeData.pokemonID)")
        
        cell.cp.text = "CP: \(pokeData.cp)"
        cell.iv.text = "Atk/Def/Stm: \(pokeData.individualAttack)/\(pokeData.individualDefense)/\(pokeData.individualStamina)"
        cell.name.text = PokemonUtilities.getName(ofPokemon: pokeData, showNickname: Defaults[.showNick])
        cell.level.text = "Level: \(pokeData.level)"
        cell.hp.setProgress(hp, animated: false)
        
        if hp > 0.60 {
            cell.hp.progressTintColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
        } else if hp > 0.30 {
            cell.hp.progressTintColor = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        } else {
            cell.hp.progressTintColor = UIColor(red: 231/255, green:76/255, blue:60/255, alpha: 1)
        }
        
        if !pokeData.favorite {
            cell.favourite?.hidden = true
        } else {
            cell.favourite?.hidden = false
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showPokemonDetailSegue", sender: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSettingsSegue" {
            let view = segue.destinationViewController as! SettingsViewController
            view.playerStats = playerStats
        } else if segue.identifier == "showPokemonDetailSegue" {
            let view = segue.destinationViewController as! PokemonDetailViewController
            view.pokemon = pokemonDataList![tableView.indexPathForSelectedRow!.row]
        }
    }
    
    func fetchPokemon() {
        let request = PGoApiRequest()
        request.getInventory()
        request.makeRequest(.GetInventory, auth: auth, delegate: self)
    }
    
    func sortPokemon() {
        switch Defaults[.filterBy] {
        case "Name":
            pokemonDataList = Defaults[.showNick]
                ? pokemonDataList?.sorted(["nickname", "pokemonName", "cp"])
                : pokemonDataList?.sorted(["pokemonName", "cp"])
            
        case "Number":
            pokemonDataList = pokemonDataList?.sorted(["pokemonID", "cp"])
        case "CP":
            pokemonDataList = pokemonDataList?.sorted("cp", ascending: false)
        case "IV - Attack":
            pokemonDataList = pokemonDataList?.sorted("individualAttack", ascending: false)
        case "IV - Defence":
            pokemonDataList = pokemonDataList?.sorted("individualDefense", ascending: false)
        case "IV - Stamina":
            pokemonDataList = pokemonDataList?.sorted("indivudualStamina", ascending: false)
        default:
            return
        }
    }
}

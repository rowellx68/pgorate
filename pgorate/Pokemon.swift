//
//  Pokemon.swift
//  pgorate
//
//  Created by Rowell Heria on 05/08/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import Foundation
import RealmSwift

class Pokemon: Object {
    dynamic var recordID = ""
    dynamic var pokemonID = 0
    dynamic var favorite = false
    dynamic var pokemonName = "MISSINGNO"
    dynamic var nickname:String?
    
    dynamic var cp = 0
    dynamic var stamina = 0
    dynamic var staminaMax = 0
    
    dynamic var move1 = "MOVE_UNSET"
    dynamic var move2 = "MOVE_UNSET"
    
    dynamic var deployedToGym = false
    
    dynamic var height: Float = 0.0
    dynamic var weight: Float = 0.0
    
    dynamic var individualAttack = 0
    dynamic var individualDefense = 0
    dynamic var individualStamina = 0
    
    dynamic var cpMultiplier: Float = 0.0
    dynamic var additionalCpMultiplier: Float = 0.0
    
    dynamic var battlesAttacked = 0
    dynamic var battlesDefended = 0
    
    var level: Float {
        return PokemonUtilities.getLevel(ofPokemon: self)
    }
    
    override static func primaryKey() -> String? {
        return "recordID"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["level"]
    }
}

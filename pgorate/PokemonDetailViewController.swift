//
//  PokemonDetailViewController.swift
//  pgorate
//
//  Created by Rowell Heria on 05/08/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import UIKit
import Eureka
import SwiftyUserDefaults

class PokemonDetailViewController: FormViewController {

    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Defaults[.showNick]
            ? pokemon.nickname ?? pokemon.pokemonName
            : pokemon.pokemonName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

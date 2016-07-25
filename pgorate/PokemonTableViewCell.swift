//
//  PokemonTableViewCell.swift
//  pgorate
//
//  Created by Rowell Heria on 24/07/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var percent: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setSelected(false, animated: true)
    }

}

//
//  PokeCell.swift
//  pokedex3
//
//  Created by Yaniv Hasbani on 6/11/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
  @IBOutlet var thumbImg: UIImageView!
  @IBOutlet var nameLbl: UILabel!
  
  var pokemon: Pokemon!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    layer.cornerRadius = 10.0
  }
  
  func configureCell(_ pokemon:Pokemon) {
    self.pokemon = pokemon
    
    nameLbl.text = self.pokemon.name.capitalized
    thumbImg.image = UIImage(named: "\(pokemon.pokedexId)")
  }
}

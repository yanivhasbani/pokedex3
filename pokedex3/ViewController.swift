//
//  ViewController.swift
//  pokedex3
//
//  Created by Yaniv Hasbani on 6/11/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate  {
  
  @IBOutlet var collection: UICollectionView!
  @IBOutlet var searchBar: UISearchBar!
  
  private var pokemons = [Pokemon]()
  private var filteredPokemons = [Pokemon]()
  private var musicPlayer: AVAudioPlayer!
  var inSearchMode = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    parsePokemonCSV()
    
    collection.dataSource = self
    collection.delegate = self
    searchBar.delegate = self
    
    searchBar.returnKeyType = UIReturnKeyType.done
    searchBar.barStyle = UIBarStyle.black
    
    initAudio()
  }
  
  func initAudio() {
    let path = Bundle.main.path(forResource: "music", ofType: "mp3")
    do {
      musicPlayer = try AVAudioPlayer(contentsOf: URL(string:path!)!)
      musicPlayer.prepareToPlay()
      musicPlayer.numberOfLoops = -1
      musicPlayer.play()
    } catch let err as NSError {
      print(err.debugDescription)
    }
  }
  
  func parsePokemonCSV() {
    let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
    
    do {
      let csv = try CSV(contentsOfURL: path!)
      let rows = csv.rows
      
      for row in rows {
        let pokeId = Int(row["id"]!)!
        let name = row["identifier"]!
        let pokemon : Pokemon = Pokemon(name: name, pokedexId: pokeId)
        
        pokemons.append(pokemon)
      }
      
      collection.reloadData()
    } catch let err as NSError {
      print("Error has occured while trying to fetch data from CSV. Err = \(err.debugDescription)")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
      var pokemonArray: Array<Pokemon>
      if (inSearchMode) {
        pokemonArray = filteredPokemons
      } else {
        pokemonArray = pokemons
      }
      
      if (indexPath.row < pokemonArray.count) {
        cell.configureCell(pokemonArray[indexPath.row])
        return cell
      }
      
    }
    
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var poke:Pokemon!
    
    if inSearchMode {
      poke = filteredPokemons[indexPath.row]
    } else {
      poke = pokemons[indexPath.row]
    }
    
    performSegue(withIdentifier: "DetailsVC", sender: poke)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return inSearchMode ? filteredPokemons.count: pokemons.count
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width:105, height:105)
  }
  
  @IBAction func musicBtnPressed(_ sender: UIButton) {
    if musicPlayer.isPlaying {
      musicPlayer.pause()
      sender.alpha = 0.2
    } else {
      musicPlayer.play()
      sender.alpha = 1
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //Once the return button is clicked
    view.endEditing(true)
  }
  
  //MARK:SearchDelegate
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text == nil || searchBar.text == "" {
      inSearchMode = false
      collection.reloadData()
      view.endEditing(true)
    } else {
      inSearchMode = true
      
      if let lower = searchBar.text?.lowercased() {
        filteredPokemons = pokemons.filter({$0.name.range(of: lower) != nil})
        collection.reloadData()
      }
      
      
    }
  }
  
  //MARK Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "DetailsVC",
      let vc = segue.destination as? DetailsVC,
      let pokemon = sender  {
      vc.pokemon = pokemon as? Pokemon
    }
  }
}

//  func collectionViewindexPath
//
//  itemAtindex}


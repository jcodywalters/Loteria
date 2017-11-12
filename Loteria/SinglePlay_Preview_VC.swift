//
//  SinglePlay_Preview_VC.swift
//  Loteria
//
//  Created by Cody Walters on 2/20/17.
//  Copyright © 2017 Cody. All rights reserved.
//

import UIKit
import Foundation

class SinglePlay_Preview_VC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    /* Outlets */
    
    @IBOutlet weak var MyCollectionView: UICollectionView!
    
  
    /* Actions */
    
    @IBAction func refreshCard(_ sender: UIButton) {
        print("Creating new board...")
        boardPlayer1 = createBoard(board: boardPlayer1)
        print(boardPlayer1)
        self.MyCollectionView.reloadData()
        
        selectedPlayerBoard = [SinglePlayerBoard(playerBoard: boardPlayer1)]
    }
    
    @IBAction func backPage(_ sender: Any) {
        backSelected = true
    }
    
    
    /* Variables */
    
    var images = ["img01", "img02", "img03", "img04", "img05", "img06", "img07", "img08", "img09", "img10", "img11", "img12", "img13", "img14", "img15", "img16", "img17", "img18", "img19", "img20", "img21", "img22", "img23", "img24", "img25", "img26", "img27", "img28", "img29", "img30", "img31", "img32", "img33", "img34", "img35", "img36", "img37", "img38", "img39", "img40", "img41", "img42", "img43", "img44", "img45", "img46", "img47", "img48", "img49", "img50", "img51", "img52", "img53", "img54"]
    
    // Transfer this array to the game
    var boardPlayer1 = [Int]()
    var selectedPlayerBoard = [SinglePlayerBoard]()
    var backSelected = false
    
    /* MAIN Functions */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.MyCollectionView.delegate = self
        self.MyCollectionView.dataSource = self
    
        boardPlayer1 = createBoard(board: boardPlayer1)

        print("player: \(boardPlayer1)")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* Custom Functions */

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardPlayer1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! CollectionViewCell
        // set images
        cell.myImageView.image = UIImage(named: images[boardPlayer1[indexPath.row]])
        return cell
    }
    
    func createBoard(board: [Int]) -> [Int] {
        var newBoard = [Int]()
        for _ in 0..<16 {
            var random = Int(arc4random_uniform(UInt32(images.count)))
            while newBoard.contains(random) {
                random = Int(arc4random_uniform(UInt32(images.count)))
            }
            newBoard.append(random)
        }
        return newBoard
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if backSelected == false {
            var DestViewController = segue.destination as! Game_SinglePlay_VCViewController
            
            DestViewController.playerBoard = boardPlayer1
        }
        
        
    }

}

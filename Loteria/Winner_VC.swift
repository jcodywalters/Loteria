//
//  Winner_VC.swift
//  Loteria
//
//  Created by Cody Walters on 2/22/17.
//  Copyright © 2017 Cody. All rights reserved.
//

import UIKit

class Winner_VC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    /* Outlets */
    
    @IBOutlet weak var MyImageView: UICollectionView!
    
    @IBOutlet weak var lblWinnerName: UILabel!
    
    
    
    /* Variables */

    
    var winningBoard = [Int]()
    var winnerName = ""
    
    // Regular images are not being used currently
    var images = ["img01", "img02", "img03", "img04", "img05", "img06", "img07", "img08", "img09", "img10", "img11", "img12", "img13", "img14", "img15", "img16", "img17", "img18", "img19", "img20", "img21", "img22", "img23", "img24", "img25", "img26", "img27", "img28", "img29", "img30", "img31", "img32", "img33", "img34", "img35", "img36", "img37", "img38", "img39", "img40", "img41", "img42", "img43", "img44", "img45", "img46", "img47", "img48", "img49", "img50", "img51", "img52", "img53", "img54"]
    
    var bean_images = ["img01bean", "img02bean", "img03bean", "img04bean", "img05bean", "img06bean", "img07bean", "img08bean", "img09bean", "img10bean", "img11bean", "img12bean", "img13bean", "img14bean", "img15bean", "img16bean", "img17bean", "img18bean", "img19bean", "img20bean", "img21bean", "img22bean", "img23bean", "img24bean", "img25bean", "img26bean", "img27bean", "img28bean", "img29bean", "img30bean", "img31bean", "img32bean", "img33bean", "img34bean", "img35bean", "img36bean", "img37bean", "img38bean", "img39bean", "img40bean", "img41bean", "img42bean", "img43bean", "img44bean", "img45bean", "img46bean", "img47bean", "img48bean", "img49bean", "img50bean", "img51bean", "img52bean", "img53bean", "img54bean"]

    /* MAIN Methods */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblWinnerName.text = "\(winnerName) WINS!"
        print(winningBoard)
        print(winnerName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    /* Custom Functions */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return winningBoard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! CollectionViewCell
        // set images
        cell.myImageView.image = UIImage(named: bean_images[winningBoard[indexPath.row]])
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


}

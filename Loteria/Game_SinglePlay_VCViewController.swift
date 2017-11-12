//
//  Game_SinglePlay_VCViewController.swift
//  Loteria
//
//  Created by Cody Walters on 2/15/17.
//  Copyright © 2017 Cody. All rights reserved.
//
import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class Game_SinglePlay_VCViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

   /* Outlets */
    
    @IBOutlet weak var MyCollectionView: UICollectionView!
    
    @IBOutlet weak var MyCollectionViewCPU: UICollectionView!
    
    @IBOutlet weak var lblCountDown: UILabel!
    
    @IBOutlet weak var cardDrawn: UIImageView!
        
    @IBOutlet weak var btnPlayerSubmitsCard: UIButton!
    
    @IBOutlet weak var lblPlayerName: UILabel!
    
    @IBOutlet weak var lblNotBlackOut: UILabel!
    
    
    /* Actions */
    
    @IBAction func btnPlayerSubmitsCard(_ sender: UIButton) {
        // Check if player 1 wins
        print(checkPlayerBoard(board: boardPlayer1Checker, beanBord: boardPlayer1BeanPlaced))
        if(checkPlayerBoard(board: boardPlayer1Checker, beanBord: boardPlayer1BeanPlaced)) {
            playerWins = true
            checkForWinners()
        } else {
            lblNotBlackOut.isHidden = false
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        timer2?.invalidate()
        exitGame = true
    }

    
    /* Variables */
    
    var images = ["img01", "img02", "img03", "img04", "img05", "img06", "img07", "img08", "img09", "img10", "img11", "img12", "img13", "img14", "img15", "img16", "img17", "img18", "img19", "img20", "img21", "img22", "img23", "img24", "img25", "img26", "img27", "img28", "img29", "img30", "img31", "img32", "img33", "img34", "img35", "img36", "img37", "img38", "img39", "img40", "img41", "img42", "img43", "img44", "img45", "img46", "img47", "img48", "img49", "img50", "img51", "img52", "img53", "img54"]
    
    var bean_images = ["img01bean", "img02bean", "img03bean", "img04bean", "img05bean", "img06bean", "img07bean", "img08bean", "img09bean", "img10bean", "img11bean", "img12bean", "img13bean", "img14bean", "img15bean", "img16bean", "img17bean", "img18bean", "img19bean", "img20bean", "img21bean", "img22bean", "img23bean", "img24bean", "img25bean", "img26bean", "img27bean", "img28bean", "img29bean", "img30bean", "img31bean", "img32bean", "img33bean", "img34bean", "img35bean", "img36bean", "img37bean", "img38bean", "img39bean", "img40bean", "img41bean", "img42bean", "img43bean", "img44bean", "img45bean", "img46bean", "img47bean", "img48bean", "img49bean", "img50bean", "img51bean", "img52bean", "img53bean", "img54bean"]
    
    var boardPlayer1Checker = [false, false, false, false, false, false,false, false, false, false, false, false, false, false, false, false]
    var boardCPUChecker = [false, false, false, false, false, false,false, false, false, false, false, false, false, false, false, false]

    var boardPlayer1BeanPlaced = [false, false, false, false, false, false,false, false, false, false, false, false, false, false, false, false]
    
    var timer1 : Timer?
    var timer2 : Timer?

    var playerBoard = [Int]()
    var boardPlayer1_beans = [String]()
    var boardPlayer1Selected = [Bool]()
    // Transfer this array to the game
    var winnerBoard = [Int]()
    var winnerName = ""

    var boardCPU = [Int]()
    var cardDeck = [Int]()
    var calledCards = [Int]()
    var playerWins = false
    var cpuWins = false
    
    var counter = 5
    var timerRunning = false
    var cardDeckIndex = 0
    
    var isWinner = false
    var isWinner_player1 = false
    
    var exitGame = false

    
    
    /* MAIN Functions */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.MyCollectionView.delegate = self
        self.MyCollectionView.dataSource = self
        self.MyCollectionViewCPU.delegate = self
        self.MyCollectionViewCPU.dataSource = self
        
        timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDownTimer), userInfo: nil, repeats: true)
        
        boardCPU = createBoard(board: boardCPU)
        shuffleDeck()
        
        print("player: \(playerBoard)")
        print("cpu: \(boardCPU)")
        
        btnPlayerSubmitsCard.isHidden = true
        lblNotBlackOut.isHidden = true
        lblPlayerName.text = firstName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.timer2 =  Timer.scheduledTimer(timeInterval: 5.0, target: self, selector:#selector(self.flipCard), userInfo: nil, repeats: true)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* Custom Functions */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerBoard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // set images
        if collectionView == self.MyCollectionView {
            let cellPlayer = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! CollectionViewCell
            cellPlayer.myImageView.image = UIImage(named: images[playerBoard[indexPath.row]])
            return cellPlayer
        }
        
        else {
            let cellCPU = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! CollectionViewCell
            cellCPU.myImageView.image = UIImage(named: images[boardCPU[indexPath.row]])
            return cellCPU
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.MyCollectionView {
            let cellPlayer = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            boardPlayer1BeanPlaced[indexPath.row] = true
            
            if cellPlayer.layer.borderColor == UIColor.yellow.cgColor {
                cellPlayer.layer.borderWidth = 0.0
                cellPlayer.layer.borderColor = UIColor.white.cgColor
                cellPlayer.myImageView.image = UIImage(named: images[playerBoard[indexPath.row]])
            }else {
                cellPlayer.layer.borderWidth = 0.0
                cellPlayer.layer.borderColor = UIColor.yellow.cgColor
                cellPlayer.myImageView.image = UIImage(named: bean_images[playerBoard[indexPath.row]])
            }
        }
        
    }
    
    func countDownTimer() {
        if counter > 0 {
            timerRunning = true
            print("Counter: \(counter)")
            lblCountDown.text = String(counter)
            counter -= 1
        } else {
            timerRunning = false
            lblCountDown.text = "Go!"
        }
    }
        
    func createBoard(board: [Int]) -> [Int] {
        var newBoard = [Int]()
        for _ in 0..<16 {
            var random = Int(arc4random_uniform(UInt32(images.count)))
            while newBoard.contains(random) {
                random = Int(arc4random_uniform(UInt32(images.count)))
            }
            //newBoard.append(images[random])
            newBoard.append(random)
        }
        return newBoard
    }
    
    func shuffleDeck() -> Void {
        for _ in 0..<images.count {
            var random = Int(arc4random_uniform(UInt32(images.count)))
            while cardDeck.contains(random) {
                random = Int(arc4random_uniform(UInt32(images.count)))
            }
            cardDeck.append(random)
        }
    }
    
    
    func printBoardToConsole(board: [Bool]) -> Void {
        print(board[0], board[1], board[2], board[3])
        print(board[4], board[5], board[6], board[7])
        print(board[8], board[9], board[10], board[11])
        print(board[12], board[13], board[14], board[15])
    }

    func flipCard(){
        
        lblCountDown.isHidden = true
        lblNotBlackOut.isHidden = true
        btnPlayerSubmitsCard.isHidden = false
        
        // Take a turn
        let card = self.cardDeck.removeFirst()
        calledCards.append(card)
        print("card: \(card)")
        cardDrawn.image = UIImage(named: images[card])

        UIImageView.beginAnimations(nil, context: nil)
        UIImageView.setAnimationDelegate(self)
        UIImageView.setAnimationDuration(1.50)
        UIImageView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: cardDrawn as UIView, cache: true)
        UIImageView.commitAnimations()
        
        // Creates the keys for each player
        if self.playerBoard.contains(card) {
            self.boardPlayer1Checker[self.playerBoard.index(of: card)!] = true
            print("player has the card")
        }
        if self.boardCPU.contains(card) {
            self.boardCPUChecker[self.boardCPU.index(of: card)!] = true
            print("cpu has the card")
            
            let cardIndex = Int(boardCPU.index(of: card)!)
            let indexPath = IndexPath(row: cardIndex, section: 0)
            let cpuCell = self.MyCollectionViewCPU.cellForItem(at: indexPath) as! CollectionViewCell
            boardPlayer1BeanPlaced[indexPath.row] = true
            
            if cpuCell.layer.borderColor == UIColor.yellow.cgColor {
                cpuCell.layer.borderWidth = 0.0
                cpuCell.layer.borderColor = UIColor.white.cgColor
                cpuCell.myImageView.image = UIImage(named: images[boardCPU[indexPath.row]])
            }else {
                cpuCell.layer.borderWidth = 0.0
                cpuCell.layer.borderColor = UIColor.yellow.cgColor
                cpuCell.myImageView.image = UIImage(named: bean_images[boardCPU[indexPath.row]])
            }
        }
        
        // This checks if the cpu wins every turn. Player must manualy check with gui btn
        checkForWinners()
        
        
    }
    
    func checkForWinners() {
        
        if cpuCheckBoard(board: boardCPUChecker) {
            cpuWins = true
            printBoardToConsole(board: boardCPUChecker)
        }
        
        if cpuWins || playerWins {
            
            if cpuWins && playerWins {
                print("Tie")
            }
            else if cpuWins {
                print("CPU Winner")
                winnerBoard = boardCPU
                winnerName = "CPU"

            }
            else {
                print("Player Winner")
                winnerBoard = playerBoard
                winnerName = "Player"

            }
            
            timer2?.invalidate()
            // Segue to next view

            

            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.performSegue(withIdentifier: "winnerVC", sender: self)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(exitGame != true) {
            var DestViewController = segue.destination as! Winner_VC
            
            DestViewController.winningBoard = winnerBoard
            DestViewController.winnerName = winnerName
        }
        timer2?.invalidate()


    }
//    
//    func playerCheckBoard(board: [Bool]) -> Bool {
//        isWinner_player1 = false
//        
//        // Check for Black-out
//        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 0, bean2: 1, bean3: 2, bean4: 3)) {
//            if board[0] == true && board[1] == true && board[2] == true && board[3] == true {
//                isWinner = true
//                return isWinner
//            }
//        }
//
//        
//        board[0] == true && board[1] == true && board[2] == true && board[3] == true && board[4] == true && board[5] == true && board[6] == true && board[7] == true && board[8] == true && board[9] == true && board[10] == true && board[11] == true && board[12] == true && board[13] == true && board[14] == true && board[15] == true
//
//        return isWinner_player1
//    }
    
    // Use this fuction for Black-out wins
    func checkPlayerBoard(board: [Bool], beanBord: [Bool]) -> Bool {
        if(beanBord[1] && beanBord[2] && beanBord[3] && beanBord[4] && beanBord[5] && beanBord[6] && beanBord[7] && beanBord[8] && beanBord[9] && beanBord[10] && beanBord[11] && beanBord[12] && beanBord[13] && beanBord[14] && beanBord[15] && beanBord[0]) {
            if(board[1] && board[2] && board[3] && board[4] && board[5] && board[6] && board[7] && board[8] && board[9] && board[10] && board[1] && board[12] && board[13] && board[14] && board[15] && board[0]) {
                return true
            }
        }
        return false
    }
    
    // Use this function for traditional wins
//    func checkPlayerBoard(board: [Bool], bean1: Int, bean2: Int, bean3: Int, bean4: Int) -> Bool {
//        if(board[bean1] && board[bean2] && board[bean3] && board[bean4]) {
//            return true
//        }
//        return false
//    }
    
    
    func cpuCheckBoard(board: [Bool]) -> Bool {
        isWinner = false

        // Check for Black-out
        if board[0] == true && board[1] == true && board[2] == true && board[3] == true && board[4] == true && board[5] == true && board[6] == true && board[7] == true && board[8] == true && board[9] == true && board[10] == true && board[11] == true && board[12] == true && board[13] == true && board[14] == true && board[15] == true {
            isWinner = true
            return isWinner
            
        }
        
//        // Check horizontals
//        if board[0] == true && board[1] == true && board[2] == true && board[3] == true {
//            isWinner = true
//            return isWinner
//
//        }
//        if board[4] == true && board[5] == true && board[6] == true && board[7] == true {
//            isWinner = true
//            return isWinner
//        }
//        if board[8] == true && board[9] == true && board[10] == true && board[11] == true {
//            isWinner = true
//            return isWinner
//        }
//        if board[12] == true && board[13] == true && board[14] == true && board[15] == true {
//            isWinner = true
//            return isWinner
//        }
//        
//        // Check verticals
//        if board[0] == true && board[4] == true && board[8] == true && board[12] == true {
//            isWinner = true
//            return isWinner
//        }
//        if board[1] == true && board[5] == true && board[9] == true && board[13] == true {
//            isWinner = true
//            return isWinner
//        }
//        if board[2] == true && board[6] == true && board[10] == true && board[14] == true {
//            isWinner = true
//            return isWinner
//        }
//        if board[12] == true && board[13] == true && board[14] == true && board[15] == true {
//            isWinner = true
//            return isWinner
//        }
//        
//        // Check blocks
//        if board[0] == true && board[1] == true && board[4] == true && board[5] == true {
//            isWinner = true
//            return isWinner
//        }
//        if board[1] == true && board[2] == true && board[5] == true && board[6] == true {
//            isWinner = true
//            return isWinner
//        }
//        if board[2] == true && board[3] == true && board[6] == true && board[7] == true {
//            isWinner = true
//            return isWinner
//        }
//        
//        if board[4] == true && board[5] == true && board[8] == true && board[9] == true {
//            isWinner = true
//            return isWinner
//        }
//        if board[5] == true && board[6] == true && board[9] == true && board[10] == true {
//            isWinner = true
//            return isWinner
//        }
//        if board[6] == true && board[7] == true && board[10] == true && board[11] == true {
//            isWinner = true
//            return isWinner
//        }
//        if board[8] == true && board[9] == true && board[12] == true && board[13] == true {
//            isWinner = true
//            return isWinner
//        }
//        if board[9] == true && board[10] == true && board[13] == true && board[14] == true {
//            isWinner = true
//            return isWinner
//        }
//        if board[10] == true && board[11] == true && board[14] == true && board[15] == true {
//            isWinner = true
//            return isWinner
//        }
//        
//        // Check corners
//        if board[0] == true && board[3] == true && board[12] == true && board[15] == true {
//            isWinner = true
//            return isWinner
//        }
        
        //        // Check horizontals
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 0, bean2: 1, bean3: 2, bean4: 3)) {
        //            if board[0] == true && board[1] == true && board[2] == true && board[3] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 4, bean2: 5, bean3: 6, bean4: 7)) {
        //            if board[4] == true && board[5] == true && board[6] == true && board[7] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 8, bean2: 9, bean3: 10, bean4: 11)) {
        //            if board[8] == true && board[9] == true && board[10] == true && board[11] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 12, bean2: 13, bean3: 14, bean4: 15)) {
        //            if board[12] == true && board[13] == true && board[14] == true && board[15] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //
        //        // Check verticals
        //         if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 0, bean2: 4, bean3: 8, bean4: 12)) {
        //            if board[0] == true && board[4] == true && board[8] == true && board[12] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 1, bean2: 5, bean3: 9, bean4: 13)) {
        //            if board[1] == true && board[5] == true && board[9] == true && board[13] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 2, bean2: 6, bean3: 10, bean4: 14)) {
        //            if board[2] == true && board[6] == true && board[10] == true && board[14] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 12, bean2: 13, bean3: 14, bean4: 15)) {
        //            if board[12] == true && board[13] == true && board[14] == true && board[15] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //
        //        // Check blocks
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 0, bean2: 1, bean3: 4, bean4: 5)) {
        //            if board[0] == true && board[1] == true && board[4] == true && board[5] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 1, bean2: 2, bean3: 5, bean4: 6)) {
        //            if board[1] == true && board[2] == true && board[5] == true && board[6] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 2, bean2: 3, bean3: 6, bean4: 7)) {
        //            if board[2] == true && board[3] == true && board[6] == true && board[7] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 4, bean2: 5, bean3: 8, bean4: 9)) {
        //            if board[4] == true && board[5] == true && board[8] == true && board[9] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 5, bean2: 6, bean3: 9, bean4: 10)) {
        //            if board[5] == true && board[6] == true && board[9] == true && board[10] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //       if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 6, bean2: 7, bean3: 10, bean4: 11)) {
        //            if board[6] == true && board[7] == true && board[10] == true && board[11] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 8, bean2: 9, bean3: 12, bean4: 13)) {
        //            if board[8] == true && board[9] == true && board[12] == true && board[13] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 9, bean2: 10, bean3: 13, bean4: 14)) {
        //            if board[9] == true && board[10] == true && board[13] == true && board[14] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 10, bean2: 11, bean3: 14, bean4: 15)) {
        //            if board[10] == true && board[11] == true && board[14] == true && board[15] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        //
        //        // Check corners
        //        if (checkPlayerBoard(board: boardPlayer1BeanPlaced, bean1: 0, bean2: 3, bean3: 12, bean4: 15)) {
        //            if board[0] == true && board[3] == true && board[12] == true && board[15] == true {
        //                isWinner = true
        //                return isWinner
        //            }
        //        }
        return isWinner
    }

}

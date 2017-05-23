//
//  ViewController.swift
//  GoFish
//
//  Created by Brent Behling on 5/22/17.
//  Copyright © 2017 Brent Behling. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource    {

    ///Main Section///
    
    //Game
    @IBOutlet weak var GameCardsLeft: UILabel!
    
    //CPU
    @IBOutlet weak var CPUCardsLeft: UILabel!
    @IBOutlet weak var CPUPairs: UILabel!
    
    //Player
    @IBOutlet weak var UserPairs: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //Variables
    var deck = [Card]()
    
    //Creates a deck of cards
    func createDeck()   {
        var i = 0 //Suite
        while(i < 2)    {
            var s = "" //suite
            var x = 1 //Value
            if(i == 0)  {
                s = "Clubs"
            }/*   else if(i == 1) {
                s = "Spades"
            }   else if(i == 2) {
                s = "Diamonds"
            }*/   else    {
                s = "Hearts"
            }
            while(x < 14)   {
                let tempCard = Card()
                tempCard.value = x
                tempCard.suite = s
                tempCard.assignRank(value: tempCard.value)
                tempCard.setDescription(rank: tempCard.rank, suite: tempCard.suite)
                x += 1
                deck.append(tempCard)
            }
            i += 1
        }
    }
    
    //Shuffles the deck
    func shuffle()  {
        var tempDeck = [Card]()
        while deck.count > 0    {
            let random = Int(arc4random_uniform(UInt32(deck.count)))
            let card = deck.remove(at: random)
            tempDeck.append(card)
        }
        deck = tempDeck
    }
    
    
    ///Go Fish Section///
    var drawDeck = [Card]()
    var playerDeck = [Card]()
    var playerPairsArray = [Card]()
    var cpuDeck = [Card]()
    var cpuPairsArray = [Card]()
    var selectedCard = Card()
    var gameOver = false
    var randomIndex = 0
    
    func deal() {
        for card in deck    {
            if(playerDeck.count < 5)    {
                playerDeck.append(card)
            }   else if(cpuDeck.count < 5)  {
                cpuDeck.append(card)
            }   else    {
                drawDeck.append(card)
            }
        }
    }
    
    //Player draw card
    func playerDraw()   {
        if(playerDeck.count == 0)  {
            while(playerDeck.count != 7)   {
                if(drawDeck.count > 0)  {
                    playerDeck.append(drawDeck[0])
                    drawDeck.remove(at: 0)
                }   else    {
                    break
                }
            }
        }   else    {
            if(drawDeck.count > 0)  {
                playerDeck.append(drawDeck[0])
                drawDeck.remove(at: 0)
            }
        }
    }
    
    //CPU draw card
    func cpuDraw()   {
        if(cpuDeck.count == 0)  {
            while(cpuDeck.count != 7)   {
                if(drawDeck.count > 0)  {
                    cpuDeck.append(drawDeck[0])
                    drawDeck.remove(at: 0)
                }   else    {
                    break
                }
            }
        }   else    {
            if(drawDeck.count > 0)  {
                cpuDeck.append(drawDeck[0])
                drawDeck.remove(at: 0)
            }
        }
    }
    
    //Player's turn check cpu hand
    func checkCPUHand(selectedCard: Card)   {
        var x = 0
        while(x < cpuDeck.count)    {
            if(selectedCard.value == cpuDeck[x].value)  {
                playerDeck.append(cpuDeck[x])
                cpuDeck.remove(at: x)
                checkForPlayerPairs()
                return
            }   else    {
                x += 1
            }
        }
        playerDraw()
    }
    
    //CPU's turn check player hand
    func checkPlayerHand(selectedCard: Card)   {
        var x = 0
        while(x < playerDeck.count)    {
            if(selectedCard.value == playerDeck[x].value)  {
                cpuDeck.append(playerDeck[x])
                playerDeck.remove(at: x)
                checkForCPUPairs()
                return
            }   else    {
                x += 1
            }
        }
        cpuDraw()
    }
    
    //Check for player Pairs
    func checkForPlayerPairs()  {
        var i = 0
        var k = 0
        var pairFound = false
        while(i < playerDeck.count) {
            pairFound = false
            k = i + 1
            while(k < playerDeck.count) {
                if(playerDeck[i].value == playerDeck[k].value) {
                    pairFound = true
                    break
                }   else    {
                    k += 1
                }
            }
            if(pairFound)   {
                playerPairsArray.append(playerDeck[i])
                playerDeck.remove(at: k)
                playerDeck.remove(at: i)
            }   else    {
                i += 1
            }
        }
    }
    
    //Check for cpu pairs
    func checkForCPUPairs()  {
        var i = 0
        var k = 0
        var pairFound = false
        while(i < cpuDeck.count) {
            pairFound = false
            k = i + 1
            while(k < cpuDeck.count) {
                if(cpuDeck[i].value == cpuDeck[k].value) {
                    pairFound = true
                    break
                }   else    {
                    k += 1
                }
            }
            if(pairFound)   {
                cpuPairsArray.append(cpuDeck[i])
                cpuDeck.remove(at: k)
                cpuDeck.remove(at: i)
            }   else    {
                i += 1
            }
        }
    }
    
    /*  Start of PickerView Stuff   */
    
    //Returns the number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Returns the number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return playerDeck.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (row < playerDeck.count ? playerDeck[row].description : nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        if row < playerDeck.count {
            self.selectedCard = playerDeck[row]
        }
    }
    
    
    /*  End of PickerView Stuff */

    
    func organizeCardDeck() {
        playerDeck = playerDeck.sorted { $0.value < $1.value }
        cpuDeck = cpuDeck.sorted { $0.value < $1.value }
    }
    
    func start()    {
        playerDeck.removeAll()
        cpuDeck.removeAll()
        deck.removeAll()
        cpuPairsArray.removeAll()
        playerPairsArray.removeAll()
        createDeck()
        shuffle()
        shuffle()
        deal()
        organizeCardDeck()
        checkForPlayerPairs()
        checkForCPUPairs()
        pickerView.reloadAllComponents()
        GameCardsLeft.text = "\(drawDeck.count)"
        CPUCardsLeft.text = "\(cpuDeck.count)"
        CPUPairs.text = "\(cpuPairsArray.count)"
        UserPairs.text = "\(playerPairsArray.count)"
    }
    
    func checkGameOver()    {
        if(cpuDeck.count == 0 && playerDeck.count == 0 && drawDeck.count == 0)  {
            let cpuPairCount = cpuPairsArray.count
            let playerPairCount = playerPairsArray.count
            if(playerPairCount > cpuPairCount)  {
                let alertController = UIAlertController(title: "Game Over", message: "You Win!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Restart", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: start)
            }   else if(playerPairCount < cpuPairCount) {
                let alertController = UIAlertController(title: "Game Over", message: "You Lose!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Restart", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: start)
            }   else if(playerPairCount == cpuPairCount)    {
                let alertController = UIAlertController(title: "Game Over", message: "Tie Game!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Restart", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: start)
            }
        }
    }
    
    func startAlert()   {
        let startAlert = UIAlertController(title: "Go Fish Go", message: "Match pairs of two, match the most to win", preferredStyle: UIAlertControllerStyle.alert)
        startAlert.addAction(UIAlertAction(title: "Start", style: UIAlertActionStyle.default,handler: nil))
        self.present(startAlert, animated: true, completion: start)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAlert()
    }
    
    @IBAction func SelectCard(_ sender: UIButton) {
        checkCPUHand(selectedCard: selectedCard)
        pickerView.reloadAllComponents()
        checkForPlayerPairs()
        pickerView.reloadAllComponents()
        if(playerDeck.count == 0)   {
            playerDraw()
        }
        pickerView.reloadAllComponents()
        
        GameCardsLeft.text = "\(drawDeck.count)"
        CPUCardsLeft.text = "\(cpuDeck.count)"
        CPUPairs.text = "\(cpuPairsArray.count)"
        UserPairs.text = "\(playerPairsArray.count)"
        
        randomIndex = Int(arc4random_uniform(UInt32(cpuDeck.count)))
        pickerView.reloadAllComponents()
        if(cpuDeck.count == 1)  {
            checkPlayerHand(selectedCard: cpuDeck[0])
        }   else    {
            checkPlayerHand(selectedCard: cpuDeck[randomIndex])
        }
        pickerView.reloadAllComponents()
        checkForCPUPairs()
        pickerView.reloadAllComponents()
        if(cpuDeck.count == 0)   {
            cpuDraw()
        }
        pickerView.reloadAllComponents()
        
        GameCardsLeft.text = "\(drawDeck.count)"
        CPUCardsLeft.text = "\(cpuDeck.count)"
        CPUPairs.text = "\(cpuPairsArray.count)"
        UserPairs.text = "\(playerPairsArray.count)"
        checkGameOver()
    }
}


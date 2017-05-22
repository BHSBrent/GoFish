//
//  Card.swift
//  GoFish
//
//  Created by Brent Behling on 5/22/17.
//  Copyright © 2017 Brent Behling. All rights reserved.
//

import UIKit

class Card
{
    var value = 0
    var suite = ""
    var rank = ""
    var description = ""
    
    func assignRank(value: Int) {
        if (value == 1)   {
            rank = "Ace"
        }   else if (value < 11 && value > 1) {
            rank = String(value)
        }   else if (value == 11) {
            rank = "Jack"
        }   else if (value == 12) {
            rank = "Queen"
        }   else    {
            rank = "King"
        }
    }
    
    func setDescription(rank: String, suite: String)   {
        description = "\(rank) of \(suite)"
    }
}

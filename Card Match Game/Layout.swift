//
//  layout.swift
//  CardMatchGame-Kids
//
//  Created by Budding Minds Admin on 2020-01-03.
//  Copyright © 2020 Budding Minds Admin. All rights reserved.
//

import Foundation
import UIKit

class Layout {
    // array of cards
    let cards : [Card]
    let cardPositions : [CGPoint]
    
    init (cards : [Card]) {
        self.cards = cards
        var cardPositions = [CGPoint]()
        
        for c in self.cards {
            cardPositions.append(c.getLoc())
        }
        
        self.cardPositions = cardPositions
    }
    
    func getAllCards() -> [Card] {
        return self.cards
    }
    
    func getTargetCards() -> [Card] {
        var ret = [Card]()
        
        for c in self.cards {
            if !c.greyedOut {
                ret.append(c)
            }
        }
        
        return ret
    }
    
    func getCardPositions() -> [CGPoint] {
        return self.cardPositions
    }
    
    func getCardLocationIndex(card: Card) -> Int {
        return self.cardPositions.firstIndex(of: card.getLoc())!
    }
}

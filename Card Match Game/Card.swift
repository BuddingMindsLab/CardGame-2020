//
//  card.swift
//  CardMatchGame-Kids
//
//  Created by Budding Minds Admin on 2020-01-03.
//  Copyright © 2020 Budding Minds Admin. All rights reserved.
//

import Foundation
import UIKit

class Card {
    let imageName : String
    let greyedOut : Bool
    let loc : CGPoint
    var flipped : Bool
    var matched : Bool
    var touches : Int
    
    init (
        imageName : String,
        flipped : Bool = false,
        matched : Bool = false,
        touches : Int = 0,
        greyedOut : Bool,
        loc : CGPoint)
    {
        self.imageName = imageName
        self.flipped = flipped
        self.matched = matched
        self.touches = touches
        self.greyedOut = greyedOut
        self.loc = loc
    }
    
    func getTouches() -> Int {
        return self.touches
    }
    
    func addTouch() {
        self.touches += 1
    }
    
    func getLoc() -> CGPoint {
        return self.loc
    }
    
    func isGreyedOut() -> Bool {
        return self.greyedOut
    }
    
    func isFlipped() -> Bool {
        return self.flipped
    }
    
    func isMatched() -> Bool {
        return self.matched
    }
}

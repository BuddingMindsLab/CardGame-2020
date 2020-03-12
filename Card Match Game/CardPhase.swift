//
//  CardPhase.swift
//  CardMatchGame-Kids
//
//  Created by Budding Minds Admin on 2020-01-03.
//  Copyright © 2020 Budding Minds Admin. All rights reserved.
//

import Foundation

class CardPhase : Phase {
    var type: PhaseType
    
    /*
     CardPhase inherits from Phase
     A card phase is the view that contains card layouts that the users interact with
    */
    enum CardPhaseType {
        case InitialLearning
        case SecondLearning
        case Test
    }
    
    let cardLayout : Layout
    let backgroundImageName : String
    let phaseType : CardPhaseType
    
    var targetCards : [Card]
    var nextTargetIndex : Int = 0
    
    init (cardLayout : Layout, backgroundImageName : String, type : CardPhaseType) {
        self.cardLayout = cardLayout
        self.backgroundImageName = backgroundImageName
        self.targetCards = cardLayout.getTargetCards()
        self.phaseType = type
        self.type = PhaseType.CardPhase
    }
    
    func resetTargetIndex() {
        nextTargetIndex = 0
    }
    
    func shuffleTargets() {
        resetTargetIndex()
        
        let oldShuffle = self.targetCards
        var newShuffle = self.targetCards.shuffled()
        
        while newShuffle[0].imageName == oldShuffle[oldShuffle.count - 1].imageName {
            newShuffle = oldShuffle.shuffled()
        }
        
        self.targetCards = newShuffle
    }
    
    func resetCardTouches() {
        for card in cardLayout.getAllCards() {
            card.touches = 0
        }
    }
    
    func getNextTarget() -> Card {
        let nextCard = targetCards[nextTargetIndex]
        nextTargetIndex += 1
        
        return nextCard
    }
    
    func getBackgroundImageName() -> String {
        return self.backgroundImageName
    }
}

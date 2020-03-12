//
//  Experiment.swift
//  CardMatchGame-Kids
//
//  Created by Budding Minds Admin on 2020-01-05.
//  Copyright © 2020 Budding Minds Admin. All rights reserved.
//

import Foundation
import UIKit

class Experiment {
    struct CardOrder {
        var points : [CGPoint]
        var background : String
    }
    
    // Know all hard-coded layouts (A A' A; X X' X; Y Y' Y; etc.)
    let overlappingOrders : [[CardOrder]]
    let nonoverlappingOrders : [[CardOrder]]
    let order : [CardOrder]
    var experimentName : String
    var participantID : Int
    var groupID : Int
    var layoutIDs : [String]
    var videos : [String]
    
    let cardNames = ["ball", "banana", "bed", "bell", "bird", "boat", "bread", "bus", "butterfly", "cake", "car", "carrot", "chair", "chicken", "chocolate", "clown", "cookie", "crayons", "door", "egg", "fire", "flower", "hat", "ice cream", "cat", "milk", "orange", "pants", "pie", "pig", "dog", "rabbit", "reindeer", "shirt", "shoes", "snowman", "spider", "spoon", "towel", "bear", "cupcake", "dress", "fish", "horse", "lamp", "peas", "pencil", "plant", "princess", "rainbow", "strawberry", "tiger", "turtle", "bag", "candy", "train","baseball","grapes","suitcase","guitar","books","sunglasses","bow","box","brush","broom","clock","crown","tea","dice","duck","elephant","envelope","feather","giraffe","key","octopus","pan","phone","plane","shovel","sock","sunglasses","table","toothbrush","tree","trophy","umbrella","watermelon","yarn"]
    
    let cardNameDict =
    [
        "A": ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10", "card11", "card12", "card13", "card14", "card15", "card16", "card17", "card18"],
        "A'": ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10", "card11", "card12", "card13", "card14", "card15", "card16", "card17", "card18", "card19", "card20", "card21", "card22", "card23", "card24", "card25", "card26", "card27", "card28", "card29", "card30" ],
        "X": ["card31", "card32", "card33", "card34", "card35", "card36", "card37", "card38", "card39", "card40", "card41", "card42", "card43", "card44", "card45", "card46", "card47", "card48"],
        "X'": ["card31", "card32", "card33", "card34", "card35", "card36", "card37", "card38", "card39", "card40", "card41", "card42", "card43", "card44", "card45", "card46", "card47", "card48", "card49", "card50", "card51", "card52", "card53", "card54", "card55", "card56", "card57", "card58", "card59", "card60"],
        "Y": ["card61", "card62", "card63", "card64", "card65", "card66", "card67", "card68", "card69", "card70", "card71", "card72", "card73", "card74", "card75", "card76", "card77", "card78"],
        "Y'":["card61", "card62", "card63", "card64", "card65", "card66", "card67", "card68", "card69", "card70", "card71", "card72", "card73", "card74", "card75", "card76", "card77", "card78", "card79", "card80", "card81", "card82", "card83", "card84", "card85", "card86", "card87", "card88", "card89", "card90", ]
    ]
    
    // Hardcode all the orders
    let A_adult = [CGPoint(x: 191, y: 413), CGPoint(x: 1033, y: 142), CGPoint(x: 702, y: 871), CGPoint(x: 475, y: 169), CGPoint(x: 300, y: 837), CGPoint(x: 603, y: 571), CGPoint(x: 879, y: 344), CGPoint(x: 148, y: 879), CGPoint(x: 115, y: 132), CGPoint(x: 871, y: 743), CGPoint(x: 390, y: 475), CGPoint(x: 1082, y: 772),

        CGPoint(x: 330, y: 200), CGPoint(x: 120, y: 650), CGPoint(x: 410, y: 800), CGPoint(x: 660, y: 300), CGPoint(x: 720, y: 500), CGPoint(x: 1050, y: 400)]

    let Ap_adult = [CGPoint(x:525, y:839), CGPoint(x:925, y:526), CGPoint(x:535, y:338), CGPoint(x:858, y:126), CGPoint(x:251, y:607), CGPoint(x:225, y:171), CGPoint(x:890, y:900), CGPoint(x:718, y:76), CGPoint(x:600, y:82), CGPoint(x:75, y:390), CGPoint(x:500, y:620), CGPoint(x:760, y:700)]
    
    let A_youth = [CGPoint(x: 191, y: 413), CGPoint(x: 1033, y: 142), CGPoint(x: 702, y: 871), CGPoint(x: 524, y: 169), CGPoint(x: 315, y: 837), CGPoint(x: 603, y: 571), CGPoint(x: 879, y: 344), CGPoint(x: 148, y: 879), CGPoint(x: 115, y: 132), CGPoint(x: 871, y: 743), CGPoint(x: 390, y: 475), CGPoint(x: 1082, y: 772)]

    let Ap_youth = [CGPoint(x:490, y:839), CGPoint(x:975, y:526), CGPoint(x:680, y:338), CGPoint(x:778, y:76), CGPoint(x:101, y:607), CGPoint(x:294, y:171), CGPoint(x:890, y:900), CGPoint(x:240, y:575)]

    
    let X_adult = [CGPoint(x: 922, y: 247), CGPoint(x: 249, y: 209), CGPoint(x: 934, y: 865), CGPoint(x: 756, y: 554), CGPoint(x: 83, y: 697), CGPoint(x: 326, y: 603), CGPoint(x: 514, y: 264), CGPoint(x: 532, y: 862), CGPoint(x: 1027, y: 520), CGPoint(x: 282, y: 844), CGPoint(x: 119, y: 480), CGPoint(x: 726, y: 150),

        CGPoint(x: 65, y: 100), CGPoint(x: 100, y: 270), CGPoint(x: 400, y: 150), CGPoint(x: 540, y: 600), CGPoint(x: 660, y: 750), CGPoint(x: 770, y: 850)]

    let Xp_adult = [CGPoint(x:370, y:351), CGPoint(x:709, y:367), CGPoint(x:1050, y:884), CGPoint(x:92, y:863), CGPoint(x:430, y:533), CGPoint(x:1080, y:84), CGPoint(x:900, y:500), CGPoint(x:880, y:700),

        CGPoint(x: 400, y: 920), CGPoint(x: 1024, y: 300), CGPoint(x: 600, y: 420), CGPoint(x: 200, y: 650)]
    
    let X_youth = [CGPoint(x: 922, y: 247), CGPoint(x: 249, y: 209), CGPoint(x: 934, y: 865), CGPoint(x: 756, y: 554), CGPoint(x: 83, y: 697), CGPoint(x: 326, y: 603), CGPoint(x: 514, y: 264), CGPoint(x: 532, y: 862), CGPoint(x: 1027, y: 520), CGPoint(x: 282, y: 844), CGPoint(x: 119, y: 480), CGPoint(x: 726, y: 150)]

    let Xp_youth = [CGPoint(x:370, y:351), CGPoint(x:709, y:367), CGPoint(x:777, y:884), CGPoint(x:92, y:863), CGPoint(x:531, y:533), CGPoint(x:78, y:84), CGPoint(x:900, y:500), CGPoint(x:600, y:700)]
    
    let Y_adult = [CGPoint(x: 115, y: 888), CGPoint(x: 957, y: 246), CGPoint(x: 394, y: 710), CGPoint(x: 746, y: 773), CGPoint(x: 613, y: 424), CGPoint(x: 204, y: 187), CGPoint(x: 965, y: 485), CGPoint(x: 142, y: 507), CGPoint(x: 673, y: 155), CGPoint(x: 317, y: 414), CGPoint(x: 1007, y: 824), CGPoint(x: 568, y: 753), CGPoint(x: 800, y: 75), CGPoint(x: 1080, y: 115), CGPoint(x: 860, y: 824), CGPoint(x: 180, y: 700), CGPoint(x: 330, y: 870), CGPoint(x: 450, y: 900)]

    let Yp_adult = [CGPoint(x:752, y:581), CGPoint(x:285, y:604), CGPoint(x:222, y:879), CGPoint(x:808, y:313), CGPoint(x:516, y:129), CGPoint(x:327, y:98), CGPoint(x:450, y:475), CGPoint(x:642, y:920), CGPoint(x: 90, y: 300), CGPoint(x: 430, y: 290), CGPoint(x: 1090, y: 350), CGPoint(x: 1024, y: 640)]

    let Y_youth = [CGPoint(x: 115, y: 888), CGPoint(x: 957, y: 246), CGPoint(x: 394, y: 710), CGPoint(x: 746, y: 773), CGPoint(x: 613, y: 424), CGPoint(x: 204, y: 187), CGPoint(x: 965, y: 485), CGPoint(x: 142, y: 507), CGPoint(x: 673, y: 155), CGPoint(x: 317, y: 414), CGPoint(x: 1007, y: 824), CGPoint(x: 568, y: 753)]

    let Yp_youth = [CGPoint(x:752, y:581), CGPoint(x:170, y:704), CGPoint(x:319, y:889), CGPoint(x:808, y:313), CGPoint(x:516, y:129), CGPoint(x:327, y:98), CGPoint(x:450, y:475), CGPoint(x:850, y:900)]

    
    init (participantID : Int, experimentName : String) {
        self.participantID = participantID
        self.experimentName = experimentName
        self.groupID = 0
        
        let adult_A = CardOrder(points: A_adult, background: "pink.jpg")
        let adult_X = CardOrder(points: X_adult, background: "blue.png")
        let adult_Y = CardOrder(points: Y_adult, background: "orange.png")
        let adult_Ap = CardOrder(points: A_adult + Ap_adult, background: "pink.jpg")
        let adult_Xp = CardOrder(points: X_adult + Xp_adult, background: "blue.png")
        let adult_Yp = CardOrder(points: Y_adult + Yp_adult, background: "orange.png")
        
        let youth_A = CardOrder(points: A_youth, background: "pink.jpg")
        let youth_X = CardOrder(points: X_youth, background: "blue.png")
        let youth_Y = CardOrder(points: Y_youth, background: "orange.png")
        let youth_Ap = CardOrder(points: A_youth + Ap_youth, background: "pink.jpg")
        let youth_Xp = CardOrder(points: X_youth + Xp_youth, background: "blue.png")
        let youth_Yp = CardOrder(points: Y_youth + Yp_youth, background: "orange.png")
        
        let all_orders = [[youth_A, youth_X, youth_Y, youth_Ap, youth_Xp, youth_Yp],[youth_A, youth_X, youth_Y, youth_Ap, youth_Xp, youth_Yp],[adult_A, adult_X, adult_Y, adult_Ap, adult_Xp, adult_Yp]]
        
        let order = all_orders[appAgeVersion]
        
        // Set the overlapping and nonoverlapping counterbalancing groups
        let overlapping = [[order[0], order[3], order[0]],
                           [order[1], order[4], order[1]],
                           [order[2], order[5], order[2]]]
        
        let nonoverlapping = [[order[0], order[4], order[0]],
                              [order[1], order[5], order[1]],
                              [order[2], order[3], order[2]]]
        
        self.overlappingOrders = overlapping
        self.nonoverlappingOrders = nonoverlapping
                
        // Determine the order based on the participants ID number
        switch (participantID % 6) {
        case 0:
            self.order = self.overlappingOrders[0]
            self.groupID = 1
            self.layoutIDs = ["A", "A'", "A"]
            self.videos = ["start to pink.mp4", "stay_pink.png", "stay_pink.png"]
        case 1:
            self.order = self.nonoverlappingOrders[0]
            self.groupID = 2
            self.layoutIDs = ["A", "X'", "A"]
            self.videos = ["start to pink.mp4", "pink to blue.mp4", "blue to pink.mp4"]
        case 2:
            self.order = self.overlappingOrders[1]
            self.groupID = 3
            self.layoutIDs = ["X", "X'", "X"]
            self.videos = ["start to blue.mp4", "stay_blue.png", "stay_blue.png"]
        case 3:
            self.order = self.nonoverlappingOrders[1]
            self.groupID = 4
            self.layoutIDs = ["X", "Y'", "X"]
            self.videos = ["start to blue.mp4", "blue to orange.mp4", "orange to blue.mp4"]
        case 4:
            self.order = self.overlappingOrders[2]
            self.groupID = 5
            self.layoutIDs = ["Y", "Y'", "Y"]
            self.videos = ["start to orange.mp4", "stay_orange.png", "stay_orange.png"]
        case 5:
            self.order = self.nonoverlappingOrders[2]
            self.groupID = 6
            self.layoutIDs = ["Y", "A'", "Y"]
            self.videos = ["start to orange.mp4", "orange to pink.mp4", "pink to orange.mp4"]
        default:
            // Should never get here!
            self.order = [CardOrder(points: [CGPoint](), background: "")]
            self.layoutIDs = [""]
            self.videos = [""]
        }
    }
        
    // Create all the neccessary cards
    func createCards() -> [[Card]] {
        // Create layouts
        var layout1 = [Card]()
        var layout2 = [Card]()
        var layout3 = [Card]()
        
        let cards1 = cardNameDict[layoutIDs[0]]!
        let cards2 = cardNameDict[layoutIDs[1]]!
        let cards3 = cardNameDict[layoutIDs[2]]!
        
        var num_reg_cards = 0
        var num_prime_cards = 0
        
        if appAgeVersion == 0 {
            num_reg_cards = 12
            num_prime_cards = 8
        } else if appAgeVersion == 1 {
            num_reg_cards = 12
            num_prime_cards = 8
        } else { // == 2
            num_reg_cards = 18
            num_prime_cards = 12
        }
        
        // LAYOUT 1
        for i in 0...(num_reg_cards-1) { // The 18 cards
            layout1.append(Card(imageName: cards1[i], greyedOut: false, loc: self.order[0].points[i]))
        }
        
        // LAYOUT 2 - REGULAR
        for i in 0...(num_reg_cards-1) { // The 18 greyed-out cards
            layout2.append(Card(imageName: cards2[i], greyedOut: true, loc: self.order[1].points[i]))
        }
        
        // LAYOUT 2 - GREYED OUT
        for i in num_reg_cards...(num_reg_cards+num_prime_cards-1) { // The 12 non greyed-out cards
            print(cards2.count)
            layout2.append(Card(imageName: cards2[i], greyedOut: false, loc: self.order[1].points[i]))
        }
        
        // LAYOUT 3
        for i in 0...(num_reg_cards-1) { // The 18 cards
            layout3.append(Card(imageName: cards3[i], greyedOut: false, loc: self.order[2].points[i]))
        }
        
        return [layout1, layout2, layout3]
    }
    
    // Create the layouts
    func createLayouts() -> [Layout] {
        var layoutList = [Layout]()
        
        for cardList in createCards() {
            layoutList.append(Layout(cards: cardList))
        }
        
        return layoutList
    }
    
    // Create phases for the given layouts
    func createPhases() -> [Phase] {
        var phaseList = [Phase]()
        let layoutList = createLayouts()
        
        phaseList.append(CardPhase(cardLayout: layoutList[0], backgroundImageName: self.order[0].background, type: CardPhase.CardPhaseType.InitialLearning))
        phaseList.append(CardPhase(cardLayout: layoutList[1], backgroundImageName: self.order[1].background, type: CardPhase.CardPhaseType.SecondLearning))
        phaseList.append(CardPhase(cardLayout: layoutList[2], backgroundImageName: self.order[2].background, type: CardPhase.CardPhaseType.Test))
        
        return phaseList
    }
}

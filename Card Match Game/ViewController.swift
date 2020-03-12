//
//  ViewController.swift
//
//  Main view controller used to control the game view
//
//  Card Match Game
//
//  Created by Budding Minds Admin on 2018-01-27.
//  Copyright © 2018 Budding Minds Admin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

extension String {
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

// Should only manage the view
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Making a delegate to communicate with
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var targetCard: UIImageView!
    @IBOutlet var pattern: UIImageView!
    

    //var csvWriter = CSVWriter()
    var pHandler = PausedHandler()
        
    struct Info {
        var location : Int
        var obj : String
    }
     
    var player: AVAudioPlayer!
    var cardCount = 8
    var main : Experiment = Experiment(participantID: -1, experimentName: "exp_name")
    var phases : [Phase] = [Phase]()
    var cardPhaseNum = 0
    
    var currentPhase = 0
    var advancePhase = false
    var targetCount = -1
    var numReps = 0
    
    var any_card_touched = false
    
    var goalInfo : Info = Info(location: -1, obj: "")
    var touchInfo : Info = Info(location: -1, obj: "")

    var time = -1
    var timeRT = 0
    
    var trialNum = 0
    
    var numPerfect = 0
    var vidNum = 0
    
    var firstPhase = false
    
    var currentLine = [String]()
    var csvWriter : CSVWriter = CSVWriter(experimentName: "", participantID: -1)
    
    @IBOutlet weak var instr3Image: UIImageView!
    
    @IBOutlet weak var videoBckg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instr3Image.alpha = 0
        
        // Create Experiment
        main = Experiment(participantID: Int(participantID)!, experimentName: experimentName)
        phases = main.createPhases()
        
        for p in phases {
            if p.type == PhaseType.CardPhase {
                let curP = p as! CardPhase
                
                curP.shuffleTargets()
            }
        }
        csvWriter = CSVWriter(experimentName: main.experimentName, participantID: main.participantID)

        
        if unpausing {
            currentPhase = 2 // second phase
            pHandler.removePaused(id: participantID)
            csvWriter.writtenHeader = true
        }
        
        print("Current phase (load): " + String(currentPhase))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Current phase (appear): " + String(currentPhase))

        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Get the correct-sound.wav file and load it into player
        let path = Bundle.main.path(forResource: "correct-sound", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
        
        // Play the first video
        if !unpausing && currentPhase == 0 {
            firstPhase = true
            let file = main.videos[vidNum]
            playVideo(from: file)
        // Play the video to start unpause part
        } else if unpausing {
            let file = main.videos[2]
            playVideo(from: file)
            currentPhase = 1
        }
        
        nextPhase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // **************************************
    //
    //        CollectionView Functions
    //
    // **************************************
    
    // Returns the size of the cards in the collectionView
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 240)
    }
    
    // Returns the number of cards in the collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardCount
    }
    
    // Determines the properties of each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let curPhase = phases[currentPhase] as! CardPhase
        let cardList = curPhase.cardLayout.getAllCards()
        
        // Returns cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlippableCardCell", for: indexPath) as! CardCollectionViewCell
        
        // Sets the card that's to be displayed via the setCard method
        let card = cardList[indexPath.row]
        
        // Assign that card to the cell
        cell.setCard(card)
        
        // Set pattern background
        pattern.image = UIImage(named: curPhase.getBackgroundImageName())
        
        let cardPositions = curPhase.cardLayout.getCardPositions()
        
        // Set cardCount based on the amount of positions returned
        cardCount = cardPositions.count
        
        // Set the card position by centerpoints retrieved from CardModel class
        cell.center = cardPositions[indexPath.row]

        return cell
    }
    
    // Determines what happens when a cell was clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let curPhase = phases[currentPhase] as! CardPhase
        let cardList = curPhase.cardLayout.getAllCards()
        
        let touched_cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let touched_card = cardList[indexPath.row]
                
        trialNum += 1
        
        if !touched_card.greyedOut {
            // Only allow card to be flipped if it's not already flipped
            if !touched_card.flipped && !any_card_touched {
                setTouchInfo(card: touched_card)
                any_card_touched = true
                touched_card.flipped = true
                
                touched_cell.flip(phase: currentPhase)
                                
                touched_card.addTouch()
                print("\(touched_card.imageName) has been touched \(touched_card.touches) times")
                
                // Check if the flipped card matches the target card
                checkForMatch(indexPath)
            }
        } else {
            touched_card.touches += 1
            print("\(touched_card.imageName) has been touched \(touched_card.touches) times")
        }
        
        sendToCsv(cell: touched_cell, card: touched_card)
    }
    
    // **************************************
    //
    //        Video Playing Functions
    //
    // **************************************
    
    var playerLayer = AVPlayerLayer()
    var videoNotPlaying = true
    
    // Function used to play a transition video when changing layouts
    func playVideo(from file:String) {
        let remaind = self.main.participantID % 6
        if !self.firstPhase && (remaind == 0 || remaind == 2 || remaind == 4) {
            self.instr3Image.image = UIImage(named: self.main.videos[2])
            self.instr3Image.alpha = 1

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.instr3Image.alpha = 0
            }
        } else {
            self.firstPhase = false
            let file = file.components(separatedBy: ".")

            guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
                debugPrint( "\(file.joined(separator: ".")) not found")
                return
            }
            let player = AVPlayer(url: URL(fileURLWithPath: path))

            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            self.view.layer.addSublayer(playerLayer)

            // Disable touch and make background black
            self.view.isUserInteractionEnabled = false
            videoBckg.alpha = 1

            videoNotPlaying = false
            player.play()

            NotificationCenter.default.addObserver(self, selector: #selector(stopScreenSaver), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
    }
    
//    var written = false
    
    // Function used to return to game after video completes playback
    @objc func stopScreenSaver(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0)) {
            self.playerLayer.removeFromSuperlayer()
            // Enable touch and remove black background
            self.view.isUserInteractionEnabled = true
            self.videoBckg.alpha = 0
            self.videoNotPlaying = true
        }
    }
    
    func playMatchSound() {
        player.play()
    }
    
    // **************************************
    //
    //        Stat Gathering Functions
    //
    // **************************************
    
    func setGoalInfo(card: Card) {
        let curPhase = phases[currentPhase] as! CardPhase
        
        goalInfo.location = curPhase.cardLayout.getCardLocationIndex(card: card)
        goalInfo.obj = main.cardNames[Int(card.imageName.digits)! - 1]
    }
    
    func setTouchInfo(card: Card) {
        let curPhase = phases[currentPhase] as! CardPhase
        
        touchInfo.location = curPhase.cardLayout.getCardLocationIndex(card: card)
        
        if touchInfo.location == -1 {
            touchInfo.obj = "greyed-out"
        } else {
            touchInfo.obj = main.cardNames[Int(card.imageName.digits)! - 1]
        }
    }
    
    func getNumReps() -> Int {
        return self.numReps
    }
    
    func getAccuracy() -> Int {
        if (goalInfo.obj == touchInfo.obj) && (goalInfo.location == touchInfo.location) {
            return 1
        } else {
            return 0
        }
    }
    
    func gotPerfect() -> Bool {
        let curPhase = phases[currentPhase] as! CardPhase
        let cardList = curPhase.cardLayout.getTargetCards()
        
        var perf = true
        
        for card in cardList {
            if card.touches != 1 {
                perf = false
                break
            }
        }
        
        return perf
    }
    
    // **************************************
    //
    //              CSV Functions
    //
    // **************************************
    
    // Helper function to send current line to the csv writer
    func sendToCsv(cell: CardCollectionViewCell, card: Card) {
        // 1 - experiment name
        currentLine.append(main.experimentName)
        //print("------ exp name: " + String(main.experimentName) + "------")
        
        // 2 - group ID
        currentLine.append(String(main.groupID))
        //print("------ group id: " + String(main.groupID) + "------")
        
        // 3 - subject #
        currentLine.append(String(main.participantID))
        //print("------ subject #: " + String(main.participantID) + "------")
        
        // 4 - block ID
        currentLine.append(String(currentPhase + 1))
        print("------ block ID #: " + String(currentPhase + 1) + "------")
        
        // 5 - configuration/layout ID
        currentLine.append(String(main.layoutIDs[currentPhase]))
        print("------ layout ID : " + String(main.layoutIDs[currentPhase]) + "------")
        
        // 6 - trial #
        currentLine.append(String(trialNum))
        //print("------ trial #: " + String(trialNum) + "------")
        
        // 7 - goal location
        currentLine.append(String(goalInfo.location))
        //print("------ goal loc : " + String(goalInfo.location) + "------")
        
        // 8 - goal object
        currentLine.append(String(goalInfo.obj))
        //print("------ goal obj : " + String(goalInfo.obj) + "------")
        
        // 9 - rep #
        currentLine.append(String(numReps + 1))
        //print("------ rep #: " + String(numReps + 1) + "------")
        
        // 10 - touch location
        currentLine.append(String(touchInfo.location))
        print("------ touch loc: " + String(touchInfo.location) + "------")
        
        // 11 - touch object
        if card.imageName == "" {
            currentLine.append("grayed-out")
        } else {
            currentLine.append(touchInfo.obj)
            //print("------ touch obj: " + String(touchInfo.obj) + "------")
        }
        
        // 12 - touch time (from last thing touched/level start)
        timeRT = Int(CACurrentMediaTime() * 1000) - time

        currentLine.append(String(timeRT))
        //print("------ timeRT: " + String(timeRT) + "------")
        
        // 13 - Accuracy (1/0) if the touch obj = goal obj
        currentLine.append(String(getAccuracy()))
        //print("------ accuracy: " + String(getAccuracy()) + "------")
        
        csvWriter.writeLine(elements: currentLine)
        
        currentLine = [String]()
    }
    
    // Function that writes start/end block time to the data file
    func writeBlockTime() {
        
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        
        let date = formatter.string(from: currentDateTime)
        
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        
        let clockTime = formatter.string(from: currentDateTime)
        
        var line = ["","","","","","","","","","","","",""]
        line.append("\(date) \(clockTime)")
        csvWriter.writeLine(elements: line)
    }
    
    // **************************************
    //
    //        Pausing Related Functions
    //
    // **************************************
    
    // Function that "pauses" the game by saving particpant ID in file allowing for continuation of part2
    func pause() {
        instr3Image.alpha = 1
        pHandler.writePaused(id: participantID)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0)) {
            self.performSegue(withIdentifier: "gameToPause", sender: self)
        }
    }
    
    // **************************************
    //
    //        Game-Related Functions
    //
    // **************************************
    
    func restartCurrentCardPhase() {
        let curPhase = phases[currentPhase] as! CardPhase
        
        numReps += 1
        targetCount = -1
        cardPhaseNum -= 1
        
        curPhase.shuffleTargets()
        curPhase.resetCardTouches()
    }
    
    func nextTarget() -> Bool {
        let curPhase = phases[currentPhase] as! CardPhase
        targetCount += 1
        
        if targetCount == curPhase.targetCards.count {
            targetCount = -1
            
            if currentPhase == 2 {
                // Then we don't care about the move-on criteria, just go on
                return false
            }
            
            if gotPerfect() {
                print("Got perfect!")
                numPerfect += 1
                
                if numPerfect == 2 {
                    numPerfect = 0
                    print("2 perfect in a row!")
                    advancePhase = true
                    return false
                }
            } else {
                print("Not perfect!")
                numPerfect = 0
            }
            
            restartCurrentCardPhase()
            return false
        }
        
        let target = curPhase.targetCards[targetCount]
        self.targetCard.image = UIImage(named:target.imageName)
        
        setGoalInfo(card: target)
        
        return true
    }
    
    func nextPhase() {
        print("Current Phase (nextPhase): " + String(currentPhase) + "/" + String(phases.count))
        // Check if curPhase is out of bounds if so then send to finish screen

        if currentPhase == (phases.count - 1) {
            performSegue(withIdentifier: "gameToEnd", sender: self)
        }
        
        if advancePhase {
            numReps = 0
            currentPhase += 1
            advancePhase = false
            
            if currentPhase == 1 {
                //pause()
            }
            
            let file = main.videos[currentPhase]
            playVideo(from: file)
            
//            if currentPhase == 2 {
//                let file = main.videos[currentPhase]
//                playVideo(from: file)
//            }
        }
        
        let curPhase = phases[currentPhase]
        
        if curPhase.type == PhaseType.CardPhase {
            let curPhase = phases[currentPhase] as! CardPhase
            
            cardPhaseNum += 1
             
            cardCount = curPhase.cardLayout.getAllCards().count
                        
            // Set target card image
            _ = nextTarget()
            
            collectionView.reloadData()
            
            time = Int(CACurrentMediaTime() * 1000)
        } else {
            // PhaseType.VideoPhase
        }
    }
    
    func checkForMatch(_ flippedIndex: IndexPath) {
        let curPhase = phases[currentPhase] as! CardPhase
        let cardList = curPhase.cardLayout.getAllCards()
        
        let touched_cell = collectionView.cellForItem(at: flippedIndex) as! CardCollectionViewCell
        let touched_card = cardList[flippedIndex.row]
        
        let targetList = curPhase.targetCards
        
        let match = (targetList[targetCount].imageName == touched_card.imageName)
        
        // Flip card back
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            touched_cell.flipBack(phase: self.currentPhase)
            touched_card.flipped = false
            
            self.any_card_touched = false
            
            // If match then change target and play sound
            if match && self.currentPhase != 2 {
                self.playMatchSound()
            }
            
            if match || self.currentPhase == 2 {
                let isNext = self.nextTarget()
                
                if !isNext {
                    self.nextPhase()
                }
            }
        }
    }
}


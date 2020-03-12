//
//  IDScreenViewController.swift
//  Card Match Game
//
//  Created by Budding Minds Admin on 2018-02-10.
//  Copyright © 2018 Budding Minds Admin. All rights reserved.
//

import UIKit
import AVKit

var participantID = ""
var experimentName = "A8"
var unpausing = false
var appAgeVersion = 0 // 0 - kids, 1 - youth, 2 - adults

extension UIViewController {
    
    // Original toast function made by Stack Overflow user "Mr.Bean",
    // edited for my purposes
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height * 0.7, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 7.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }

class IDScreenViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var idTextBox: UITextField!
    @IBOutlet weak var nameTextBox: UITextField!
    
    var pausedHandler = PausedHandler()
    
    @IBAction func kidsBtnPressed(_ sender: UIButton) {
        appAgeVersion = 0
        pressed()
    }
    
    @IBAction func youthBtnPressed(_ sender: UIButton) {
        appAgeVersion = 1
        pressed()
    }
    
    @IBAction func adultBtnPressed(_ sender: UIButton) {
        appAgeVersion = 2
        pressed()
    }
    
    // When the submit button pressed, check if this user ID is paused and handle accordingly
    func pressed() {
        if (idTextBox.text != "") {
            participantID = idTextBox.text!

            if nameTextBox.text != "" {
                experimentName = nameTextBox.text!
            }
            print("expName: \(experimentName)")
            let num = Int(participantID) ?? -1

            if num == -1 {
                showToast(message: "Please enter a numeric ID")
            } else {
                checkPaused()
            }
        }
    }
    
    // Check if user ID is paused and perform segue properly
    func checkPaused() {
        if pausedHandler.checkPaused(id: participantID) {
            performSegue(withIdentifier: "idToUnpauseCheck", sender: self)
        } else {
            instructionToShow = 1
            
            // Leave this code in to show the instruction page before starting the experiment
//            performSegue(withIdentifier: "idToInstr", sender: self)
            
            // Uncomment this code to skip over the instruction page before starting the experiment
             performSegue(withIdentifier: "idToGame", sender: self)
        }
    }
    
    // Hide the keyboard when touched outside of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide the keyboard when the return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        idTextBox.resignFirstResponder()
        nameTextBox.resignFirstResponder()
        return (true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.idTextBox.delegate = self
        self.nameTextBox.delegate = self
        
        nameTextBox.text = experimentName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//
//  ViewController.swift
//  Random Reward
//
//  Created by Ravi Tadinada on 6/6/16.
//  Copyright © 2016 Ravi Tadinada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    var timerValue = NSTimeInterval() // number of seconds on timer when timer started
    var startTime : NSTimeInterval? // time when timer started
    var timer : NSTimer?

    // MARK: Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayTime(0)
        setButtonStart()
    }
    
    
    // MARK: Actions
    
    @IBAction func buttonPressed(sender: UIButton) {
        if let timerObj = timer {
            timerValue = getUpdatedTime()
            timerObj.invalidate()
            timer = nil
            setButtonStart()
        }
        else {
            startTime = NSDate.timeIntervalSinceReferenceDate()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            setButtonStop()
        }
        
    }
    
    func setButtonStart() {
        let buttonColor = UIColor(red: 72/255, green: 164/255, blue: 70/255, alpha: 1)
        let textColor = UIColor(red: 36/255, green: 82/255, blue: 35/255, alpha: 1)
        
        startStopButton.backgroundColor = buttonColor
        startStopButton.setTitleColor(textColor, forState: .Normal)
        startStopButton.setTitle("Start", forState: .Normal)
    }
    
    func setButtonStop() {
        let buttonColor = UIColor(red: 170/255, green: 0, blue: 0, alpha: 1)
        let textColor = UIColor(red: 90/255, green: 0, blue: 0, alpha: 1)
        
        startStopButton.backgroundColor = buttonColor
        startStopButton.setTitleColor(textColor, forState: .Normal)
        startStopButton.setTitle("Stop", forState: .Normal)
    }
    
    func updateTime() {
        displayTime(getUpdatedTime())
    }
    
    func getUpdatedTime() -> NSTimeInterval {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        let elapsedTime = currentTime - startTime!
        
        return elapsedTime + timerValue
    }
    
    func displayTime(time : NSTimeInterval) {
        let seconds = UInt8(time % 60)
        let minutes = UInt8((time/60) % 60)
        let hours = Int(time/60/60)
        
        timeLabel.text = String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }


}


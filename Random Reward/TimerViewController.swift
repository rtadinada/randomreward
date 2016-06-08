//
//  TimerViewController.swift
//  Random Reward
//
//  Created by Ravi Tadinada on 6/6/16.
//  Copyright © 2016 Ravi Tadinada. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    // MARK: Properties
    var stopwatchValue = NSTimeInterval() // number of seconds on timer when stopwatch started
    var startTime : NSTimeInterval? // time when stopwatch started
    var timer : NSTimer?

    // MARK: Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayTime(0)
        buttonPressed(pauseResumeButton)
    }
    
    
    // MARK: Actions
    
    @IBAction func buttonPressed(sender: UIButton) {
        if let timerObj = timer {
            // stopwatch is running
            stopwatchValue = getUpdatedTime()
            timerObj.invalidate()
            timer = nil
            setButtonResume()
        }
        else {
            // stopwatch is paused
            startTime = NSDate.timeIntervalSinceReferenceDate()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            setButtonPause()
        }
        
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setButtonResume() {
        pauseResumeButton.setTitle("Resume", forState: .Normal)
    }
    
    func setButtonPause() {
        pauseResumeButton.setTitle("Pause", forState: .Normal)
    }
    
    func updateTime() {
        displayTime(getUpdatedTime())
    }
    
    func getUpdatedTime() -> NSTimeInterval {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        let elapsedTime = currentTime - startTime!
        
        return elapsedTime + stopwatchValue
    }
    
    func displayTime(time : NSTimeInterval) {
        let seconds = UInt8(time % 60)
        let minutes = UInt8((time/60) % 60)
        let hours = Int(time/60/60)
        
        timeLabel.text = String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }


}


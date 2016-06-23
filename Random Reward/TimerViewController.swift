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
    var alertTime : NSTimeInterval! // time on stopwatch when to alert
    var alertTimer : NSTimer?

    // MARK: Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayTime(0)
        alertTime = getNextAlertInterval()
        buttonPressed(pauseResumeButton) // starts the timer
    }
    
    
    // MARK: Actions
    
    /**
        Pause or resume the timer when the pauseResumeButton is pressed
    */
    @IBAction func buttonPressed(sender: UIButton) {
        if timer != nil {
            // stopwatch is running, pause it
            pause()
        }
        else {
            // stopwatch is paused, resume it
            resume()
        }
        
    }
    
    /**
        Dismissed the view when the stop button is pressed.
    */
    @IBAction func stopButtonPressed(sender: UIButton) {
        timer?.invalidate()
        alertTimer?.invalidate()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK : Methods
    
    /**
        Pauses the stopwatch.
    **/
    func pause() {
        stopwatchValue = getUpdatedTime()
        timer?.invalidate()
        timer = nil
        alertTimer?.invalidate()
        alertTimer = nil
        setButtonResume()
    }
    
    /**
        Resumes the stopwatch.
    **/
    func resume() {
        if timer != nil {
            // stopwatch already running
            return
        }
        
        startTime = NSDate.timeIntervalSinceReferenceDate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        setButtonPause()
        
        // start the alert timer
        if alertTime > stopwatchValue {
            alertTimer = NSTimer.scheduledTimerWithTimeInterval(alertTime - stopwatchValue, target: self, selector: #selector(displayAlert), userInfo: nil, repeats: false)
        }
    }
    
    /**
        Sets the pauseResumeButton to Resume.
    */
    func setButtonResume() {
        pauseResumeButton.setTitle("Resume", forState: .Normal)
    }
    
    /**
        Sets the pauseResumeButton to Pause.
    */
    func setButtonPause() {
        pauseResumeButton.setTitle("Pause", forState: .Normal)
    }
    
    /**
        Updates the time label to the time on the stopwatch.
    */
    func updateTime() {
        displayTime(getUpdatedTime())
    }
    
    /**
        Returns the time the stopwatch should dislpay.
 
        - Returns: the time interval to be displayed on the stopwatch
    */
    func getUpdatedTime() -> NSTimeInterval {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        let elapsedTime = currentTime - startTime!
        
        return elapsedTime + stopwatchValue
    }
    
    /**
        Sets the label to the hour minutes seconds version of a time interval.
 
        - Parameter time: the time interval to be displayed
    */
    func displayTime(time: NSTimeInterval) {
        let seconds = UInt8(time % 60)
        let minutes = UInt8((time/60) % 60)
        let hours = Int(time/60/60)
        
        timeLabel.text = String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }

    /**
        Displays the alert to notify user to reward themselves.
    */
    func displayAlert() {
        // pause the timer and set new alert time
        pause()
        alertTime = getNextAlertInterval() + stopwatchValue
        
        let alertController = UIAlertController(title: "Time for a reward!", message: "Dismiss to get back to work.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "Dismiss", style: .Default, handler: { _ -> Void in self.resume() })
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    /**
        Returns the time till next reward.
 
        - Returns: time till next reward
    **/
    func getNextAlertInterval() -> NSTimeInterval {
        return NSTimeInterval(10)
    }
    
}


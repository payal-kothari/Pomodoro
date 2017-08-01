//
//  FirstViewController.swift
//  Pomodoro
//
//  Created by Payal Kothari on 4/26/17.
//  Copyright © 2017 Payal Kothari. All rights reserved.
//

import UIKit
import UserNotifications
import AudioToolbox

class ClockVC: UIViewController, UNUserNotificationCenterDelegate {

    var circleView = UI()
    
    enum ButtonNames: String {
        case Start, Pause, Continue
    }
    
    enum Status: String {
        case Stopped, Running, Paused
    }
    
    @IBOutlet weak var addDistractionLabel: UIButton!
    @IBOutlet weak var distractionCountLabel: UILabel!
    let pomodoro = "Pomodoro"
    let shortBreak = "Short break"
    let longBreak = "Long break"
    let elapsedTimeKey = "elapsedTime"
    let distractionKey = "distraction"
    var converedTimeBeforeLeaving : Int?
    var currentTimeAfterReturning : Int?
    
    @IBOutlet weak var pomodoroImage5: UIImageView!
    @IBOutlet weak var pomodoroImage4: UIImageView!
    @IBOutlet weak var pomodoroImage3: UIImageView!
    @IBOutlet weak var pomodoroImage2: UIImageView!
    @IBOutlet weak var pomodoroImage1: UIImageView!
    @IBOutlet weak var name: UILabel!
    var clock = Clock()
    var timer = Timer()
    var minute = 0
    var second = 0
    var pomodoroTotal = 0
    var longBreakFlag = false
    var pomodoroFlag = true
    var shortBreakFlag = false
    var pickedValue = 0
    var elapsedTime = 0
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var pomodoroCount: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func addDistraction(_ sender: UIButton) {
        var distractionCount = UserDefaults.standard.integer(forKey: distractionKey)
        distractionCount = distractionCount + 1
        distractionCountLabel.text = "\(distractionCount)"
        UserDefaults.standard.set(distractionCount, forKey:distractionKey)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let circle = UI(frame: CGRect(x: 0, y: 0, width: 5, height: 10))
        view.addSubview(circle)
        // drawing yellow circle
        circle.animateCircle(duration: 0.001)

        self.minute = clock.getPomodoro()
        self.second = 0
        self.clockLabel.text = "\(self.minute)" + " : " + "\(self.second)"
        UserDefaults.standard.set(0, forKey:elapsedTimeKey)
        appDelegate.appStatus = Status.Stopped.rawValue
        appDelegate.runningActivity = pomodoro
    }

    func pomodoroSetup() {
        self.minute = clock.getPomodoro()
        self.second = 0
        self.name.text = pomodoro
    }
    
    func shortBreakSetup() {
        self.minute = clock.getShortBreak()
        self.second = 0
        self.name.text = shortBreak
    }
    
    func longBreakSetup() {
        self.minute = clock.getLongBreak()
        self.second = 0
        self.name.text = longBreak
    }
    
    func initialTimeSetup() {
        self.clock = Clock()
        if !timer.isValid {
            if pomodoroFlag == true {
                pomodoroSetup()
            }else if shortBreakFlag == true {
                shortBreakSetup()
            }else {
                longBreakSetup()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialTimeSetup()
        self.clockLabel.text = "\(self.minute)" + " : " + "\(self.second)"
    }

    
    func updateFromBackground(_ Time : Int) {
        UserDefaults.standard.set(Time, forKey:elapsedTimeKey)
    }
    
    @IBAction func startStopClick(_ sender: UIButton) {
        if pomodoroFlag == true {
            self.name.text = pomodoro
            appDelegate.runningActivity = pomodoro
        }else if shortBreakFlag == true {
            self.name.text = shortBreak
            appDelegate.runningActivity = shortBreak
        }else {
            self.name.text = longBreak
            appDelegate.runningActivity = longBreak
        }

        
        if startStopButton.titleLabel?.text == ButtonNames.Start.rawValue {
            circleView.clearLayers()
            let delay = (self.minute) * 14
            let interval = self.minute * 60 + self.second + delay
            self.addCircleView(interval: (TimeInterval(interval)))
            if !timer.isValid{
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                appDelegate.timerIsOn = true
            }
            startStopButton.setTitle(ButtonNames.Pause.rawValue, for: .normal)
            appDelegate.appStatus = Status.Running.rawValue
            stopButton.isHidden = false
        }else if startStopButton.titleLabel?.text == ButtonNames.Pause.rawValue {
            invalidateTimer()
            circleView.pauseAnimation()
            startStopButton.setTitle(ButtonNames.Continue.rawValue, for: .normal)
            appDelegate.appStatus = Status.Paused.rawValue
        }else if startStopButton.titleLabel?.text == ButtonNames.Continue.rawValue {
            circleView.resumeAnimation()
            if !timer.isValid {
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                appDelegate.timerIsOn = true
            }
            startStopButton.setTitle(ButtonNames.Pause.rawValue, for: .normal)
            appDelegate.appStatus = Status.Running.rawValue
        }
    }
    
    func invalidateTimer() {
        timer.invalidate()
        appDelegate.timerIsOn = false
    }
    
    @IBAction func stopClock(_ sender: UIButton) {
        circleView.clearLayers()
        
        invalidateTimer()
        appDelegate.appStatus = Status.Stopped.rawValue
        setButtonToStart()
        
        initialTimeSetup()
        self.clockLabel.text = "\(self.minute)" + " : " + "\(self.second)"
        
    }
    
    func addCircleView(interval : TimeInterval) {
        // Create a new CircleView
        self.circleView = UI(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        view.addSubview(circleView)
        
        // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(duration: interval)
    }
    
    func setButtonToStart() {
        startStopButton.setTitle(ButtonNames.Start.rawValue, for: .normal)
        stopButton.isHidden = true
    }
    
    func reduceSeconds() {
        if self.second != 0 {
            self.second = self.second - 1
        }
    }
    
    func reduceMinutes() {
        if self.second == 0 && self.minute != 0 {
            self.minute = self.minute - 1
            self.second = 59
        }
    }
    
    func showPomodoroImages() {
        if pomodoroTotal == 1 {
            pomodoroImage1.isHidden = false
        }else if pomodoroTotal == 2 {
            pomodoroImage1.isHidden = false
            pomodoroImage2.isHidden = false
        }else if pomodoroTotal == 3 {
            pomodoroImage1.isHidden = false
            pomodoroImage2.isHidden = false
            pomodoroImage3.isHidden = false
        }else if pomodoroTotal == 4 {
            pomodoroImage1.isHidden = false
            pomodoroImage2.isHidden = false
            pomodoroImage3.isHidden = false
            pomodoroImage4.isHidden = false
        }else if pomodoroTotal == 5{
            pomodoroImage1.isHidden = false
            pomodoroImage2.isHidden = false
            pomodoroImage3.isHidden = false
            pomodoroImage4.isHidden = false
            pomodoroImage5.isHidden = false
        }else if pomodoroTotal == 0 {
            pomodoroImage1.isHidden = true
            pomodoroImage2.isHidden = true
            pomodoroImage3.isHidden = true
            pomodoroImage4.isHidden = true
            pomodoroImage5.isHidden = true
        }
    }
    
    func onPomodoroFinished() {
        let distractionCount = UserDefaults.standard.integer(forKey: distractionKey)
        if self.minute == 0 && self.second == 0 {
            if distractionCount < 4 {
                // pomodoro is over .. start short break
                pomodoroTotal = pomodoroTotal + 1
                pomodoroCount.text = "\(pomodoroTotal)"
                showPomodoroImages()
                pomodoroFlag = false
                shortBreakFlag = true
                invalidateTimer()
                setButtonToStart()
                
                // set data for short break
                shortBreakSetup()
                appDelegate.runningActivity = shortBreak
                distractionCountLabel.isHidden = true
                addDistractionLabel.isHidden = true
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                AudioServicesPlaySystemSound(1034)
            }else {
                pomodoroTotal = pomodoroTotal + 1
                pomodoroCount.text = "\(pomodoroTotal)"
                showPomodoroImages()
                onShortBreakFinished()
            }
        }
    }
    
    func onShortBreakFinished() {
        if self.minute == 0 && self.second == 0 {
            // short break is over.. start pomodoro
            distractionCountLabel.isHidden = false
            addDistractionLabel.isHidden = false
            pomodoroSetup()
            self.appDelegate.runningActivity = pomodoro
            pomodoroFlag = true
            shortBreakFlag = false
            invalidateTimer()
            setButtonToStart()
            UserDefaults.standard.set(0, forKey:distractionKey)
            let distractionCount = UserDefaults.standard.integer(forKey:distractionKey)
            distractionCountLabel.text = "\(distractionCount)"
            // set data for pomodoro break
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            AudioServicesPlaySystemSound(1034)
        }
    }
    
    func onLongBreakFinished() {
        if self.minute == 0 && self.second == 0 {
            distractionCountLabel.isHidden = false
            addDistractionLabel.isHidden = false
            pomodoroSetup()
            self.appDelegate.runningActivity = pomodoro
            pomodoroFlag = true
            shortBreakFlag = false
            longBreakFlag = false
            pomodoroTotal = 0
            pomodoroCount.text = "\(pomodoroTotal)"
            UserDefaults.standard.set(0, forKey:distractionKey)
            let distractionCount = UserDefaults.standard.integer(forKey:distractionKey)
            distractionCountLabel.text = "\(distractionCount)"
            showPomodoroImages()
            invalidateTimer()
            setButtonToStart()
            // set data for pomodoro break
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            AudioServicesPlaySystemSound(1034)
        }

    }
    
    func checkElapsedTimed() {
        // to adjust time from app comes on foreground from background
        if let val = UserDefaults.standard.integer(forKey: elapsedTimeKey) as? Int {
            self.elapsedTime = Int(val)
            if self.elapsedTime != 0 {
                let totalSecInClockVC = (self.minute * 60 ) + self.second
                if timer.isValid {
                    if totalSecInClockVC > elapsedTime { // subtract the passed time
                        let finalTimeInSec = totalSecInClockVC - elapsedTime
                        self.minute = Int(finalTimeInSec / 60 )
                        self.second = finalTimeInSec % 60
                    }else{ // if already passed all the time
                        self.minute = 0
                        self.second = 0
                    }
                }
                UserDefaults.standard.set(0, forKey:elapsedTimeKey)
            }
        }
    }
    
    func updateTime() {
        appDelegate.currentTime = self.minute *  60 + self.second
        
        checkElapsedTimed()
        
        if pomodoroTotal != clock.getNumberOfPomodoros() {
            if pomodoroFlag == true {
                // pomodoro
                reduceSeconds()
                reduceMinutes()
                onPomodoroFinished()
            }else if shortBreakFlag == true {
                // short break
                reduceSeconds()
                reduceMinutes()
                onShortBreakFinished()
            }
        }else {
            // long break
            reduceSeconds()
            reduceMinutes()
            onLongBreakFinished()
        }
        
        checkPomodoroTotalOver()
        clockLabel.text = String(self.minute) + " : " + String(self.second)
    }
    
    func checkPomodoroTotalOver() {
        if pomodoroTotal == clock.getNumberOfPomodoros() && longBreakFlag == false {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            AudioServicesPlaySystemSound(1034)
            // all pomodoros are done.. start long break
            // set data for long break
            longBreakSetup()
            distractionCountLabel.isHidden = true
            addDistractionLabel.isHidden = true
            appDelegate.runningActivity = longBreak
            longBreakFlag = true
            pomodoroFlag = false
            shortBreakFlag = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


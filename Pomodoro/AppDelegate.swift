//
//  AppDelegate.swift
//  Pomodoro
//
//  Created by Payal Kothari on 4/26/17.
//  Copyright © 2017 Payal Kothari. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var timeAtGoingBackground : Date?
    var tabBarController: UITabBarController?
    var currentTime : Int?
    var timerIsOn : Bool?
    var appStatus : String?
    var runningActivity : String?
    var player: AVAudioPlayer?
    
    enum Keys: String {
        case pomodoro, shortBreak, longBreak, numberOfPomodoros, music, distraction
    }
    
    let running = "Running"
    let pomodoro = "Pomodoro"
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound ], completionHandler: {allowed, error in })

        tabBarController = window?.rootViewController as? UITabBarController
        let navVC = tabBarController?.viewControllers![1] as! UINavigationController
        let settingsVC = navVC.viewControllers[0] as! SettingsVC
        let clockVCObject = tabBarController?.viewControllers![0] as! ClockVC
        let pomodoroUserDefault = UserDefaults.standard.object(forKey: Keys.pomodoro.rawValue)
        if pomodoroUserDefault == nil {
            UserDefaults.standard.set(25, forKey:Keys.pomodoro.rawValue)
            UserDefaults.standard.set(15, forKey:Keys.longBreak.rawValue)
            UserDefaults.standard.set(5, forKey:Keys.shortBreak.rawValue)
            UserDefaults.standard.set(4, forKey:Keys.numberOfPomodoros.rawValue)
            UserDefaults.standard.set(0, forKey:Keys.music.rawValue)
        }
        UserDefaults.standard.set(0, forKey:Keys.distraction.rawValue)
        settingsVC.clock = Clock()
        clockVCObject.clock = Clock()
            
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        timeAtGoingBackground = Date()
        
        if timerIsOn != nil && appStatus == running{
            if timerIsOn == true {
                let content = UNMutableNotificationContent()
                
                if runningActivity == pomodoro {
                    content.title = "Time for a break!!"
                    content.subtitle = "yayyy!!!"
                    content.body = " "
                    content.sound = UNNotificationSound.default()
                }else {
                    content.title = "Break is over!!"
                    content.subtitle = "Time to get back to work"
                    content.body = " "
                    content.sound = UNNotificationSound.default()
                }
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(currentTime!), repeats: false)
                let request = UNNotificationRequest(identifier: "pomodoro", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        var elapsedTime = 0
        let clockVC = ClockVC()
        if appStatus == running {
            elapsedTime = Int(Date().timeIntervalSince(timeAtGoingBackground!))
            clockVC.updateFromBackground(elapsedTime)
        } else {
            elapsedTime = 0
            clockVC.updateFromBackground(elapsedTime)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


//
//  Clock.swift
//  Pomodoro
//
//  Created by Payal Kothari on 4/26/17.
//  Copyright © 2017 Payal Kothari. All rights reserved.
//

import Foundation


class Clock : NSObject {
    var pomodoro = 25
    var longBreak = 15
    var shortBreak = 5
    var numberOfPomodoros = 4
    
    convenience override init() {
        let p = UserDefaults.standard.integer(forKey: "pomodoro")
        let l = UserDefaults.standard.integer(forKey: "longBreak")
        let s = UserDefaults.standard.integer(forKey: "shortBreak")
        let n = UserDefaults.standard.integer(forKey: "numberOfPomodoros")
        self.init(pomodoro: p, longBreak: l, shortBreak: s, numberOfPomodoros: n)
    }
    
    init(pomodoro : Int, longBreak : Int, shortBreak : Int, numberOfPomodoros : Int) {
        super.init()
        set(pomodoro: pomodoro)
        set(longBreak: longBreak)
        set(shortBreak: shortBreak)
        set(numberOfPomodoros: numberOfPomodoros)
    }
    
    func set(pomodoro : Int){
        self.pomodoro = pomodoro
    }
    
    func set(longBreak : Int){
        self.longBreak = longBreak
    }
    
    func set(shortBreak : Int){
        self.shortBreak = shortBreak
    }
    
    func set(numberOfPomodoros : Int){
        self.numberOfPomodoros = numberOfPomodoros
    }
    
    func getPomodoro() -> Int {
        return pomodoro
    }
    
    func getLongBreak() -> Int {
        return longBreak
    }
    
    func getShortBreak() -> Int {
        return shortBreak
    }
    
    func getNumberOfPomodoros() -> Int {
        return numberOfPomodoros
    }
}

//
//  SettingsVC.swift
//  Pomodoro
//
//  Created by Payal Kothari on 5/1/17.
//  Copyright © 2017 Payal Kothari. All rights reserved.
//

import UIKit
import Foundation

class SettingsVC: UITableViewController {
    
    let MIN = "mins"
    var clock = Clock()
    var dataSource2 : [Int]?
    let musicNames = ["Off", "Waterfall", "Meditation"]
    var dataSource = ["Pomodoro", "Short Break", "Long Break", "Number of Pomodoros", "Music"]
    enum Key: String {
        case pomodoro, shortBreak, longBreak, numberOfPomodoros, music
    }
    
    override func viewDidLoad() {
        dataSource2 = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clock = Clock()
        let pomodoro = self.clock.getPomodoro()
        let longBreak = self.clock.getLongBreak()
        let shortBreak = self.clock.getShortBreak()
        let totalPomodoro = self.clock.getNumberOfPomodoros()
        let music = UserDefaults.standard.integer(forKey: Key.music.rawValue)
        
        self.dataSource2?.insert(pomodoro, at: 0)
        self.dataSource2?.insert(shortBreak, at: 1)
        self.dataSource2?.insert(longBreak, at: 2)
        self.dataSource2?.insert(totalPomodoro, at: 3)
        self.dataSource2?.insert(music, at: 4)
        tableView.reloadData()
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationViewController = segue.destination as! SettingDetailVC
            destinationViewController.selectedItem = dataSource[indexPath.row]
            destinationViewController.selectedItemValue = dataSource2![indexPath.row]
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCellId", for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.row]
        if indexPath.row == 4 {
            let index = dataSource2![indexPath.row]
            cell.detailTextLabel?.text = musicNames[index]
        }else if indexPath.row == 3{
            cell.detailTextLabel?.text = String(describing: dataSource2![indexPath.row])
        }else {
            cell.detailTextLabel?.text = String(describing: dataSource2![indexPath.row]) + " " + MIN
        }
        

        return cell
    }
}

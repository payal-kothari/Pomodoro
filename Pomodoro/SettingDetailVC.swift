//
//  SettingDetailVC.swift
//  Pomodoro
//
//  Created by Payal Kothari on 5/1/17.
//  Copyright © 2017 Payal Kothari. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SettingDetailVC: UITableViewController {
    
    enum Keys: String {
        case pomodoro, shortBreak, longBreak, numberOfPomodoros, music
    }
    let cells = ["Pomodoro", "Short Break", "Long Break", "Number of Pomodoros", "Music"]
    
    var selectedItem : String?
    var selectedItemValue : Int?
    var player: AVAudioPlayer?
    let fileFormat = "mp3"
    let pomodoro = [1, 2, 25, 30, 35]
    let shortBreak = [1, 2, 3, 4, 5]
    let longBreak = [2, 15, 20, 25]
    let totalPomodoro = [ 2, 3, 4, 5]
    let music = ["Off", "Waterfall", "Meditation"]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        if selectedItem! == cells[0] {
            UserDefaults.standard.set(pomodoro[indexPath.row], forKey:Keys.pomodoro.rawValue)
            selectedItemValue = pomodoro[indexPath.row]
        }else if selectedItem! == cells[1] {
            UserDefaults.standard.set(shortBreak[indexPath.row], forKey:Keys.shortBreak.rawValue)
            selectedItemValue = shortBreak[indexPath.row]
        }else if selectedItem! == cells[2]{
            UserDefaults.standard.set(longBreak[indexPath.row], forKey:Keys.longBreak.rawValue)
            selectedItemValue = longBreak[indexPath.row]
        }else if selectedItem! == cells[3]{
            UserDefaults.standard.set(totalPomodoro[indexPath.row], forKey:Keys.numberOfPomodoros.rawValue)
            selectedItemValue = totalPomodoro[indexPath.row]
        }else if selectedItem! == cells[4] {
            UserDefaults.standard.set(indexPath.row, forKey:Keys.music.rawValue)
            selectedItemValue = indexPath.row
            if music[selectedItemValue!] == music[0] { // "off"
                stop()
            }else {
                play(index: selectedItemValue!)
            }
        }
        tableView.reloadData()
    }
    
    func stop() {
        if appDelegate.player != nil {
            appDelegate.player!.stop()
        }
    }
    
    func play(index: Int) {
        
        let file = music[index]
        if file != music[0] {   // "Off"
            if let soundFilePath = Bundle.main.path(forResource: file, ofType: fileFormat){
                let fileUrl = URL(fileURLWithPath: soundFilePath)
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
                    do {
                        try AVAudioSession.sharedInstance().setActive(true)
                    } catch {
                        print(error)
                    }
                } catch {
                    print(error)
                }
                
                do {
                    player = try AVAudioPlayer(contentsOf: fileUrl)
                } catch let error as NSError {
                    player = nil
                    print(error)
                }
            }else{
                player = nil
            }
            player!.numberOfLoops = -1
            player?.prepareToPlay()
            player!.play()
            appDelegate.player = player
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if selectedItem! == cells[0] {
            count = pomodoro.count
        }else if selectedItem! == cells[1] {
            count = shortBreak.count
        }else if selectedItem! == cells[2]{
            count = longBreak.count
        }else if selectedItem! == cells[3]{
            count = totalPomodoro.count
        }else if selectedItem! == cells[4] {
            count = music.count
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdDetailCellId", for: indexPath)
        cell.accessoryType = .none
        
        if selectedItem! == cells[0] {
            cell.textLabel?.text = String(pomodoro[indexPath.row])
            if pomodoro[indexPath.row] == selectedItemValue {
                cell.accessoryType = .checkmark
            }
        }else if selectedItem! == cells[1] {
            cell.textLabel?.text = String(shortBreak[indexPath.row])
            if shortBreak[indexPath.row] == selectedItemValue {
                cell.accessoryType = .checkmark
            }
        }else if selectedItem! == cells[2]{
            cell.textLabel?.text = String(longBreak[indexPath.row])
            if longBreak[indexPath.row] == selectedItemValue {
                cell.accessoryType = .checkmark
            }
        }else if selectedItem! == cells[3] {
            cell.textLabel?.text = String(totalPomodoro[indexPath.row])
            if totalPomodoro[indexPath.row] == selectedItemValue {
                cell.accessoryType = .checkmark
            }
        }else {
            cell.textLabel?.text = music[indexPath.row]
            if indexPath.row == selectedItemValue {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }

}

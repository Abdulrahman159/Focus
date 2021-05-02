//
//  ViewController.swift
//  Focus
//
//  Created by Abdulrahman Al-mutawa on 29/04/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = self.savedItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        savedItems.remove(at: indexPath.row)
        
        table.deleteRows(at: [indexPath], with: .automatic)
        UserDefaults.standard.removeObject(forKey: "final")
        
    }
    
    var savedItems: [String] = []
    
    override func viewDidLoad() {
        pauseButton.isHidden = true
        stopButton.isHidden = true
        resetButton.isHidden = true
        
        table.delegate = self
        table.dataSource = self
        table.separatorInset.left = 2
//        table.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "final") as? [String]{
        savedItems = x
        }
        self.table.reloadData()
//        let defaults = UserDefaults.standard
//        defaults.removeObject(forKey: "final")
    }
    
    
    var timer = Timer()
    
    var (minutes, second, fractions) = (0, 0, 0)
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fractionsLabel: UILabel!
    
   
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var table: UITableView!
    
    
    
    @IBAction func start(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.keepTimer), userInfo: nil, repeats: true)
        startButton.isHidden = true
        pauseButton.isHidden = false
        resetButton.isHidden = true
        stopButton.isHidden = true
   
    }
    
    @IBAction func pause(_ sender: UIButton) {
        timer.invalidate()
        startButton.isHidden = false
        pauseButton.isHidden = true
        stopButton.isHidden = false
        resetButton.isHidden = false
    }
    @IBAction func stop(_ sender: UIButton) {
        timer.invalidate()
        let secondsString = second > 9 ? "\(second)" : "0\(second)"
        let minuteString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let totalTime = "\(minuteString):\(secondsString):\(fractions)"
        let alert = UIAlertController(title: "Save", message: "\(totalTime)", preferredStyle:.alert)
        alert.view.clipsToBounds = true
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.black
        alert.addTextField()
        alert.textFields![0].placeholder = "Subject Studied"
        alert.textFields![0].keyboardType = UIKeyboardType.default
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler:{(action) in
            let subjectText = alert.textFields![0].text
            let date = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
            let finalOutput = "\(subjectText ?? "")    \(totalTime)    \(date)"
            self.add(finalOutput)
            print(self.savedItems)
//            self.savedItems.append(finalOutput)
//            self.table.reloadData()
            UserDefaults.standard.set(self.savedItems, forKey: "final")
            
        }))
        
        self.present(alert, animated: true)
    
    }
    
    func add(_ save: String){
        let index = 0
        savedItems.insert(save, at: index)
        
        let indePpath = IndexPath(row: index, section: 0)
        table.insertRows(at: [indePpath], with: .fade)
        
    }
    
    
    @IBAction func reset(_ sender: UIButton) {
        (minutes, second, fractions) = (0, 0, 0)
        timeLabel.text = "00:00"
        fractionsLabel.text = ".00"
    }
    
    @objc func keepTimer(){
        
        fractions += 1
        if fractions > 99 {
            second += 1
            fractions = 0
        }
        
        if second > 60{
            minutes += 1
            second = 0
        }
        
        let secondsString = second > 9 ? "\(second)" : "0\(second)"
        let minuteString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        timeLabel.text = "\(minuteString):\(secondsString)"
        fractionsLabel.text = ".\(fractions)"
    }
    
    
//    func saveAlert () -> String {
//        let secondsString = second > 9 ? "\(second)" : "0\(second)"
//        let minuteString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
//        let totalTime = "\(minuteString):\(secondsString):\(fractions)"
//        let alert = UIAlertController(title: "Save", message: "\(totalTime)", preferredStyle:.alert)
//        alert.addTextField()
//        alert.textFields![0].placeholder = "Subject Studied"
//        alert.textFields![0].keyboardType = UIKeyboardType.default
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
//        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: .none))
//        let subjectText = alert.textFields![0].text
//        let finalOutput = "\(subjectText ?? "")  \(totalTime)"
//        self.present(alert, animated: true)
//        savedItems.append(finalOutput)
//        return finalOutput
//    }
    

}

//extension ViewController : UITableViewDelegate {}
//extension ViewController : UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return savedItems.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel!.text = savedItems[indexPath.row]
//        return cell
//
//    }
//}

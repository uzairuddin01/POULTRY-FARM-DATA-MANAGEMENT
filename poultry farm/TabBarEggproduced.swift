//
//  TabBarEggproduced.swift
//  poultry farm
//
//  Created by Apple on 20/06/24.
//

import UIKit

class TabBarEggproduced: UIViewController {

    @IBOutlet weak var rst: UIButton!
    @IBOutlet weak var totalEggsLabel: UILabel!
    @IBOutlet weak var dailyProductionTableView: UITableView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var eggsProducedTextField: UITextField!
    
    var totalEggsThisMonth = 0
    var dailyEggProductions: [(date: String, eggs: Int)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEggsFromUserDefaults()
                updateEggsLabel()
                updateTableViewVisibility()
                eggsProducedTextField.layer.cornerRadius = 10
                eggsProducedTextField.layer.borderWidth = 1
                eggsProducedTextField.layer.masksToBounds = true

                dailyProductionTableView.delegate = self
                dailyProductionTableView.dataSource = self
                dailyProductionTableView.tableFooterView = UIView() 
        dailyProductionTableView.layer.cornerRadius = 20
        // Hide empty rows

                btn.layer.cornerRadius = 10
        rst.layer.cornerRadius = 10

       
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let text = eggsProducedTextField.text, let eggsProduced = Int(text) else {
                   showAlert(message: "Please enter a valid number of eggs.")
                   return
               }

               let currentDate = getCurrentDate()
               dailyEggProductions.append((date: currentDate, eggs: eggsProduced))
               totalEggsThisMonth += eggsProduced
                updateTableViewVisibility()
               saveEggsToUserDefaults()
               eggsProducedTextField.text = ""
               updateEggsLabel()
               dailyProductionTableView.reloadData()
               showConfirmationAlert()
    }
    
   
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
        totalEggsThisMonth = 0
                dailyEggProductions.removeAll()
                updateEggsLabel()
                updateTableViewVisibility()
                dailyProductionTableView.reloadData()
                removeEggsFromUserDefaults()
    }
    
    func updateEggsLabel() {
         totalEggsLabel.text = "Eggs Produced This Month: \(totalEggsThisMonth)"
     }

     func showAlert(message: String) {
         let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(alert, animated: true, completion: nil)
     }

     func showConfirmationAlert() {
         let alert = UIAlertController(title: "Success!", message: "Eggs saved successfully!", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(alert, animated: true, completion: nil)
     }

     func getCurrentDate() -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd-MM-yyyy "
         return dateFormatter.string(from: Date())
     }

     func saveEggsToUserDefaults() {
         let eggData = dailyEggProductions.map { "\($0.date),\($0.eggs)" }.joined(separator: ";")
         UserDefaults.standard.set(eggData, forKey: "dailyEggProductions")
         UserDefaults.standard.set(totalEggsThisMonth, forKey: "totalEggsThisMonth")
     }

     func loadEggsFromUserDefaults() {
         if let eggDataString = UserDefaults.standard.string(forKey: "dailyEggProductions") {
             let entries = eggDataString.components(separatedBy: ";")
             dailyEggProductions = entries.map {
                 let components = $0.components(separatedBy: ",")
                 return (date: components[0], eggs: Int(components[1]) ?? 0)
             }
         }

         totalEggsThisMonth = UserDefaults.standard.integer(forKey: "totalEggsThisMonth")
     }

     func removeEggsFromUserDefaults() {
         UserDefaults.standard.removeObject(forKey: "dailyEggProductions")
         UserDefaults.standard.removeObject(forKey: "totalEggsThisMonth")
     }
    func updateTableViewVisibility() {
            dailyProductionTableView.isHidden = (totalEggsThisMonth == 0)
        }
 }

 extension TabBarEggproduced: UITableViewDelegate, UITableViewDataSource {

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return dailyEggProductions.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         let entry = dailyEggProductions[indexPath.row]
         cell.textLabel?.text = "\(entry.date):      \(entry.eggs) Eggs produced"
         return cell
     }
 }

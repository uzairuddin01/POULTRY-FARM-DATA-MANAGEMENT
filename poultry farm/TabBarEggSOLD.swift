//
//  TabBarEggSOLD.swift
//  poultry farm
//
//  Created by Apple on 20/06/24.
//

import UIKit

class TabBarEggSOLD: UIViewController {

    
    @IBOutlet weak var rst: UIButton!
    @IBOutlet weak var totalEggsSoldLabel: UILabel!
    @IBOutlet weak var dailySoldTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var eggsSoldTextField: UITextField!
    
    var totalEggsSoldThisMonth = 0
    var dailyEggsSold: [(date: String, eggs: Int)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEggsFromUserDefaults()
               updateEggsSoldLabel()
                updateTableViewVisibility()
               eggsSoldTextField.layer.cornerRadius = 10
               eggsSoldTextField.layer.borderWidth = 1
               eggsSoldTextField.layer.masksToBounds = true

               dailySoldTableView.delegate = self
               dailySoldTableView.dataSource = self
               dailySoldTableView.tableFooterView = UIView() // Hide empty rows

               // Register the table view cell identifier
               dailySoldTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        dailySoldTableView.layer.cornerRadius = 20
      //  dailySoldTableView.layer.backgroundColor = UIColor.lightGray
               saveButton.layer.cornerRadius = 10
        rst.layer.cornerRadius = 10

        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let text = eggsSoldTextField.text, let eggsSold = Int(text) else {
                    showAlert(message: "Please enter a valid number of eggs.")
                    return
                }

                let currentDate = getCurrentDate()
                dailyEggsSold.append((date: currentDate, eggs: eggsSold))
                totalEggsSoldThisMonth += eggsSold

                saveEggsToUserDefaults()
                eggsSoldTextField.text = ""
                updateEggsSoldLabel()
                dailySoldTableView.reloadData()
                showConfirmationAlert()
                updateTableViewVisibility()
    }
    
   
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        totalEggsSoldThisMonth = 0
                dailyEggsSold.removeAll()
                updateEggsSoldLabel()
                updateTableViewVisibility()
                dailySoldTableView.reloadData()
                removeEggsFromUserDefaults()
    }
    
   
    func updateEggsSoldLabel() {
           totalEggsSoldLabel.text = "Eggs Sold This Month: \(totalEggsSoldThisMonth)"
       }

       func showAlert(message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }

       func showConfirmationAlert() {
           let alert = UIAlertController(title: "Success!", message: "Eggs sold saved successfully!", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }

       func getCurrentDate() -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd-MM-yyyy"
           return dateFormatter.string(from: Date())
       }

       func saveEggsToUserDefaults() {
           let eggData = dailyEggsSold.map { "\($0.date),\($0.eggs)" }.joined(separator: ";")
           UserDefaults.standard.set(eggData, forKey: "dailyEggsSold")
           UserDefaults.standard.set(totalEggsSoldThisMonth, forKey: "totalEggsSoldThisMonth")
       }

       func loadEggsFromUserDefaults() {
           if let eggDataString = UserDefaults.standard.string(forKey: "dailyEggsSold") {
               let entries = eggDataString.components(separatedBy: ";")
               dailyEggsSold = entries.map {
                   let components = $0.components(separatedBy: ",")
                   return (date: components[0], eggs: Int(components[1]) ?? 0)
               }
           }

           totalEggsSoldThisMonth = UserDefaults.standard.integer(forKey: "totalEggsSoldThisMonth")
       }

       func removeEggsFromUserDefaults() {
           UserDefaults.standard.removeObject(forKey: "dailyEggsSold")
           UserDefaults.standard.removeObject(forKey: "totalEggsSoldThisMonth")
       }
    func updateTableViewVisibility() {
            dailySoldTableView.isHidden = (totalEggsSoldThisMonth == 0)
        }
   }

   extension TabBarEggSOLD: UITableViewDelegate, UITableViewDataSource {

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return dailyEggsSold.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           let entry = dailyEggsSold[indexPath.row]
           cell.textLabel?.text = "\(entry.date):      \(entry.eggs) Eggs Sold"
           return cell
       }
   }

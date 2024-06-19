//
//  mortalityViewController.swift
//  poultry farm
//
//  Created by Apple on 18/06/24.
//

import UIKit

class mortalityViewController: UIViewController {

    @IBOutlet weak var dailyMortalityTableView: UITableView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var eggsProducedTextField: UITextField!
    @IBOutlet weak var totalEggsLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    var totalMortalityThisMonth = 0
    var dailyMortality: [(date: String, mortality: Int)] = []

    @IBOutlet weak var rst: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.cornerRadius = 10
               eggsProducedTextField.layer.cornerRadius = 10
               eggsProducedTextField.layer.borderWidth = 1
               eggsProducedTextField.layer.masksToBounds = true
               
               dailyMortalityTableView.delegate = self
               dailyMortalityTableView.dataSource = self
               dailyMortalityTableView.tableFooterView = UIView() // Hide empty rows
               dailyMortalityTableView.layer.cornerRadius = 20
               
               // Register the table view cell identifier
               dailyMortalityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
                updateTableViewVisibility()
               rst.layer.cornerRadius = 10
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
        totalMortalityThisMonth = 0 // Reset mortality count
                dailyMortality.removeAll()
                updateMortalityLabel()
                dailyMortalityTableView.reloadData()
                removeMortalityFromUserDefaults()
                updateTableViewVisibility()
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let text = eggsProducedTextField.text,
                     let eggsProduced = Int(text) else {
                   // Handle invalid input
                   showAlert(message: "Please enter a valid number of Mortality.")
                   return
               }
               
               let currentDate = getCurrentDate()
               dailyMortality.append((date: currentDate, mortality: eggsProduced))
               totalMortalityThisMonth += eggsProduced
               updateTableViewVisibility()
               saveMortalityToUserDefaults()
               eggsProducedTextField.text = ""
               updateMortalityLabel()
               dailyMortalityTableView.reloadData()
               showConfirmationAlert()
          }

    func updateMortalityLabel() {
           totalEggsLabel.text = "Total Mortality This Month: \(totalMortalityThisMonth)"
       }

       func showConfirmationAlert() {
           let alert = UIAlertController(title: "Success!", message: "Mortality saved successfully!", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }

       func showAlert(message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }

       func getCurrentDate() -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           return dateFormatter.string(from: Date())
       }

       func saveMortalityToUserDefaults() {
           let mortalityData = dailyMortality.map { "\($0.date),\($0.mortality)" }.joined(separator: ";")
           UserDefaults.standard.set(mortalityData, forKey: "dailyMortality")
           UserDefaults.standard.set(totalMortalityThisMonth, forKey: "totalMortalityThisMonth")
       }

       func loadMortalityFromUserDefaults() {
           if let mortalityDataString = UserDefaults.standard.string(forKey: "dailyMortality") {
               let entries = mortalityDataString.components(separatedBy: ";")
               dailyMortality = entries.map {
                   let components = $0.components(separatedBy: ",")
                   return (date: components[0], mortality: Int(components[1]) ?? 0)
               }
           }

           totalMortalityThisMonth = UserDefaults.standard.integer(forKey: "totalMortalityThisMonth")
       }

       func removeMortalityFromUserDefaults() {
           UserDefaults.standard.removeObject(forKey: "dailyMortality")
           UserDefaults.standard.removeObject(forKey: "totalMortalityThisMonth")
       }
    func updateTableViewVisibility() {
            dailyMortalityTableView.isHidden = (totalMortalityThisMonth == 0)
        }
   }

   extension mortalityViewController: UITableViewDelegate, UITableViewDataSource {

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return dailyMortality.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           let entry = dailyMortality[indexPath.row]
           cell.textLabel?.text = "\(entry.date): \(entry.mortality) mortality"
           return cell
       }
   }

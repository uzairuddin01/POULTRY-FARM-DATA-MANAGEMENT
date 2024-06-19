//
//  eggViewController.swift
//  poultry farm
//
//  Created by Apple on 18/06/24.
//

import UIKit

class eggViewController: UIViewController {
    
    @IBOutlet weak var dailyProductionTableView: UITableView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var eggsProducedTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var totalEggsLabel: UILabel!
    var totalEggsThisMonth = 0
    var dailyEggProductions: [(date: String, eggs: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEggsFromUserDefaults()
               updateEggsLabel()

               eggsProducedTextField.layer.cornerRadius = 10
               eggsProducedTextField.layer.borderWidth = 1
               eggsProducedTextField.layer.masksToBounds = true

               dailyProductionTableView.delegate = self
               dailyProductionTableView.dataSource = self
               dailyProductionTableView.tableFooterView = UIView() // Hide empty rows
        dailyProductionTableView.backgroundColor = UIColor.systemBackground
               btn.layer.cornerRadius = 10

               let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetButtonPressed))
               navigationItem.rightBarButtonItem = resetButton
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        totalEggsThisMonth = 0
        dailyEggProductions.removeAll()
        updateEggsLabel()
        dailyProductionTableView.reloadData()
        removeEggsFromUserDefaults()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let text = eggsProducedTextField.text, let eggsProduced = Int(text) else {
                    showAlert(message: "Please enter a valid number of eggs.")
                    return
                }

                let currentDate = getCurrentDate()
                dailyEggProductions.append((date: currentDate, eggs: eggsProduced))
                totalEggsThisMonth += eggsProduced

                saveEggsToUserDefaults()
                eggsProducedTextField.text = ""
                updateEggsLabel()
                dailyProductionTableView.reloadData()
                showConfirmationAlert()
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
  }

  extension eggViewController: UITableViewDelegate, UITableViewDataSource {

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return dailyEggProductions.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
          let entry = dailyEggProductions[indexPath.row]
          cell.textLabel?.text = "\(entry.date):      \(entry.eggs) Eggs Added"
          return cell
      }
  }

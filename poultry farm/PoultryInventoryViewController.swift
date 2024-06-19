//
//  PoultryInventoryViewController.swift
//  poultry farm
//
//  Created by Apple on 18/06/24.
//

import UIKit
import CoreData

class PoultryInventoryViewController: UIViewController,UITableViewDelegate ,UITableViewDataSource{
    
    private var poultryList: [Poultryfarm] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PoultryCell", bundle: nil), forCellReuseIdentifier: "PoultryCell")
        fetchPoultryData()
        tableView.reloadData()
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poultryList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PoultryCell", for: indexPath) as? PoultryCell else {
                fatalError("The dequeued cell is not an instance of PoultryCell.")
            }
            
            let poultry = poultryList[indexPath.row]
            cell.nameLabel.text = " \(poultry.name!)"
            cell.quantityLabel.text = "Quantity : \(poultry.quantity)"
            //cell.priceLabel.text = "Price: ₹\(String(format: "%.2f", poultry.purchasePrice))"
            return cell
        }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              deletePoultry(at: indexPath)
          }
      }
      
      // Tap to edit
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let selectedPoultry = poultryList[indexPath.row]
          showAlertToAddOrUpdatePoultry(poultry: selectedPoultry)
          fetchPoultryData()
          tableView.reloadData()
      }
  

    
    
    
    
    
    private func fetchPoultryData() {
           let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
           let fetchRequest: NSFetchRequest<Poultryfarm> = Poultryfarm.fetchRequest()
           
           do {
               poultryList = try context.fetch(fetchRequest)
               
               tableView.reloadData()
           } catch {
               print("Failed to fetch poultry: \(error)")
           }
       }
    
    
    @IBAction func addNewItem(_ sender: Any) {
        
        showAlertToAddOrUpdatePoultry()
        tableView.reloadData()


           }
           
    private func savePoultry(name: String, quantity: Int64) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newPoultry = Poultryfarm(context: context)
        newPoultry.name = name
        newPoultry.quantity = quantity
      //  newPoultry.purchasePrice = price
        tableView.reloadData()
        do {
            try context.save()
            poultryList.append(newPoultry)
            tableView.reloadData()
        } catch {
            print("Failed to save poultry: \(error)")
        }
    }
    private func updatePoultry(poultry: Poultryfarm, name: String, quantity: Int64) {
           let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        

        poultry.name = name
        poultry.quantity = quantity
        //poultry.purchasePrice = price
           
           do {
               try context.save()
               fetchPoultryData()
           } catch {
               print("Failed to update poultry: \(error)")
           }
       }
       
       private func deletePoultry(at indexPath: IndexPath) {
           let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
           context.delete(poultryList[indexPath.row])
           
           do {
               try context.save()
               poultryList.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .fade)
           } catch {
               print("Failed to delete poultry: \(error)")
           }
       }
    
    
    private func showAlertToAddOrUpdatePoultry(poultry: Poultryfarm? = nil) {
            let isUpdating = poultry != nil
            let alert = UIAlertController(title: isUpdating ? "Update Poultry" : "Add Poultry", message: "Enter details", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Product Name"
                textField.text = poultry?.name
            }
            alert.addTextField { (textField) in
                textField.placeholder = "Quantity"
                textField.keyboardType = .numberPad
                textField.text = poultry != nil ? "\(poultry!.quantity)" : ""
            }
        /*     alert.addTextField { (textField) in
                textField.placeholder = "Price"
                textField.keyboardType = .decimalPad
                textField.text = poultry != nil ? "\(poultry!.purchasePrice)" : ""
            }*/
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
            alert.addAction(UIAlertAction(title: isUpdating ? "Update" : "Add", style: .default, handler: { [weak self] (_) in
                guard let name = alert.textFields?[0].text,
                      let quantityString = alert.textFields?[1].text,
                      let quantity = Int64(quantityString)
                   //   let priceString = alert.textFields?[2].text,
                    //  let price = Double(priceString)
                        
                else { return }
                if let poultry = poultry {
                    self?.updatePoultry(poultry: poultry, name: name, quantity: quantity)
                } else {
                    self?.savePoultry(name: name, quantity: quantity)
                    
                }
            }))
            self.present(alert, animated: true)
        }

           }




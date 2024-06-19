import UIKit

// Struct to represent an inventory item
struct InventoryItem: Codable {
    var quantity: String?
}

class InventoryViewController: UIViewController {

    let rawMaterials = ["Soya bean", "Maize", "Broken rice", "GDGS", "DORB"]
    let medicines = ["MCP", "Lysine", "DLM", "LIVER POWDER", "ENZYMES", "PHYTAGE", "ACIDICFIRE", "CHOLINE CHLORIDE"]
    var inventoryData: [String: InventoryItem] = [:]

    var quantityTextFields: [UITextField] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInventoryData()

    }

    func setupUI() {
        let margin: CGFloat = 20
        var yOffset: CGFloat = 100

        // Add Raw Materials section
        let rawMaterialsLabel = UILabel(frame: CGRect(x: margin, y: yOffset, width: 200, height: 30))
        rawMaterialsLabel.text = "Raw Materials"
        rawMaterialsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(rawMaterialsLabel)
        yOffset += 40

        for item in rawMaterials {
            addItemToView(item: item, yOffset: &yOffset)
        }

        // Add Medicines section
        yOffset += 20  // Add some space before the next section
        let medicinesLabel = UILabel(frame: CGRect(x: margin, y: yOffset, width: 200, height: 30))
        medicinesLabel.text = "Medicines"
        medicinesLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(medicinesLabel)
        yOffset += 40

        for item in medicines {
            addItemToView(item: item, yOffset: &yOffset)
        }

        let saveButton = UIButton(frame: CGRect(x: margin, y: yOffset + 20, width: 100, height: 40))
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        let resetButton = UIButton(frame: CGRect(x: margin + 120, y: yOffset + 20, width: 100, height: 40))
        resetButton.setTitle("Reset", for: .normal)
        resetButton.backgroundColor = .systemRed
        resetButton.layer.cornerRadius = 10
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        view.addSubview(resetButton)
    }

    func addItemToView(item: String, yOffset: inout CGFloat) {
        let margin: CGFloat = 20

        let itemLabel = UILabel(frame: CGRect(x: margin, y: yOffset, width: 160, height: 30))
        itemLabel.text = item
        view.addSubview(itemLabel)
        
        let quantityTextField = UITextField(frame: CGRect(x: margin + 170, y: yOffset, width: 140, height: 30))
        quantityTextField.borderStyle = .roundedRect
        quantityTextField.placeholder = "Qty"
        view.addSubview(quantityTextField)
        quantityTextFields.append(quantityTextField)
        
        yOffset += 40
    }

    @objc func saveButtonTapped() {
        for (index, item) in (rawMaterials + medicines).enumerated() {
            let quantityText = quantityTextFields[index].text
            let inventoryItem = InventoryItem(quantity: quantityText)
            inventoryData[item] = inventoryItem
        }
        
        saveInventoryData()
        showAlert(message: "Items saved successfully.")
    }

    @objc func resetButtonTapped() {
        inventoryData.removeAll()
        saveInventoryData()
        for textField in quantityTextFields {
            textField.text = ""
        }
        showAlert(message: "Inventory reset successfully.")
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func saveInventoryData() {
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(inventoryData) {
            defaults.set(encoded, forKey: "inventoryData")
        }
    }

    func loadInventoryData() {
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "inventoryData") as? Data {
            if let decodedData = try? JSONDecoder().decode([String: InventoryItem].self, from: savedData) {
                inventoryData = decodedData
            }
        }
       
        for (index, item) in (rawMaterials + medicines).enumerated() {
            if let data = inventoryData[item] {
                quantityTextFields[index].text = data.quantity
            }
        }
    }
}

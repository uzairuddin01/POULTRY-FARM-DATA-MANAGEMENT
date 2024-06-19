//
//  feedback.swift
//  poultry farm
//
//  Created by Apple on 19/06/24.
//

import UIKit

class feedback: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(emailLabelTapped))
            emailLabel.isUserInteractionEnabled = true
            emailLabel.addGestureRecognizer(tapGesture)
        }
        
        @objc func emailLabelTapped() {
            if let url = URL(string: "https://mailto:mduzairuddin01@gmail.com") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("Mail app is not available")
                }
            }
        }
    }
